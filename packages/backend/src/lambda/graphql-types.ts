export type Maybe<T> = T | null;
export type InputMaybe<T> = Maybe<T>;
export type Exact<T extends { [key: string]: unknown }> = {
  [K in keyof T]: T[K];
};
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & {
  [SubKey in K]?: Maybe<T[SubKey]>;
};
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & {
  [SubKey in K]: Maybe<T[SubKey]>;
};
export type MakeEmpty<
  T extends { [key: string]: unknown },
  K extends keyof T,
> = { [_ in K]?: never };
export type Incremental<T> =
  | T
  | {
      [P in keyof T]?: P extends ' $fragmentName' | '__typename' ? T[P] : never;
    };
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: { input: string; output: string };
  String: { input: string; output: string };
  Boolean: { input: boolean; output: boolean };
  Int: { input: number; output: number };
  Float: { input: number; output: number };
  AWSDate: { input: string; output: string };
  AWSDateTime: { input: string; output: string };
  AWSEmail: { input: string; output: string };
  AWSJSON: { input: { [key: string]: any }; output: { [key: string]: any } };
  AWSURL: { input: string; output: string };
};

export enum AllergenEnum {
  CELERY = 'CELERY',
  CRUSTACEANS = 'CRUSTACEANS',
  EGGS = 'EGGS',
  FISH = 'FISH',
  GLUTEN_CEREALS = 'GLUTEN_CEREALS',
  LUPIN = 'LUPIN',
  MILK = 'MILK',
  MOLLUSCS = 'MOLLUSCS',
  MUSTARD = 'MUSTARD',
  NUTS = 'NUTS',
  PEANUTS = 'PEANUTS',
  SESAME_SEEDS = 'SESAME_SEEDS',
  SOYBEANS = 'SOYBEANS',
  SULPHITES = 'SULPHITES',
}

export type AssignNutritionistInput = {
  mealPlanId: Scalars['ID']['input'];
  nutritionistId: Scalars['ID']['input'];
};

export type ChatMessage = {
  __typename?: 'ChatMessage';
  chatId: Scalars['ID']['output'];
  messageContent: Scalars['String']['output'];
  messageId: Scalars['ID']['output'];
  recipientId: Scalars['ID']['output'];
  senderId: Scalars['ID']['output'];
  senderName?: Maybe<Scalars['String']['output']>;
  senderType: SenderType;
  sentAt: Scalars['AWSDateTime']['output'];
};

export type ChatMessageConnection = {
  __typename?: 'ChatMessageConnection';
  items: Array<ChatMessage>;
  nextToken?: Maybe<Scalars['String']['output']>;
};

export type ChatMessagesResponse = {
  __typename?: 'ChatMessagesResponse';
  count: Scalars['Int']['output'];
  hasMore: Scalars['Boolean']['output'];
  messages: Array<ChatMessage>;
  oldestTimestamp?: Maybe<Scalars['String']['output']>;
};

export type ChatMetadata = {
  __typename?: 'ChatMetadata';
  chatId: Scalars['ID']['output'];
  createdAt?: Maybe<Scalars['AWSDateTime']['output']>;
  lastMessageSnippet?: Maybe<Scalars['String']['output']>;
  lastMessageTimestamp?: Maybe<Scalars['AWSDateTime']['output']>;
  mealPlanId: Scalars['ID']['output'];
  nutritionistGivenName?: Maybe<Scalars['String']['output']>;
  nutritionistId: Scalars['ID']['output'];
  nutritionistUnreadCount?: Maybe<Scalars['Int']['output']>;
  planName?: Maybe<Scalars['String']['output']>;
  userGivenName?: Maybe<Scalars['String']['output']>;
  userId: Scalars['ID']['output'];
  userUnreadCount?: Maybe<Scalars['Int']['output']>;
};

export type ChatMetadataConnection = {
  __typename?: 'ChatMetadataConnection';
  items: Array<ChatMetadata>;
  nextToken?: Maybe<Scalars['String']['output']>;
};

export type ChatResponse = {
  __typename?: 'ChatResponse';
  message?: Maybe<ChatMessage>;
  recipientId: Scalars['ID']['output'];
};

export type CreateMealPlanInput = {
  dailyPlan: DailyPlanDataInput;
  endDate: Scalars['AWSDate']['input'];
  planName: Scalars['String']['input'];
  startDate: Scalars['AWSDate']['input'];
  status?: InputMaybe<PlanStatus>;
};

export type DailyPlanData = {
  __typename?: 'DailyPlanData';
  friday?: Maybe<Array<Meal>>;
  monday?: Maybe<Array<Meal>>;
  saturday?: Maybe<Array<Meal>>;
  sunday?: Maybe<Array<Meal>>;
  thursday?: Maybe<Array<Meal>>;
  tuesday?: Maybe<Array<Meal>>;
  wednesday?: Maybe<Array<Meal>>;
};

export type DailyPlanDataInput = {
  friday?: InputMaybe<Array<MealInput>>;
  monday?: InputMaybe<Array<MealInput>>;
  saturday?: InputMaybe<Array<MealInput>>;
  sunday?: InputMaybe<Array<MealInput>>;
  thursday?: InputMaybe<Array<MealInput>>;
  tuesday?: InputMaybe<Array<MealInput>>;
  wednesday?: InputMaybe<Array<MealInput>>;
};

export enum ExerciseFrequency {
  EVERY_DAY = 'EVERY_DAY',
  FIVE_TIMES_A_WEEK = 'FIVE_TIMES_A_WEEK',
  FOUR_TIMES_A_WEEK = 'FOUR_TIMES_A_WEEK',
  NONE = 'NONE',
  NOT_SPECIFIED = 'NOT_SPECIFIED',
  ONCE_A_WEEK = 'ONCE_A_WEEK',
  SIX_TIMES_A_WEEK = 'SIX_TIMES_A_WEEK',
  THREE_TIMES_A_WEEK = 'THREE_TIMES_A_WEEK',
  TWICE_A_WEEK = 'TWICE_A_WEEK',
}

export type Ingredient = {
  __typename?: 'Ingredient';
  amount: Scalars['Float']['output'];
  macros: Macros;
  name: Scalars['String']['output'];
  unit?: Maybe<Scalars['String']['output']>;
};

export type IngredientInput = {
  amount: Scalars['Float']['input'];
  macros: MacrosInput;
  name: Scalars['String']['input'];
  unit?: InputMaybe<Scalars['String']['input']>;
};

export type ListNutritionistsFilter = {
  isAvailable?: InputMaybe<Scalars['Boolean']['input']>;
};

export type Macros = {
  __typename?: 'Macros';
  calories: Scalars['Float']['output'];
  carbohydrates: Scalars['Float']['output'];
  fats: Scalars['Float']['output'];
  proteins: Scalars['Float']['output'];
};

export type MacrosInput = {
  calories: Scalars['Float']['input'];
  carbohydrates: Scalars['Float']['input'];
  fats: Scalars['Float']['input'];
  proteins: Scalars['Float']['input'];
};

export type MarkMealCompletedInput = {
  date?: InputMaybe<Scalars['AWSDate']['input']>;
  mealName: MealNameEnum;
  mealPlanId: Scalars['ID']['input'];
};

export type Meal = {
  __typename?: 'Meal';
  ingredients: Array<Ingredient>;
  name: MealNameEnum;
  recipe?: Maybe<Scalars['String']['output']>;
  recipeName?: Maybe<Scalars['String']['output']>;
  totalMacros: Macros;
};

export type MealInput = {
  ingredients: Array<IngredientInput>;
  name: MealNameEnum;
  recipe?: InputMaybe<Scalars['String']['input']>;
  recipeName?: InputMaybe<Scalars['String']['input']>;
  totalMacros: MacrosInput;
};

export enum MealNameEnum {
  BREAKFAST = 'BREAKFAST',
  DINNER = 'DINNER',
  LUNCH = 'LUNCH',
  SNACK_AFTERNOON = 'SNACK_AFTERNOON',
  SNACK_EVENING = 'SNACK_EVENING',
  SNACK_MORNING = 'SNACK_MORNING',
}

export type MealPlan = {
  __typename?: 'MealPlan';
  assignedNutritionistId?: Maybe<Scalars['ID']['output']>;
  chatId?: Maybe<Scalars['ID']['output']>;
  dailyPlan?: Maybe<DailyPlanData>;
  generatedAt?: Maybe<Scalars['AWSDateTime']['output']>;
  mealPlanId: Scalars['ID']['output'];
  planName?: Maybe<Scalars['String']['output']>;
  status?: Maybe<PlanStatus>;
  userId: Scalars['ID']['output'];
  validationStatus?: Maybe<MealPlanValidationStatus>;
};

export type MealPlanConnection = {
  __typename?: 'MealPlanConnection';
  activeMealPlan?: Maybe<MealPlan>;
  items: Array<MealPlan>;
  nextToken?: Maybe<Scalars['String']['output']>;
};

export type MealPlanGenerationStatus = {
  __typename?: 'MealPlanGenerationStatus';
  mealPlanId?: Maybe<Scalars['ID']['output']>;
  message?: Maybe<Scalars['String']['output']>;
  status: MealPlanGenerationStatusValue;
};

export enum MealPlanGenerationStatusValue {
  COMPLETED = 'COMPLETED',
  FAILED = 'FAILED',
  IN_PROGRESS = 'IN_PROGRESS',
  PENDING = 'PENDING',
}

export type MealPlanList = {
  __typename?: 'MealPlanList';
  activeMealPlan?: Maybe<Scalars['ID']['output']>;
  items: Array<MealPlan>;
  nextToken?: Maybe<Scalars['String']['output']>;
};

export type MealPlanResponse = {
  __typename?: 'MealPlanResponse';
  mealPlanId: Scalars['ID']['output'];
  message?: Maybe<Scalars['String']['output']>;
  success: Scalars['Boolean']['output'];
};

export type MealPlanResponseInput = {
  mealPlanId: Scalars['ID']['input'];
  message?: InputMaybe<Scalars['String']['input']>;
  success: Scalars['Boolean']['input'];
  userId: Scalars['ID']['input'];
};

export type MealPlanResponseSubscription = {
  __typename?: 'MealPlanResponseSubscription';
  mealPlanId: Scalars['ID']['output'];
  message?: Maybe<Scalars['String']['output']>;
  success: Scalars['Boolean']['output'];
  userId: Scalars['ID']['output'];
};

export enum MealPlanValidationStatus {
  NOT_VALIDATED = 'NOT_VALIDATED',
  PENDING_REVIEW = 'PENDING_REVIEW',
  VALIDATED = 'VALIDATED',
}

export type MealWithStatus = {
  __typename?: 'MealWithStatus';
  isCompleted: Scalars['Boolean']['output'];
  meal: Meal;
};

export type ModifyAssignedMealPlanInput = {
  dailyPlan?: InputMaybe<DailyPlanDataInput>;
  planName?: InputMaybe<Scalars['String']['input']>;
};

export type Mutation = {
  __typename?: 'Mutation';
  assignNutritionistToPlan?: Maybe<MealPlan>;
  createMealPlan?: Maybe<MealPlanResponse>;
  deleteMealPlan?: Maybe<MealPlanResponse>;
  getMealPlanById?: Maybe<MealPlan>;
  markMealAsCompleted?: Maybe<PlanDayCompletion>;
  modifyAssignedMealPlan?: Maybe<MealPlanResponse>;
  modifyMealPlan?: Maybe<MealPlanResponse>;
  notifyMealPlanStatusChanged?: Maybe<MealPlanResponseSubscription>;
  requestNewMealPlan?: Maybe<MealPlanResponse>;
  requestValidation?: Maybe<MealPlanResponse>;
  sendChatMessage?: Maybe<ChatResponse>;
  setActiveMealPlan?: Maybe<MealPlanResponse>;
  setPlanDayCompletion?: Maybe<PlanDayCompletion>;
  setUserSubscriptionStatus?: Maybe<UserSubscriptionStatus>;
  unmarkMealAsCompleted?: Maybe<PlanDayCompletion>;
  updateMyNutritionistProfile?: Maybe<NutritionistProfile>;
  updateUserDetails?: Maybe<UserDetails>;
  validateMealPlan?: Maybe<MealPlanResponse>;
};

export type MutationAssignNutritionistToPlanArgs = {
  input: AssignNutritionistInput;
};

export type MutationCreateMealPlanArgs = {
  input: CreateMealPlanInput;
};

export type MutationDeleteMealPlanArgs = {
  mealPlanId: Scalars['ID']['input'];
};

export type MutationGetMealPlanByIdArgs = {
  mealPlanId: Scalars['ID']['input'];
};

export type MutationMarkMealAsCompletedArgs = {
  input: MarkMealCompletedInput;
};

export type MutationModifyAssignedMealPlanArgs = {
  input: ModifyAssignedMealPlanInput;
  mealPlanId: Scalars['ID']['input'];
  userId: Scalars['ID']['input'];
};

export type MutationModifyMealPlanArgs = {
  mealPlanId: Scalars['ID']['input'];
  mealPlanName?: InputMaybe<Scalars['String']['input']>;
};

export type MutationNotifyMealPlanStatusChangedArgs = {
  input: MealPlanResponseInput;
};

export type MutationRequestNewMealPlanArgs = {
  prefsOverride?: InputMaybe<PlanRequestPreferencesInput>;
};

export type MutationRequestValidationArgs = {
  input: RequestValidationInput;
};

export type MutationSendChatMessageArgs = {
  input: SendMessageInput;
};

export type MutationSetActiveMealPlanArgs = {
  mealPlanId: Scalars['ID']['input'];
};

export type MutationSetPlanDayCompletionArgs = {
  input: SetPlanDayCompletionInput;
};

export type MutationSetUserSubscriptionStatusArgs = {
  subscriptionStatus: SubscriptionStatusEnum;
};

export type MutationUnmarkMealAsCompletedArgs = {
  input: UnmarkMealCompletedInput;
};

export type MutationUpdateMyNutritionistProfileArgs = {
  input: UpdateNutritionistProfileInput;
};

export type MutationUpdateUserDetailsArgs = {
  input: UpdateUserDetailsInput;
};

export type MutationValidateMealPlanArgs = {
  input: ValidateMealPlanInput;
};

export type NutritionistProfile = {
  __typename?: 'NutritionistProfile';
  bio?: Maybe<Scalars['String']['output']>;
  familyName?: Maybe<Scalars['String']['output']>;
  givenName?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  isAvailable?: Maybe<Scalars['Boolean']['output']>;
  nutritionistId: Scalars['ID']['output'];
  profilePictureUrl?: Maybe<Scalars['String']['output']>;
  specialization?: Maybe<Scalars['String']['output']>;
};

export type NutritionistProfileConnection = {
  __typename?: 'NutritionistProfileConnection';
  items: Array<NutritionistProfile>;
  nextToken?: Maybe<Scalars['String']['output']>;
};

export type PlanDayCompletion = {
  __typename?: 'PlanDayCompletion';
  completedMealNames: Array<MealNameEnum>;
  date: Scalars['AWSDate']['output'];
  planId: Scalars['ID']['output'];
  updatedAt: Scalars['AWSDateTime']['output'];
  userId: Scalars['ID']['output'];
};

export type PlanRequestPreferences = {
  __typename?: 'PlanRequestPreferences';
  allergies?: Maybe<Array<AllergenEnum>>;
  dailyMealsPreference?: Maybe<Scalars['Int']['output']>;
  dateOfBirth: Scalars['AWSDate']['output'];
  dietaryRestrictions?: Maybe<Scalars['String']['output']>;
  exerciseFrequency: ExerciseFrequency;
  gender: Scalars['String']['output'];
  heightCm: Scalars['Float']['output'];
  language: Scalars['String']['output'];
  openTextPreferences?: Maybe<Scalars['String']['output']>;
  weightKg: Scalars['Float']['output'];
};

export type PlanRequestPreferencesInput = {
  allergies?: InputMaybe<Array<AllergenEnum>>;
  dailyMealsPreference?: InputMaybe<Scalars['Int']['input']>;
  dietaryRestrictions?: InputMaybe<Scalars['String']['input']>;
  exerciseFrequency?: InputMaybe<ExerciseFrequency>;
  heightCm?: InputMaybe<Scalars['Float']['input']>;
  language?: InputMaybe<Scalars['String']['input']>;
  openTextPreferences?: InputMaybe<Scalars['String']['input']>;
  weightKg?: InputMaybe<Scalars['Float']['input']>;
};

export enum PlanStatus {
  ACTIVE = 'ACTIVE',
  ARCHIVED = 'ARCHIVED',
  FAILED = 'FAILED',
  GENERATED = 'GENERATED',
  IN_PROGRESS = 'IN_PROGRESS',
  PENDING = 'PENDING',
}

export type Query = {
  __typename?: 'Query';
  getActiveMealPlan?: Maybe<MealPlan>;
  getChatMessages?: Maybe<ChatMessagesResponse>;
  getMealPlanById?: Maybe<MealPlan>;
  getMyNutritionistProfile?: Maybe<NutritionistProfile>;
  getPlanDayCompletion?: Maybe<PlanDayCompletion>;
  getTodaysPlanAndStatus?: Maybe<TodaysPlan>;
  getUserDetails?: Maybe<UserDetails>;
  getUserSubscriptionStatus?: Maybe<UserSubscriptionStatus>;
  listMyAssignedChats?: Maybe<ChatMetadataConnection>;
  listMyAssignedMealPlans?: Maybe<MealPlanList>;
  listMyChats?: Maybe<ChatMetadataConnection>;
  listMyMealPlans?: Maybe<MealPlanList>;
  listNutritionists?: Maybe<NutritionistProfileConnection>;
};

export type QueryGetChatMessagesArgs = {
  beforeTimestamp?: InputMaybe<Scalars['String']['input']>;
  chatId: Scalars['ID']['input'];
  limit?: InputMaybe<Scalars['Int']['input']>;
};

export type QueryGetMealPlanByIdArgs = {
  mealPlanId: Scalars['ID']['input'];
};

export type QueryGetPlanDayCompletionArgs = {
  date: Scalars['AWSDate']['input'];
  planId: Scalars['ID']['input'];
};

export type QueryListMyAssignedChatsArgs = {
  limit?: InputMaybe<Scalars['Int']['input']>;
  nextToken?: InputMaybe<Scalars['String']['input']>;
};

export type QueryListMyAssignedMealPlansArgs = {
  limit?: InputMaybe<Scalars['Int']['input']>;
  nextToken?: InputMaybe<Scalars['String']['input']>;
};

export type QueryListMyChatsArgs = {
  limit?: InputMaybe<Scalars['Int']['input']>;
  nextToken?: InputMaybe<Scalars['String']['input']>;
};

export type QueryListMyMealPlansArgs = {
  limit?: InputMaybe<Scalars['Int']['input']>;
  nextToken?: InputMaybe<Scalars['String']['input']>;
};

export type QueryListNutritionistsArgs = {
  filter?: InputMaybe<ListNutritionistsFilter>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  nextToken?: InputMaybe<Scalars['String']['input']>;
};

export type RequestValidationInput = {
  mealPlanId: Scalars['ID']['input'];
  nutritionistId: Scalars['ID']['input'];
};

export type SendMessageInput = {
  chatId: Scalars['ID']['input'];
  messageContent: Scalars['String']['input'];
};

export enum SenderType {
  NUTRITIONIST = 'NUTRITIONIST',
  USER = 'USER',
}

export type SetPlanDayCompletionInput = {
  completedMealNames: Array<MealNameEnum>;
  date: Scalars['AWSDate']['input'];
  planId: Scalars['ID']['input'];
};

export type Subscription = {
  __typename?: 'Subscription';
  onMealPlanStatusChanged?: Maybe<MealPlanResponseSubscription>;
  onNewChatMessageForUser?: Maybe<ChatResponse>;
};

export type SubscriptionOnMealPlanStatusChangedArgs = {
  userId: Scalars['ID']['input'];
};

export type SubscriptionOnNewChatMessageForUserArgs = {
  recipientId: Scalars['ID']['input'];
};

export enum SubscriptionStatusEnum {
  FREE = 'FREE',
  PRO = 'PRO',
}

export type TodaysPlan = {
  __typename?: 'TodaysPlan';
  activePlanDetails?: Maybe<MealPlan>;
  mealsForToday?: Maybe<Array<MealWithStatus>>;
  todaysCompletion?: Maybe<PlanDayCompletion>;
};

export type UnmarkMealCompletedInput = {
  date?: InputMaybe<Scalars['AWSDate']['input']>;
  mealName: MealNameEnum;
  mealPlanId: Scalars['ID']['input'];
};

export type UpdateNutritionistProfileInput = {
  bio?: InputMaybe<Scalars['String']['input']>;
  isAvailable?: InputMaybe<Scalars['Boolean']['input']>;
  profilePictureUrl?: InputMaybe<Scalars['String']['input']>;
  specialization?: InputMaybe<Scalars['String']['input']>;
};

export type UpdateUserDetailsInput = {
  allergies?: InputMaybe<Array<AllergenEnum>>;
  dailyMealsPreference?: InputMaybe<Scalars['Int']['input']>;
  dietaryRestrictions?: InputMaybe<Scalars['String']['input']>;
  exerciseFrequency?: InputMaybe<ExerciseFrequency>;
  heightCm?: InputMaybe<Scalars['Float']['input']>;
  openTextPreferences?: InputMaybe<Scalars['String']['input']>;
  weightKg?: InputMaybe<Scalars['Float']['input']>;
};

export type UserDetails = {
  __typename?: 'UserDetails';
  activeMealPlanId?: Maybe<Scalars['ID']['output']>;
  allergies?: Maybe<Array<AllergenEnum>>;
  createdAt?: Maybe<Scalars['AWSDateTime']['output']>;
  dailyMealsPreference: Scalars['Int']['output'];
  dietaryRestrictions?: Maybe<Scalars['String']['output']>;
  exerciseFrequency: ExerciseFrequency;
  heightCm: Scalars['Float']['output'];
  openTextPreferences?: Maybe<Scalars['String']['output']>;
  updatedAt?: Maybe<Scalars['AWSDateTime']['output']>;
  userId: Scalars['ID']['output'];
  weightKg: Scalars['Float']['output'];
};

export type UserSubscriptionStatus = {
  __typename?: 'UserSubscriptionStatus';
  subscriptionStatus: SubscriptionStatusEnum;
  userId: Scalars['ID']['output'];
};

export type ValidateMealPlanInput = {
  mealPlanId: Scalars['ID']['input'];
  validationStatus: MealPlanValidationStatus;
};

export enum WeekdayEnum {
  FRIDAY = 'FRIDAY',
  MONDAY = 'MONDAY',
  SATURDAY = 'SATURDAY',
  SUNDAY = 'SUNDAY',
  THURSDAY = 'THURSDAY',
  TUESDAY = 'TUESDAY',
  WEDNESDAY = 'WEDNESDAY',
}
