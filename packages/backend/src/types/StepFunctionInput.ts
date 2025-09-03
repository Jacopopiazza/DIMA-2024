import { PlanRequestPreferencesInput } from '../lambda/graphql-types';

export interface StepFunctionInput {
  mealPlanId: string;
  userId: string;
  preferences: PlanRequestPreferencesInput;
}
