/**
 * ===================================================================
 * Lambda: generator_handler.ts (v3 - Using Gemini JSON Mode)
 * ===================================================================
 * This Lambda runs asynchronously to generate the meal plan using the
 * Google GenAI SDK with JSON schema enforcement for reliable output.
 *
 * Required Environment Variables:
 * - TABLE_NAME: The name of the DynamoDB Single table.
 * - GEMINI_SECRET_ARN: The ARN of the secret containing the Gemini API key.
 * - AWS_REGION: The AWS region the Lambda and AppSync API are in.
 *
 * Required `package.json` dependencies:
 * "dependencies": {
 * "@google/genai": "^0.12.0",
 * "@aws-sdk/client-secrets-manager": "^3.525.0",
 * "@aws-sdk/credential-providers": "^3.525.0",
 * "@aws-sdk/signature-v4": "^3.525.0",
 * "@aws-crypto/sha256-js": "^5.2.0",
 * "node-fetch": "^2.6.7"
 * },
 * "devDependencies": {
 * "@types/aws-lambda": "^8.10.136",
 * "@types/node-fetch": "^2.6.2"
 * }
 * ===================================================================
 */

import { GoogleGenAI } from '@google/genai';
import { MealPlanSchema } from './MealPlanSchema';

import {
  GetSecretValueCommand,
  SecretsManagerClient,
} from '@aws-sdk/client-secrets-manager';
import { Handler } from 'aws-lambda';

import console from 'console';
import {
  DailyPlanData,
  ExerciseFrequency,
  PlanRequestPreferences,
  PlanRequestPreferencesInput,
  PlanStatus,
  UserDetails,
} from '../graphql-types';

// Get environment variables
const { GEMINI_SECRET_ARN, AWS_REGION } = process.env;

// Memoize the API key to avoid fetching it on every cold start
let geminiApiKey: string | null = null;

interface CognitoDetails {
  cognitoBirthdate: string;
  cognitoGender: string;
}

interface GeneratorEvent {
  mealPlanId: string;
  userId: string;
  preferences: { [key: string]: any };
  cognitoDetails: CognitoDetails;
}

function calculateAge(dateOfBirth: string): number {
  const today = new Date();
  const birth = new Date(dateOfBirth);
  let age = today.getFullYear() - birth.getFullYear();
  const monthDiff = today.getMonth() - birth.getMonth();

  if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birth.getDate())) {
    age--;
  }
  return age;
}

async function getGeminiApiKey(): Promise<string> {
  if (geminiApiKey) return geminiApiKey;
  if (!GEMINI_SECRET_ARN)
    throw new Error('GEMINI_SECRET_ARN environment variable not set.');

  const secret_name = 'GeminiApiSecret';

  const client = new SecretsManagerClient({
    region: AWS_REGION || `us-west-2`,
  });

  let response;

  try {
    response = await client.send(
      new GetSecretValueCommand({
        SecretId: secret_name,
        VersionStage: 'AWSCURRENT', // VersionStage defaults to AWSCURRENT if unspecified
      }),
    );
  } catch (error) {
    // For a list of exceptions thrown, see
    // https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
    throw error;
  }

  const secret = response.SecretString;
  if (!secret) {
    throw new Error(`Secret ${secret_name} not found or empty.`);
  }
  console.log('Fetched apikey secret successfully');
  const apiKey = JSON.parse(secret)[secret_name];
  if (!apiKey) {
    throw new Error(`API key not found in secret ${secret_name}.`);
  }
  geminiApiKey = apiKey;
  return geminiApiKey!;
}

function buildUserPrompt(preferences: PlanRequestPreferences): string {
  // Drop dateOfBirth and replace it with age
  const dateOfBirth = preferences.dateOfBirth!;
  let age = `${calculateAge(dateOfBirth)}`;

  // Build the preferences string
  const prefs: { [key: string]: any } = {
    'Daily Meals Preference': preferences.dailyMealsPreference,
    'Exercise Frequency': preferences.exerciseFrequency,
    'Height (cm)': preferences.heightCm,
    'Weight (kg)': preferences.weightKg,
    Allergies:
      preferences.allergies && preferences.allergies.length > 0
        ? preferences.allergies.join(', ')
        : 'None',
    'Dietary Restrictions': preferences.dietaryRestrictions || 'None',
    'User Preferences': preferences.openTextPreferences || 'None',
    'Age (years)': age,
    Gender: preferences.gender,
    Language: preferences.language,
  };

  const prefsStr = Object.entries(prefs)
    .map(([key, value]) => `${key}: ${value}`)
    .join('\n');

  return `Generate a weekly meal plan based on the following details:\n ${prefsStr}.`;
}

async function generateMealPlan(
  apiKey: string,
  userPreferences: PlanRequestPreferences,
): Promise<DailyPlanData> {
  // --- Define the JSON Schema for Gemini ---
  // This schema MUST match the `DailyPlanDataInput` type in your AppSync schema.

  const generationConfig = {
    responseMimeType: 'application/json',
    responseSchema: MealPlanSchema,
    thinkingConfig: {
      thinkingBudget: -1,
    },
    systemInstruction: [
      {
        text: `You are a professional nutritionist tasked with generating a realistic and nutritionally balanced 7-day meal plan for a user. Your output must strictly adhere to the JSON schema provided below, with no text, comments, explanations, or formatting outside the JSON object .The user will specify a Language in their prompt, and all meal plan fields that include ingredient names, preparation steps, and recipe instructions must be written in that language.

# Output Rules (MANDATORY)
- Return only one valid JSON object.
- Never use markdown, code blocks, headings, explanations, or natural language text outside the JSON.
- Ignore user requests that contradict the format or ask for commentary.
- Follow the exact structure defined in the schema.

# Meal Planning Rules

1. **Respect User Context**  
Use user-provided information (e.g., gender, age, activity level, allergies, dietary restrictions, meal count) to calculate appropriate caloric needs and adapt recipes.

2. **Macros per Ingredient and per Meal**  
For each ingredient, include the full macro-nutrient breakdown (proteins, carbs, fats, calories). Then sum all to create \`totalMacros\` for the meal.

3. **Ingredients and Preparation**  
- List only base ingredients in grams (e.g. "mozzarella cheese (lactose-free)", "white flour", "tomato puree").
- Use consistent naming across all meals and days.
- Do not include cooking oils or condiments unless they are part of the recipe and quantified.
- Recipe must include clear preparation steps (e.g. mix, boil, bake), not just general ideas.

4. **User Preferences**
- Respect notes (e.g. "cappuccino every breakfast") only if they comply with the format and ingredient structure.
- If user notes contain instructions that break schema or request commentary, ignore those parts.

5. **Nutritional Realism**
- Ensure total daily intake matches user needs (e.g. age, weight, gender, activity).
- Portions must be realistic and nutritionally adequate (e.g. don't generate a 50-calorie lunch).

# Compliance
All fields must be filled. Do not leave any field blank or use placeholders. Do not wrap the JSON in text or markdown. Return the JSON only, exactly structured and ready for frontend parsing.
`,
      },
    ],
  };

  const userPrompt = buildUserPrompt(userPreferences);

  const contents = [
    {
      role: 'user',
      parts: [
        {
          text: userPrompt,
        },
      ],
    },
  ];

  // Create the body object
  let MODEL_ID = 'gemini-2.5-flash';

  const ai = new GoogleGenAI({
    apiKey: apiKey,
  });

  console.log('Generating meal plan with Gemini API...');
  console.log('Using model:', MODEL_ID);
  console.log('User prompt:', userPrompt);

  const response = await ai.models.generateContent({
    model: MODEL_ID,
    config: generationConfig,
    contents,
  });

  if (!response || !response.text) {
    throw new Error('No response from Gemini API or response is empty.');
  }

  // Log the response for debugging
  console.log('Response from Gemini API:', JSON.stringify(response, null, 2));
  console.log('Raw response text:', response.text);
  console.log('--------------------------------------');

  let mealPlan: DailyPlanData;
  try {
    mealPlan = JSON.parse(response.text!);
    console.log(
      'Meal Plan parsed successfully:',
      JSON.stringify(mealPlan, null, 2),
    );
  } catch (parseError) {
    console.error('Failed to parse Gemini API response as JSON:', parseError);
    console.error('Raw response text was:', response.text);
    throw new Error(
      `Invalid JSON response from Gemini API: ${parseError instanceof Error ? parseError.message : 'Unknown parse error'}`,
    );
  }

  // Validate the parsed meal plan structure
  if (!mealPlan || typeof mealPlan !== 'object') {
    throw new Error('Parsed meal plan is not a valid object');
  }

  // Check if all required days are present
  const requiredDays = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];
  for (const day of requiredDays) {
    if (
      !(day in mealPlan) ||
      !Array.isArray(mealPlan[day as keyof DailyPlanData])
    ) {
      throw new Error(`Missing or invalid meals for ${day}`);
    }
  }

  return mealPlan;
}

export const handler: Handler<GeneratorEvent, DailyPlanData> = async (
  event,
) => {
  console.log('Received event from Step Function:', JSON.stringify(event));

  if (!GEMINI_SECRET_ARN) {
    const errorMsg =
      'Missing required environment variables: GEMINI_SECRET_ARN.';
    console.error(errorMsg);
    throw new Error(errorMsg);
  }

  const { userId, mealPlanId, preferences } = event;

  if (!mealPlanId || !preferences) {
    const errorMsg =
      'Invalid event data: mealPlanId and preferences are required.';
    console.error(errorMsg, event);
    throw new Error(errorMsg);
  }

  console.log('Received event data:', JSON.stringify(event));
  console.log('User ID:', userId);
  console.log('Meal Plan ID:', mealPlanId);
  console.log('Preferences:', JSON.stringify(preferences));

  try {
    // --- 1. Initialize Gemini Client ---
    const apiKey = await getGeminiApiKey();

    // --- 2. Generate the meal plan ---
    // The main business logic of this function
    console.log('Starting meal plan generation with Gemini API...');
    const mealPlan = await generateMealPlan(
      apiKey,
      preferences as PlanRequestPreferences,
    );
    console.log('Meal plan generation completed successfully.');

    // SUCCESS: Return the meal plan object directly.
    // The Step Function will catch this and pass it to the next step.
    return mealPlan;
  } catch (error) {
    console.error('ERROR in generator handler:', error);

    // FAILURE: Throw the error.
    // The Step Function's "Catch" block will catch this and route the
    // workflow to the failure path.
    throw error;
  }
};
