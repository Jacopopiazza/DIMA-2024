export interface UserProfile {
  /**
   * Unique identifier for the user (e.g. 'U123').
   * You may derive this from Cognito sub or Cognito username.
   */
  userId: string;

  /**
   * Customizable preferences for the user:
   * sex, age, weight, daily meals, allergies, exercise frequency, etc.
   */
  preferences: {
    sex?: 'male' | 'female' | 'other';
    age?: number;
    weight?: number;
    mealsPerDay?: number;
    allergies?: string[];
    exerciseFrequency?: string;
    specialRequests?: string[]; // e.g. ["Pizza on Friday evening", "No zucchini"]
  };
}
