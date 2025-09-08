import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get completeYourProfile => 'Complete Your Profile';

  @override
  String get profileInformation => 'Profile Information';

  @override
  String get welcomeCompleteProfile => 'Welcome! Please complete your nutritionist profile';

  @override
  String get specialization => 'Specialization';

  @override
  String get specializationHint => 'e.g., Sports Nutrition, Weight Management';

  @override
  String get pleaseEnterSpecialization => 'Please enter your specialization';

  @override
  String get bio => 'Bio';

  @override
  String get bioHint => 'Tell clients about your expertise and approach';

  @override
  String get pleaseEnterBio => 'Please enter your bio';

  @override
  String get bioTooShort => 'Bio should be at least 50 characters';

  @override
  String get profilePicture => 'Profile Picture';

  @override
  String get tapToUploadProfilePicture => 'Tap to upload a profile picture';

  @override
  String get availableForNewClients => 'Available for new clients';

  @override
  String get clientsCanRequestServices => 'Clients can request your services';

  @override
  String get updateProfile => 'Update Profile';

  @override
  String get saveProfile => 'Save Profile';

  @override
  String get noInternetConnection => 'No internet connection. Please check your connection and try again.';

  @override
  String get profileSavedSuccessfully => 'Profile saved successfully!';

  @override
  String get errorSavingProfile => 'Error saving profile. Please try again.';

  @override
  String errorSavingProfileWith(String error) {
    return 'Error saving profile: $error';
  }

  @override
  String get loadingNutritionistSettings => 'Loading nutritionist settings...';

  @override
  String get nutritionistSettings => 'Nutritionist Settings';

  @override
  String get manageProfileMessage => 'Manage your professional profile, availability, and account settings.';

  @override
  String get editProfessionalDetails => 'Edit Professional Details';

  @override
  String get professionalBio => 'Professional Bio';

  @override
  String get availabilitySettings => 'Availability Settings';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String errorUpdatingProfile(String error) {
    return 'Error updating profile: $error';
  }

  @override
  String get bioMinLength => 'Bio should be at least 50 characters';

  @override
  String get saving => 'Saving...';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get availableForConsultations => 'You are now available for consultations';

  @override
  String get unavailableForConsultations => 'You are now unavailable for consultations';

  @override
  String errorUpdatingAvailability(String error) {
    return 'Error updating availability: $error';
  }

  @override
  String get validatePlans => 'Validate Plans';

  @override
  String get settings => 'Settings';

  @override
  String get internetRequiredMessage => 'This app requires an internet connection to function properly. Please check your connection and try again.';

  @override
  String get connectionTips => 'Connection Tips';

  @override
  String get checkWifiConnection => 'Check your Wi-Fi or mobile data connection';

  @override
  String get turnOffAirplaneMode => 'Make sure airplane mode is turned off';

  @override
  String get moveForBetterSignal => 'Try moving to an area with better signal';

  @override
  String get restartRouter => 'Restart your router or mobile data';

  @override
  String get checking => 'Checking...';

  @override
  String get tryAgainButton => 'Try Again';

  @override
  String get connectionRestored => 'Connection restored!';

  @override
  String get stillNoInternet => 'Still no internet connection';

  @override
  String get tapToSelectPhoto => 'Tap to select photo';

  @override
  String get selectPhoto => 'Select Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get selectFromExistingPhotos => 'Select from existing photos';

  @override
  String get removePhoto => 'Remove Photo';

  @override
  String get deleteCurrentProfilePicture => 'Delete current profile picture';

  @override
  String get cancel => 'Cancel';

  @override
  String errorUploadingImage(String error) {
    return 'Error uploading image: $error';
  }

  @override
  String errorRemovingImage(String error) {
    return 'Error removing image: $error';
  }

  @override
  String get availability => 'Availability';

  @override
  String get currentlyAvailableForConsultations => 'You are currently available for consultations';

  @override
  String get currentlyUnavailableForConsultations => 'You are currently unavailable for consultations';

  @override
  String get availableForConsultationsTitle => 'Available for Consultations';

  @override
  String get usersCanRequestConsultations => 'Users can request consultations from you';

  @override
  String get noNewConsultationRequests => 'You will not receive new consultation requests';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signOutOfNutritionistAccount => 'Sign out of your nutritionist account';

  @override
  String errorSigningOut(String error) {
    return 'Error signing out: $error';
  }

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountPermanently => 'This action will permanently delete your nutritionist account and all associated data. This cannot be undone.';

  @override
  String get allDataWillBeRemoved => 'All your professional data, client interactions, and account information will be permanently removed.';

  @override
  String get confirmSignOutTitle => 'Sign Out';

  @override
  String get confirmSignOutMessage => 'Are you sure you want to sign out of your nutritionist account?';

  @override
  String get dangerZone => 'Danger Zone';

  @override
  String get irreversibleDestructiveActions => 'Irreversible and destructive actions';

  @override
  String get criticalWarning => 'Critical Warning';

  @override
  String get permanentActionWarning => 'The actions below are permanent and cannot be undone. All your nutritionist data, including profile information, client interactions, and professional settings will be permanently deleted.';

  @override
  String get deleteMyAccount => 'Delete My Account';

  @override
  String errorDeletingAccount(String error) {
    return 'Error deleting account: $error';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get proPlanTitle => 'PRO Plan';

  @override
  String get unlockPremiumFeatures => 'Unlock premium features:';

  @override
  String get expertMealPlanningValidation => 'Expert meal planning validation';

  @override
  String get personalNutritionistChat => 'Personal nutritionist chat in-app';

  @override
  String get subscribeToPro => 'Subscribe to PRO';

  @override
  String get changePreferences => 'Change Preferences';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get confirmClearCacheTitle => 'Confirm Clear Cache';

  @override
  String get confirmClearCacheMessage => 'Are you sure you want to clear all locally cached data? This may require re-downloading meal plans and other information.';

  @override
  String get clear => 'Clear';

  @override
  String get cacheClearedSuccessfully => 'Cache cleared successfully.';

  @override
  String get errorClearingCache => 'Error clearing cache.';

  @override
  String get confirmDeleteAccountTitle => 'Confirm Account Deletion';

  @override
  String get confirmDeleteAccountMessage => 'WARNING: This action is irreversible and will permanently delete your account and all associated data. Are you absolutely sure you want to proceed?';

  @override
  String get accountDeletedSuccessfully => 'Account deleted successfully.';

  @override
  String get errorDeleteAccountRequiresRecentLogin => 'Account deletion requires a recent sign-in. Please sign out and sign back in.';

  @override
  String get preferencesSavedSuccess => 'Preferences saved successfully.';

  @override
  String get errorSavingPreferences => 'Error saving preferences.';

  @override
  String get errorLoadingPreferences => 'Error loading preferences.';

  @override
  String get pleaseCorrectErrors => 'Please correct the errors in the form.';

  @override
  String get retry => 'Retry';

  @override
  String get basicInfo => 'Basic Info';

  @override
  String get weightKg => 'Weight (kg)';

  @override
  String get heightCm => 'Height (cm)';

  @override
  String get targetCalories => 'Target Daily Calories';

  @override
  String get invalidNumberFormat => 'Please enter a valid number.';

  @override
  String get caloriesOutOfRange => 'Calories must be between 500 and 10000.';

  @override
  String get dietaryNeeds => 'Dietary Needs';

  @override
  String mealsPerDay(int count) {
    return 'Meals Per Day';
  }

  @override
  String get dietaryRestrictions => 'Dietary Restrictions';

  @override
  String get dietaryRestrictionsHint => 'e.g., Vegetarian, Vegan, Low-Carb';

  @override
  String get allergies => 'Allergies';

  @override
  String get lifestyle => 'Lifestyle';

  @override
  String get exerciseFrequency => 'Exercise Frequency';

  @override
  String get otherPreferences => 'Other Preferences';

  @override
  String get additionalNotes => 'Additional Notes';

  @override
  String get additionalNotesHint => 'Any other likes, dislikes, or goals?';

  @override
  String get appVersion => 'App Version';

  @override
  String get allergenCELERY => 'Celery';

  @override
  String get allergenCRUSTACEANS => 'Crustaceans';

  @override
  String get allergenEGGS => 'Eggs';

  @override
  String get allergenFISH => 'Fish';

  @override
  String get allergenGLUTEN_CEREALS => 'Gluten Cereals';

  @override
  String get allergenLUPIN => 'Lupin';

  @override
  String get allergenMILK => 'Milk';

  @override
  String get allergenMOLLUSCS => 'Molluscs';

  @override
  String get allergenMUSTARD => 'Mustard';

  @override
  String get allergenNUTS => 'Nuts';

  @override
  String get allergenPEANUTS => 'Peanuts';

  @override
  String get allergenSESAME_SEEDS => 'Sesame Seeds';

  @override
  String get allergenSOYBEANS => 'Soybeans';

  @override
  String get allergenSULPHITES => 'Sulphites';

  @override
  String get exerciseFrequencyEVERY_DAY => 'Every day';

  @override
  String get exerciseFrequencyFIVE_TIMES_A_WEEK => 'Five times a week';

  @override
  String get exerciseFrequencyFOUR_TIMES_A_WEEK => 'Four times a week';

  @override
  String get exerciseFrequencyNONE => 'None';

  @override
  String get exerciseFrequencyNOT_SPECIFIED => 'Not specified';

  @override
  String get exerciseFrequencyONCE_A_WEEK => 'Once a week';

  @override
  String get exerciseFrequencySIX_TIMES_A_WEEK => 'Six times a week';

  @override
  String get exerciseFrequencyTHREE_TIMES_A_WEEK => 'Three times a week';

  @override
  String get exerciseFrequencyTWICE_A_WEEK => 'Twice a week';

  @override
  String get energy => 'Energy';

  @override
  String get ingredients => 'Ingredients';

  @override
  String get recipe => 'Recipe';

  @override
  String get noRecipe => 'No recipe available';

  @override
  String get mealCompleted => 'Completed';

  @override
  String get mealToBeCompleted => 'Mark as Done';

  @override
  String get back => 'Back';

  @override
  String get today => 'Today';

  @override
  String get mealPlans => 'Meal Plans';

  @override
  String get clientDetails => 'Client Details';

  @override
  String get loadingClientInformation => 'Loading client information...';

  @override
  String get healthProfilePreferences => 'Health profile and preferences';

  @override
  String get noClientDetailsAvailable => 'No client details available';

  @override
  String get loadingClientDetails => 'Loading client details...';

  @override
  String get physicalInformation => 'Physical Information';

  @override
  String get height => 'Height';

  @override
  String get weight => 'Weight';

  @override
  String get bmi => 'BMI';

  @override
  String get dietaryInformation => 'Dietary Information';

  @override
  String get dailyMealsPreference => 'Daily Meals Preference';

  @override
  String get dietaryRestrictionsLabel => 'Dietary Restrictions';

  @override
  String get additionalPreferences => 'Additional Preferences';

  @override
  String get accountInformation => 'Account Information';

  @override
  String get accountCreated => 'Account Created';

  @override
  String get lastUpdated => 'Last Updated';

  @override
  String get activePlanId => 'Active Plan ID';

  @override
  String get viewPlanDetails => 'View plan details';

  @override
  String get planIdLabel => 'Plan ID';

  @override
  String get generated => 'Generated';

  @override
  String get status => 'Status';

  @override
  String get validation => 'Validation';

  @override
  String get nutritionist => 'Nutritionist';

  @override
  String get user => 'User';

  @override
  String get noMealPlanDataAvailable => 'No meal plan data available';

  @override
  String get sevenDayScheduleEditing => '7-day meal schedule (Editing)';

  @override
  String get sevenDayScheduleViewEdit => '7-day meal schedule (View/Edit)';

  @override
  String get sevenDayScheduleViewOnly => '7-day meal schedule (View Only)';

  @override
  String get noDailyPlanDataFound => 'No daily plan data found for this meal plan.';

  @override
  String get enterRecipeName => 'Enter recipe name';

  @override
  String get enterCookingInstructions => 'Enter cooking instructions...';

  @override
  String get add => 'Add';

  @override
  String get noIngredientsAddedYet => 'No ingredients added yet';

  @override
  String get ingredientName => 'Ingredient Name';

  @override
  String get removeIngredient => 'Remove ingredient';

  @override
  String get amount => 'Amount';

  @override
  String get unit => 'Unit';

  @override
  String get nutritionalValuesPerUnit => 'Nutritional Values (per unit)';

  @override
  String get calories => 'Calories';

  @override
  String get proteins => 'Proteins';

  @override
  String get carbs => 'Carbs';

  @override
  String get fats => 'Fats';

  @override
  String get chatWithPatient => 'Chat with Patient';

  @override
  String get validateMealPlan => 'Validate Meal Plan';

  @override
  String validateMealPlanConfirm(String planName) {
    return 'Are you sure you want to validate \"$planName\"?';
  }

  @override
  String get validate => 'Validate';

  @override
  String get rejectMealPlan => 'Reject Meal Plan';

  @override
  String rejectMealPlanConfirm(String planName) {
    return 'Are you sure you want to reject \"$planName\"? This will reset the plan to not validated status.';
  }

  @override
  String get reject => 'Reject';

  @override
  String get mealPlanValidatedSuccessfully => 'Meal plan validated successfully!';

  @override
  String get failedToValidateMealPlan => 'Failed to validate meal plan';

  @override
  String get mealPlanRejected => 'Meal plan rejected';

  @override
  String get failedToRejectMealPlan => 'Failed to reject meal plan';

  @override
  String get savingMealPlan => 'Saving meal plan...';

  @override
  String get mealPlanSavedSuccessfully => 'Meal plan saved successfully!';

  @override
  String get failedToSaveMealPlan => 'Failed to save meal plan';

  @override
  String get bmiUnderweight => 'Underweight';

  @override
  String get bmiNormalWeight => 'Normal weight';

  @override
  String get bmiOverweight => 'Overweight';

  @override
  String get bmiObese => 'Obese';

  @override
  String get noneReported => 'None reported';

  @override
  String get profileInfoNotAvailable => 'Profile information not available';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get noExercise => 'No exercise';

  @override
  String get onceWeek => 'Once a week';

  @override
  String get twiceWeek => 'Twice a week';

  @override
  String get threeTimes => '3 times per week';

  @override
  String get fourTimes => '4 times per week';

  @override
  String get fiveTimes => '5 times per week';

  @override
  String get sixTimes => '6 times per week';

  @override
  String get everyDay => 'Every day';

  @override
  String get weightRange => 'Weight must be between 30 and 300 kg';

  @override
  String get heightRange => 'Height must be between 50 and 250 cm';

  @override
  String get completeProfileFirst => 'Complete Profile First';

  @override
  String get mealPlanGenStarted => 'Meal plan generation started! You\'ll receive a notification when it\'s ready.';

  @override
  String get failedToStartGeneration => 'Failed to start meal plan generation';

  @override
  String get createMealPlan => 'Create Meal Plan';

  @override
  String get loadingPreferences => 'Loading your preferences...';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get unableToLoadPreferences => 'Unable to load your preferences';

  @override
  String get personalizedMealPlan => 'Personalized Meal Plan';

  @override
  String get personalizedDescription => 'We\'ll create a customized weekly meal plan based on your preferences, dietary needs, and lifestyle.';

  @override
  String get profileIncomplete => 'Profile Incomplete';

  @override
  String get completeProfile => 'Complete Profile';

  @override
  String get completeProfileMustDo => 'You must complete your profile before generating a meal plan';

  @override
  String get noProfileDetailsFound => 'No Profile Details Found';

  @override
  String get noProfileDescription => 'For the most personalized meal plan, please set up your profile with your weight, height, dietary preferences, and allergies.';

  @override
  String get orContinueDefault => 'Or continue with default preferences below';

  @override
  String get profileDetailsFound => 'Profile Details Found';

  @override
  String get customPreferences => 'Custom Preferences';

  @override
  String get usingCustomPreferences => 'Using custom preferences for this meal plan';

  @override
  String get usingProfilePreferences => 'Using your profile preferences';

  @override
  String get physicalDetails => 'Physical Details';

  @override
  String get weightHelper => 'Allowed: 30–300 kg';

  @override
  String get heightHelper => 'Allowed: 50–250 cm';

  @override
  String get mealPreferences => 'Meal Preferences';

  @override
  String get dailyMeals => 'Daily Meals';

  @override
  String get additionalPreferencesHint => 'Any other food preferences or requirements';

  @override
  String get creatingMealPlan => 'Creating Meal Plan...';

  @override
  String get generateCustomPreferences => 'Generate with Custom Preferences';

  @override
  String mealsDropdown(int count) {
    return '$count meals';
  }

  @override
  String get generatePersonalizedPlan => 'Generate Personalized Plan';

  @override
  String get selectAllergies => 'Select any allergies you have:';

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get signedIn => 'Logged in!';

  @override
  String get userRole => 'User';

  @override
  String get nutritionistRole => 'Nutritionist';

  @override
  String get signUpDropdownText => 'Register as';

  @override
  String get socialSignUpNotice => 'Signing up with a social account automatically creates a regular user account. Nutritionists must first sign up with email. If a user later logs in with a social account linked to the same email, the accounts will be merged automatically.';

  @override
  String get maleGender => 'Male';

  @override
  String get femaleGender => 'Female';

  @override
  String get otherGender => 'Other';

  @override
  String get newMealPlanAvailable => 'New meal plan available!';

  @override
  String get mealPlanGenerationFailed => 'Meal plan generation failed: ';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get loadingYourMealPlans => 'Loading your meal plans...';

  @override
  String get newPlan => 'New Plan';

  @override
  String get noMealPlansYet => 'No meal plans yet';

  @override
  String get createFirstMealPlan => 'Create your first personalized meal plan\nto get started with healthy eating';

  @override
  String get pullDownToRefresh => 'Pull down to refresh';

  @override
  String get connectionProblem => 'Connection Problem';

  @override
  String get unableToLoadPlansWithConnection => 'Unable to load your meal plans.\nCheck your internet connection and try again.';

  @override
  String get unableToLoadPlans => 'Unable to load your meal plans';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get active => 'ACTIVE';

  @override
  String get setActive => 'Set Active';

  @override
  String get delete => 'Delete';

  @override
  String get generating => 'Generating';

  @override
  String get failed => 'Failed';

  @override
  String get validated => 'Validated';

  @override
  String get pendingValidation => 'Pending Validation';

  @override
  String get rejected => 'Rejected';

  @override
  String get notValidated => 'Not validated';

  @override
  String get pleaseRetryLater => 'Please try again later';

  @override
  String get modelOverloadedMessage => 'The model is overloaded. Please request a new meal plan later.';

  @override
  String get setActivePlan => 'Set Active Plan';

  @override
  String makeActivePlanQuestion(Object planName) {
    return 'Make \"$planName\" your active meal plan?';
  }

  @override
  String get deleteMealPlan => 'Delete Meal Plan';

  @override
  String deletePlanConfirmation(Object planName) {
    return 'Are you sure you want to delete \"$planName\"?';
  }

  @override
  String get unnamedPlan => 'Unnamed Plan';

  @override
  String planId(Object planId) {
    return 'Plan ID: $planId';
  }

  @override
  String get viewPlan => 'View Plan';

  @override
  String get editName => 'Edit Name';

  @override
  String get requestValidation => 'Request Validation';

  @override
  String get seeDetailedMealPlan => 'See detailed meal plan';

  @override
  String get changePlanName => 'Change the plan name';

  @override
  String get getNutritionistApproval => 'Get nutritionist approval';

  @override
  String get proFeature => 'Pro feature';

  @override
  String get pro => 'PRO';

  @override
  String get activeMealPlanUpdated => 'Active meal plan updated!';

  @override
  String get failedToSetActiveMealPlan => 'Failed to set active meal plan';

  @override
  String get mealPlanDeletedSuccessfully => 'Meal plan deleted successfully';

  @override
  String get failedToDeleteMealPlan => 'Failed to delete meal plan';

  @override
  String get actionFailed => 'Action failed: ';

  @override
  String get modifyPlanName => 'Modify Plan Name';

  @override
  String get enterNewPlanName => 'Enter new plan name';

  @override
  String get planNameCannotBeEmpty => 'Plan name cannot be empty';

  @override
  String get planNameMinLength => 'Plan name must be at least 2 characters long';

  @override
  String get planNameMaxLength => 'Plan name must be less than 50 characters';

  @override
  String get validName => 'Valid name';

  @override
  String get save => 'Save';

  @override
  String get failedToUpdatePlanName => 'Failed to update plan name: ';

  @override
  String get requestNutritionistValidation => 'Request Nutritionist Validation';

  @override
  String selectNutritionistToReview(Object planName) {
    return 'Select a nutritionist to review your meal plan \"$planName\":';
  }

  @override
  String get errorLoadingNutritionists => 'Error loading nutritionists: ';

  @override
  String get pleaseSelectNutritionist => 'Please select a nutritionist';

  @override
  String get nutritionistNotAvailable => 'Selected nutritionist is not available for validation';

  @override
  String get validationRequestSent => 'Validation request sent successfully!';

  @override
  String get failedToSendValidationRequest => 'Failed to send validation request';

  @override
  String get errorSendingValidationRequest => 'Error sending validation request: ';

  @override
  String get available => 'Available';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get noNutritionistsAvailable => 'No nutritionists available at the moment.';

  @override
  String get requestValidationButton => 'Request Validation';

  @override
  String get failedToLoadMealPlan => 'Failed to load meal plan: ';

  @override
  String get loadingYourMealPlan => 'Loading your meal plan...';

  @override
  String get connectionProblemView => 'Connection Problem';

  @override
  String get oopsSomethingWentWrong => 'Oops! Something went wrong';

  @override
  String get checkInternetConnection => 'Please check your internet connection and try again. Make sure you\'re connected to Wi-Fi or cellular data.';

  @override
  String get encounterErrorLoadingPlan => 'We encountered an error while loading your meal plan. This might be a temporary issue.';

  @override
  String get reconnect => 'Reconnect';

  @override
  String get mealPlanNotFound => 'Meal Plan Not Found';

  @override
  String get mealPlanMightDeleted => 'This meal plan might have been deleted or is no longer available. Please try refreshing or go back to select another plan.';

  @override
  String get planInformation => 'Plan Information';

  @override
  String get planName => 'Plan Name';

  @override
  String get errorDetails => 'Error Details';

  @override
  String get weeklyMealPlan => 'Weekly Meal Plan';

  @override
  String get sevenDayMealScheduleReadOnly => '7-day meal schedule';

  @override
  String mealsCount(int count) {
    return '$count meals';
  }

  @override
  String get noDailyPlanData => 'No daily plan data found for this meal plan.';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get noMealsScheduled => 'No meals scheduled for this day';

  @override
  String get unnamedMeal => 'Unnamed meal';

  @override
  String get recipeName => 'Recipe Name';

  @override
  String get instructions => 'Instructions';

  @override
  String get nutritionInformation => 'Nutrition Information';

  @override
  String get protein => 'Protein';

  @override
  String get fat => 'Fat';

  @override
  String get chatWithNutritionist => 'Chat with Nutritionist';

  @override
  String get showLess => 'Show less';

  @override
  String get readMore => 'Read more';

  @override
  String get statusActive => 'Active';

  @override
  String get statusGenerated => 'Generated';

  @override
  String get statusArchived => 'Archived';

  @override
  String get statusFailed => 'Failed';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusUnknown => 'Unknown';

  @override
  String get validationValidated => 'Validated';

  @override
  String get validationPendingReview => 'Pending Review';

  @override
  String get validationRejected => 'Rejected';

  @override
  String get validationNotValidated => 'Not Validated';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get typeYourMessage => 'Type your message...';

  @override
  String get patient => 'Patient';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get failedToLoadOlderMessages => 'Failed to load older messages: ';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get message => 'Message...';

  @override
  String get pullDownToLoadOlder => 'Pull down to load older messages';

  @override
  String get loadingMessages => 'Loading messages...';

  @override
  String get failedToLoadChat => 'Failed to load chat';

  @override
  String get startTheConversation => 'Start the conversation';

  @override
  String get sendMessageToBegin => 'Send a message to begin chatting.';

  @override
  String messagesCount(int count) {
    return '$count messages';
  }

  @override
  String isTyping(String name) {
    return '$name is typing...';
  }

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String get upgradeToPro => 'Upgrade to PRO';

  @override
  String get chooseYourProPlan => 'Choose your PRO plan:';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get lifetime => 'Lifetime';

  @override
  String get monthlyPrice => '\$9.99/month';

  @override
  String get yearlyPrice => '\$99/year';

  @override
  String get lifetimePrice => '\$299';

  @override
  String get monthlyDescription => 'Best for trying out';

  @override
  String get yearlyDescription => 'Save 17% (2 months free)';

  @override
  String get lifetimeDescription => 'One-time payment';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get subscriptionFeatureComingSoon => 'Subscription feature coming soon!';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get confirmDeleteMessage => 'Are you sure you want to delete your account?';

  @override
  String get mealNameBREAKFAST => 'Breakfast';

  @override
  String get mealNameDINNER => 'Dinner';

  @override
  String get mealNameLUNCH => 'Lunch';

  @override
  String get mealNameSNACK_MORNING => 'Snack (Morning)';

  @override
  String get mealNameSNACK_AFTERNOON => 'Snack (Afternoon)';

  @override
  String get mealNameSNACK_EVENING => 'Snack (Evening)';

  @override
  String get todayProgress => 'Today\'s Progress';

  @override
  String get todaysMeals => 'Today\'s Meals';

  @override
  String get showingStaleData => 'Showing stale data.';

  @override
  String get networkUnavailableCachedData => 'Network unavailable. Showing cached data.';

  @override
  String get refreshFailedPreviousData => 'Refresh failed. Displaying previous data.';

  @override
  String get failedToLoadDataCheckConnection => 'Failed to load data. Check connection.';

  @override
  String get refreshFailedNoMealsScheduled => 'Refresh failed. No meals scheduled.';

  @override
  String get errorMealDataMissing => 'Error: Meal data is missing.';

  @override
  String get noMealsForToday => 'No Meals For Today';

  @override
  String currentMealPlanNoMealsScheduled(String dayName) {
    return 'Your current meal plan doesn\'t have any meals scheduled for $dayName.';
  }

  @override
  String get refreshNow => 'Refresh Now';

  @override
  String get failedToLoadData => 'Failed to Load Data';

  @override
  String get retryAction => 'Retry';

  @override
  String get noMealPlanSelected => 'No Meal Plan Selected';

  @override
  String get selectMealPlanToStart => 'Select a meal plan to start tracking your daily meals and nutritional progress.';

  @override
  String get choosePlan => 'Choose a Plan';

  @override
  String get mealPlanReady => 'Meal Plan Ready!';

  @override
  String get generationFailed => 'Generation Failed';

  @override
  String get mealPlanReadyDescription => 'Your meal plan has been successfully generated.';

  @override
  String get generationFailedDescription => 'There was an error generating your meal plan. Please try again later.';

  @override
  String get loadingSettings => 'Loading settings...';

  @override
  String get unableToLoadSettings => 'Unable to load settings';

  @override
  String get notSignedIn => 'Not signed in';

  @override
  String get pleaseSignInToAccessSettings => 'Please sign in to access your settings';

  @override
  String get signIn => 'Sign In';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get manageYourProfilePreferencesAndSecurity => 'Manage your profile, preferences, and account security settings.';

  @override
  String get loadingSubscription => 'Loading subscription...';

  @override
  String get loadingProfile => 'Loading profile...';

  @override
  String get profileUnavailable => 'Profile Unavailable';

  @override
  String get personalDataCurrentlyUnavailable => 'Personal data are currently unavailable. Please try refreshing or check back later.';

  @override
  String get preferencesUnavailable => 'Preferences Unavailable';

  @override
  String get preferencesDataCurrentlyUnavailable => 'Your preferences and settings data are currently unavailable. Please try refreshing or check back later.';

  @override
  String get subscriptionStatusUnavailable => 'Subscription Status Unavailable';

  @override
  String get subscriptionStatusCurrentlyUnavailable => 'Your subscription status is currently unavailable. Please try refreshing or check back later.';

  @override
  String get userProfile => 'User Profile';

  @override
  String get unsaved => 'Unsaved';

  @override
  String get givenName => 'Given Name';

  @override
  String get familyName => 'Family Name';

  @override
  String get givenNameRequired => 'Given Name is required';

  @override
  String get familyNameRequired => 'Family Name is required';

  @override
  String get nameFieldsReadOnly => 'Name fields are managed by your authentication provider and cannot be changed here.';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get other => 'Other';

  @override
  String get birthdate => 'Birthdate';

  @override
  String get selectDate => 'Select date';

  @override
  String get failedToUpdateProfile => 'Failed to update profile. Please try again.';

  @override
  String get generationPreferences => 'Generation Preferences';

  @override
  String get weightAllowed => 'Allowed: 30–300 kg';

  @override
  String get weightMustBeBetween => 'Weight must be between 30 and 300 kg';

  @override
  String get heightAllowed => 'Allowed: 50–250 cm';

  @override
  String get heightMustBeBetween => 'Height must be between 50 and 250 cm';

  @override
  String get onceAWeek => 'Once a week';

  @override
  String get twiceAWeek => 'Twice a week';

  @override
  String get anySpecificDietaryRestriction => 'Any specific dietary restriction';

  @override
  String get dietaryPreferences => 'Dietary preferences';

  @override
  String get anySpecificDietaryPreference => 'Any specific dietary preference or notes';

  @override
  String get weightIsRequired => 'Weight is required';

  @override
  String get heightIsRequired => 'Height is required';

  @override
  String get pleaseEnterValidWeight => 'Please enter a valid weight';

  @override
  String get pleaseEnterValidHeight => 'Please enter a valid height';

  @override
  String get profileUpdatedSuccessfullyShort => 'Profile updated successfully';

  @override
  String get failedToUpdateProfileShort => 'Failed to update profile';

  @override
  String get changePassword => 'Change Password';

  @override
  String get updateYourAccountPassword => 'Update your account password';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get pleaseEnterCurrentPassword => 'Please enter your current password';

  @override
  String get newPassword => 'New Password';

  @override
  String get pleaseEnterNewPassword => 'Please enter a new password';

  @override
  String get passwordMustBeAtLeast8Characters => 'Password must be at least 8 characters';

  @override
  String get passwordMustContainUppercase => 'Password must contain uppercase, lowercase, and numbers';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get pleaseConfirmNewPassword => 'Please confirm your new password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordRequirements => 'Password Requirements:';

  @override
  String get atLeast8Characters => 'At least 8 characters';

  @override
  String get uppercaseLetter => 'Uppercase letter (A-Z)';

  @override
  String get lowercaseLetter => 'Lowercase letter (a-z)';

  @override
  String get number => 'Number (0-9)';

  @override
  String get changingPassword => 'Changing Password...';

  @override
  String get changePasswordButton => 'Change Password';

  @override
  String get passwordChangedSuccessfully => 'Password changed successfully';

  @override
  String get failedToChangePassword => 'Failed to change password';

  @override
  String get tooShort => 'Too short';

  @override
  String get weak => 'Weak';

  @override
  String get fair => 'Fair';

  @override
  String get good => 'Good';

  @override
  String get strong => 'Strong';

  @override
  String get proPlan => 'PRO Plan';

  @override
  String get activeSubscription => 'Active subscription';

  @override
  String get upgradeToUnlockPremiumFeatures => 'Upgrade to unlock premium features';

  @override
  String currentStatus(Object status) {
    return 'Current Status: $status';
  }

  @override
  String get youHaveAccessTo => 'You have access to:';

  @override
  String get personalNutritionistChatInApp => 'Personal nutritionist chat in-app';

  @override
  String get unsubscribeFromPro => 'Unsubscribe from PRO';

  @override
  String get successfullySubscribedToPro => 'Successfully subscribed to PRO!';

  @override
  String get failedToSubscribe => 'Failed to subscribe. Please try again.';

  @override
  String get errorSubscribing => 'Error subscribing';

  @override
  String get successfullyUnsubscribedToFree => 'Successfully unsubscribed to FREE!';

  @override
  String get failedToUnsubscribe => 'Failed to unsubscribe. Please try again.';

  @override
  String get errorUnsubscribing => 'Error unsubscribing';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get refreshData => 'Refresh Data';

  @override
  String get clearCacheAndReload => 'Clear cache and reload your information';

  @override
  String get signOutOfYourAccount => 'Sign out of your account';

  @override
  String get dataRefreshedSuccessfully => 'Data refreshed successfully';

  @override
  String get areYouSureSignOut => 'Are you sure you want to sign out of your account?';

  @override
  String get irreversibleAndDestructiveActions => 'Irreversible and destructive actions';

  @override
  String get actionsArePermanent => 'The actions below are permanent and cannot be undone. All your data, including meal plans, preferences, and account information will be permanently deleted.';

  @override
  String get deletingAccount => 'Deleting Account...';

  @override
  String get thisActionWillPermanentlyDelete => 'This action will permanently delete your account and all associated data. This cannot be undone.';

  @override
  String get allYourMealPlansWillBeRemoved => 'All your meal plans, preferences, and personal data will be permanently removed.';

  @override
  String get failedToDeleteAccount => 'Failed to delete account';

  @override
  String get noInternetConnectionValidation => 'No internet connection. Please check your connection and try again.';

  @override
  String errorLoadingAssignedPlans(String error) {
    return 'Error loading assigned meal plans: $error';
  }

  @override
  String get loadingMealPlansValidation => 'Loading meal plans...';

  @override
  String get validatedStatus => 'Validated';

  @override
  String get pendingReviewStatus => 'Pending Review';

  @override
  String get notValidatedStatus => 'Not Validated';

  @override
  String clientLabel(String clientName) {
    return 'Client: $clientName';
  }

  @override
  String createdLabel(String date) {
    return 'Created: $date';
  }

  @override
  String updatedLabel(String date) {
    return 'Updated: $date';
  }

  @override
  String get noMealPlansToValidate => 'No Meal Plans to Validate';

  @override
  String get validationEmptyMessage => 'Meal plans assigned for validation will appear here.\nCheck back later or pull to refresh.';

  @override
  String get refresh => 'Refresh';

  @override
  String get errorLoadingPlansTitle => 'Error Loading Plans';

  @override
  String get signUp => 'Create Account';

  @override
  String get confirm => 'Confirm';

  @override
  String get continueLabel => 'Continue';

  @override
  String get submit => 'Submit';

  @override
  String get sendCode => 'Send Code';

  @override
  String get lostCode => 'Lost your code?';

  @override
  String get noAccount => 'No account?';

  @override
  String get haveAccount => 'Have an account?';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get confirmResetPassword => 'Reset Password';

  @override
  String get verify => 'Verify';

  @override
  String get skip => 'Skip';

  @override
  String get copyKey => 'Copy Key';

  @override
  String backTo(String previousStep) {
    String _temp0 = intl.Intl.selectLogic(
      previousStep,
      {
        'signUp': 'Sign Up',
        'signIn': 'Sign In',
        'confirmSignUp': 'Confirm Sign-up',
        'confirmSignInMfa': 'Confirm Sign-in',
        'confirmSignInNewPassword': 'Confirm Sign-in',
        'sendCode': 'Send Code',
        'resetPassword': 'Reset Password',
        'verifyUser': 'Verify User',
        'confirmVerifyUser': 'Confirm Verify User',
        'other': 'ERROR',
      },
    );
    return 'Back to $_temp0';
  }

  @override
  String signInWith(String provider) {
    String _temp0 = intl.Intl.selectLogic(
      provider,
      {
        'google': 'Google',
        'facebook': 'Facebook',
        'amazon': 'Amazon',
        'apple': 'Apple',
        'other': 'ERROR',
      },
    );
    return 'Sign In with $_temp0';
  }

  @override
  String get selectDialCode => 'Select your country dial code';

  @override
  String get noDialCodeSearchResults => 'No search results match your criteria';

  @override
  String get af => 'Afghanistan';

  @override
  String get ax => 'Aland Islands';

  @override
  String get al => 'Albania';

  @override
  String get dz => 'Algeria';

  @override
  String get as1 => 'American Samoa';

  @override
  String get ad => 'Andorra';

  @override
  String get ao => 'Angola';

  @override
  String get ai => 'Anguilla';

  @override
  String get aq => 'Antarctica';

  @override
  String get ag => 'Antigua and Barbuda';

  @override
  String get ar => 'Argentina';

  @override
  String get am => 'Armenia';

  @override
  String get aw => 'Aruba';

  @override
  String get au => 'Australia';

  @override
  String get at => 'Austria';

  @override
  String get az => 'Azerbaijan';

  @override
  String get bs => 'Bahamas';

  @override
  String get bh => 'Bahrain';

  @override
  String get bd => 'Bangladesh';

  @override
  String get bb => 'Barbados';

  @override
  String get by => 'Belarus';

  @override
  String get be => 'Belgium';

  @override
  String get bz => 'Belize';

  @override
  String get bj => 'Benin';

  @override
  String get bm => 'Bermuda';

  @override
  String get bt => 'Bhutan';

  @override
  String get bo => 'Bolivia (Plurinational State of)';

  @override
  String get bq => 'Bonaire, Sint Eustatius and Saba';

  @override
  String get ba => 'Bosnia and Herzegovina';

  @override
  String get bw => 'Botswana';

  @override
  String get br => 'Brazil';

  @override
  String get io => 'British Indian Ocean Territory';

  @override
  String get bn => 'Brunei';

  @override
  String get bg => 'Bulgaria';

  @override
  String get bf => 'Burkina Faso';

  @override
  String get bi => 'Burundi';

  @override
  String get kh => 'Cambodia';

  @override
  String get cm => 'Cameroon';

  @override
  String get ca => 'Canada';

  @override
  String get cv => 'Cape Verde';

  @override
  String get ky => 'Cayman Islands';

  @override
  String get cf => 'Central African Republic';

  @override
  String get td => 'Chad';

  @override
  String get cl => 'Chile';

  @override
  String get cn => 'China';

  @override
  String get cx => 'Christmas Island';

  @override
  String get cc => 'Cocos (Keeling) Islands';

  @override
  String get co => 'Colombia';

  @override
  String get km => 'Comoros';

  @override
  String get cg => 'Congo (Republic of)';

  @override
  String get cd => 'Congo (Democratic Republic of)';

  @override
  String get ck => 'Cook Islands';

  @override
  String get cr => 'Costa Rica';

  @override
  String get ci => 'Côte d\'Ivoire';

  @override
  String get hr => 'Croatia';

  @override
  String get cu => 'Cuba';

  @override
  String get cy => 'Cyprus';

  @override
  String get cz => 'Czech Republic';

  @override
  String get dk => 'Denmark';

  @override
  String get dj => 'Djibouti';

  @override
  String get dm => 'Dominica';

  @override
  String get do1 => 'Dominican Republic';

  @override
  String get ec => 'Ecuador';

  @override
  String get eg => 'Egypt';

  @override
  String get sv => 'El Salvador';

  @override
  String get gq => 'Equatorial Guinea';

  @override
  String get er => 'Eritrea';

  @override
  String get ee => 'Estonia';

  @override
  String get sz => 'Eswatini';

  @override
  String get et => 'Ethiopia';

  @override
  String get fk => 'Falkland Islands (Malvinas)';

  @override
  String get fo => 'Faroe Islands';

  @override
  String get fj => 'Fiji';

  @override
  String get fi => 'Finland';

  @override
  String get fr => 'France';

  @override
  String get gf => 'French Guiana';

  @override
  String get pf => 'French Polynesia';

  @override
  String get ga => 'Gabon';

  @override
  String get gm => 'Gambia';

  @override
  String get ge => 'Georgia';

  @override
  String get de => 'Germany';

  @override
  String get gh => 'Ghana';

  @override
  String get gi => 'Gibraltar';

  @override
  String get gr => 'Greece';

  @override
  String get gl => 'Greenland';

  @override
  String get gd => 'Grenada';

  @override
  String get gp => 'Guadeloupe';

  @override
  String get gu => 'Guam';

  @override
  String get gt => 'Guatemala';

  @override
  String get gg => 'Guernsey';

  @override
  String get gn => 'Guinea';

  @override
  String get gw => 'Guinea-Bissau';

  @override
  String get gy => 'Guyana';

  @override
  String get ht => 'Haiti';

  @override
  String get va => 'Holy See (Vatican City State)';

  @override
  String get hn => 'Honduras';

  @override
  String get hk => 'Hong Kong';

  @override
  String get hu => 'Hungary';

  @override
  String get is1 => 'Iceland';

  @override
  String get in1 => 'India';

  @override
  String get id => 'Indonesia';

  @override
  String get ir => 'Iran (Islamic Republic of)';

  @override
  String get iq => 'Iraq';

  @override
  String get ie => 'Ireland';

  @override
  String get im => 'Isle of Man';

  @override
  String get il => 'Israel';

  @override
  String get it => 'Italy';

  @override
  String get jm => 'Jamaica';

  @override
  String get jp => 'Japan';

  @override
  String get je => 'Jersey';

  @override
  String get jo => 'Jordan';

  @override
  String get kz => 'Kazakhstan';

  @override
  String get ke => 'Kenya';

  @override
  String get ki => 'Kiribati';

  @override
  String get kp => 'Korea (Democratic People\'s Republic of)';

  @override
  String get kr => 'Korea (Republic of)';

  @override
  String get xk => 'Kosovo';

  @override
  String get kw => 'Kuwait';

  @override
  String get kg => 'Kyrgyzstan';

  @override
  String get la => 'Laos';

  @override
  String get lv => 'Latvia';

  @override
  String get lb => 'Lebanon';

  @override
  String get ls => 'Lesotho';

  @override
  String get lr => 'Liberia';

  @override
  String get ly => 'Libya';

  @override
  String get li => 'Liechtenstein';

  @override
  String get lt => 'Lithuania';

  @override
  String get lu => 'Luxembourg';

  @override
  String get mo => 'Macao';

  @override
  String get mk => 'Macedonia';

  @override
  String get mg => 'Madagascar';

  @override
  String get mw => 'Malawi';

  @override
  String get my => 'Malaysia';

  @override
  String get mv => 'Maldives';

  @override
  String get ml => 'Mali';

  @override
  String get mt => 'Malta';

  @override
  String get mh => 'Marshall Islands';

  @override
  String get mq => 'Martinique';

  @override
  String get mr => 'Mauritania';

  @override
  String get mu => 'Mauritius';

  @override
  String get yt => 'Mayotte';

  @override
  String get mx => 'Mexico';

  @override
  String get fm => 'Micronesia (Federated States of)';

  @override
  String get md => 'Moldova';

  @override
  String get mc => 'Monaco';

  @override
  String get mn => 'Mongolia';

  @override
  String get me => 'Montenegro';

  @override
  String get ms => 'Montserrat';

  @override
  String get ma => 'Morocco';

  @override
  String get mz => 'Mozambique';

  @override
  String get mm => 'Myanmar';

  @override
  String get na => 'Namibia';

  @override
  String get nr => 'Nauru';

  @override
  String get np => 'Nepal';

  @override
  String get nl => 'Netherlands';

  @override
  String get nc => 'New Caledonia';

  @override
  String get nz => 'New Zealand';

  @override
  String get ni => 'Nicaragua';

  @override
  String get ne => 'Niger';

  @override
  String get ng => 'Nigeria';

  @override
  String get nu => 'Niue';

  @override
  String get nf => 'Norfolk Island';

  @override
  String get mp => 'Northern Mariana Islands';

  @override
  String get no => 'Norway';

  @override
  String get om => 'Oman';

  @override
  String get pk => 'Pakistan';

  @override
  String get pw => 'Palau';

  @override
  String get ps => 'Palestine (State of)';

  @override
  String get pa => 'Panama';

  @override
  String get pg => 'Papua New Guinea';

  @override
  String get py => 'Paraguay';

  @override
  String get pe => 'Peru';

  @override
  String get ph => 'Philippines';

  @override
  String get pn => 'Pitcairn';

  @override
  String get pl => 'Poland';

  @override
  String get pt => 'Portugal';

  @override
  String get pr => 'Puerto Rico';

  @override
  String get qa => 'Qatar';

  @override
  String get re => 'Reunion';

  @override
  String get ro => 'Romania';

  @override
  String get ru => 'Russia';

  @override
  String get rw => 'Rwanda';

  @override
  String get bl => 'Saint Barthelemy';

  @override
  String get sh => 'Saint Helena, Ascension and Tristan Da Cunha';

  @override
  String get kn => 'Saint Kitts and Nevis';

  @override
  String get lc => 'Saint Lucia';

  @override
  String get mf => 'Saint Martin';

  @override
  String get pm => 'Saint Pierre and Miquelon';

  @override
  String get vc => 'Saint Vincent and the Grenadines';

  @override
  String get ws => 'Samoa';

  @override
  String get sm => 'San Marino';

  @override
  String get st => 'Sao Tome and Principe';

  @override
  String get sa => 'Saudi Arabia';

  @override
  String get sn => 'Senegal';

  @override
  String get rs => 'Serbia';

  @override
  String get sc => 'Seychelles';

  @override
  String get sl => 'Sierra Leone';

  @override
  String get sg => 'Singapore';

  @override
  String get sk => 'Slovakia';

  @override
  String get si => 'Slovenia';

  @override
  String get sb => 'Solomon Islands';

  @override
  String get so => 'Somalia';

  @override
  String get za => 'South Africa';

  @override
  String get gs => 'South Georgia and the South Sandwich Islands';

  @override
  String get ss => 'South Sudan';

  @override
  String get es => 'Spain';

  @override
  String get lk => 'Sri Lanka';

  @override
  String get sd => 'Sudan';

  @override
  String get sr => 'Suriname';

  @override
  String get sj => 'Svalbard and Jan Mayen';

  @override
  String get se => 'Sweden';

  @override
  String get ch => 'Switzerland';

  @override
  String get sy => 'Syrian Arab Republic';

  @override
  String get tw => 'Taiwan';

  @override
  String get tj => 'Tajikistan';

  @override
  String get tz => 'Tanzania (United Republic of)';

  @override
  String get th => 'Thailand';

  @override
  String get tl => 'Timor-Leste (East Timor)';

  @override
  String get tg => 'Togo';

  @override
  String get tk => 'Tokelau';

  @override
  String get to => 'Tonga';

  @override
  String get tt => 'Trinidad and Tobago';

  @override
  String get tn => 'Tunisia';

  @override
  String get tr => 'Turkey';

  @override
  String get tm => 'Turkmenistan';

  @override
  String get tc => 'Turks and Caicos Islands';

  @override
  String get tv => 'Tuvalu';

  @override
  String get ug => 'Uganda';

  @override
  String get ua => 'Ukraine';

  @override
  String get ae => 'United Arab Emirates';

  @override
  String get gb => 'United Kingdom';

  @override
  String get um => 'United States Minor Outlying Islands';

  @override
  String get us => 'United States';

  @override
  String get uy => 'Uruguay';

  @override
  String get uz => 'Uzbekistan';

  @override
  String get vu => 'Vanuatu';

  @override
  String get ve => 'Venezuela (Bolivarian Republic of)';

  @override
  String get vn => 'Vietnam';

  @override
  String get vg => 'Virgin Islands (British)';

  @override
  String get vi => 'Virgin Islands (US)';

  @override
  String get wf => 'Wallis and Futuna';

  @override
  String get ye => 'Yemen';

  @override
  String get zm => 'Zambia';

  @override
  String get zw => 'Zimbabwe';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get verificationCode => 'Verification Code';

  @override
  String get address => 'Address';

  @override
  String get middleName => 'Middle Name';

  @override
  String genders(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'male',
        'female': 'female',
        'other': 'other',
      },
    );
    return '$_temp0';
  }

  @override
  String get name => 'Name';

  @override
  String get nickname => 'Nickname';

  @override
  String or(String a, String b) {
    return '$a or $b';
  }

  @override
  String get preferredUsername => 'Preferred Username';

  @override
  String warnEmpty(String attribute) {
    return '$attribute field must not be blank.';
  }

  @override
  String warnInvalidFormat(String attributeType) {
    return 'Invalid $attributeType format.';
  }

  @override
  String promptFill(String attribute) {
    return 'Enter your $attribute';
  }

  @override
  String promptRefill(String attribute) {
    return 'Re-enter your $attribute';
  }

  @override
  String confirmAttribute(String attribute) {
    return 'Confirm $attribute';
  }

  @override
  String get usernameRequirements => 'Username must only contain alphanumeric characters and symbols.';

  @override
  String get passwordRequirementsPreamble => 'Password must include:';

  @override
  String passwordRequirementsCharacterType(String characterType) {
    String _temp0 = intl.Intl.selectLogic(
      characterType,
      {
        'requiresUppercase': 'uppercase',
        'requiresLowercase': 'lowercase',
        'requiresNumbers': 'number',
        'requiresSymbols': 'symbol',
        'other': '',
      },
    );
    return ' $_temp0';
  }

  @override
  String passwordRequirementsAtLeast(int numCharacters, String characterType) {
    String _temp0 = intl.Intl.pluralLogic(
      numCharacters,
      locale: localeName,
      other: '$numCharacters$characterType characters',
      one: '1$characterType character',
    );
    return 'at least $_temp0';
  }

  @override
  String get rememberDevice => 'Remember Device?';

  @override
  String get usernameType => 'Log in using:';

  @override
  String optional(String fieldTitle) {
    return '$fieldTitle (optional)';
  }

  @override
  String get customChallenge => 'Confirmation Code';

  @override
  String get selectSms => 'Text Message (SMS)';

  @override
  String get selectTotp => 'Authenticator App (TOTP)';

  @override
  String get totpCodePrompt => 'Please enter the code from your registered Authenticator app';

  @override
  String get selectEmail => 'Email';

  @override
  String get rolePlaceholder => 'Role';

  @override
  String codeSent(String destination) {
    return 'A confirmation code has been sent to $destination.';
  }

  @override
  String get codeSentUnknown => 'A confirmation code has been sent.';

  @override
  String get copySucceeded => 'Copied to clipboard!';

  @override
  String get copyFailed => 'Copy to clipboard failed.';

  @override
  String get totpStep1Title => 'Step 1: Download an Authenticator app';

  @override
  String get totpStep2Title => 'Step 2: Scan the QR code';

  @override
  String get totpStep3Title => 'Step 3: Verify your code';

  @override
  String get totpStep1Body => 'Authenticator apps generate one-time codes that can be used to verify your identity';

  @override
  String get totpStep2Body => 'Open then Authenticator app and scan the QR code or enter the key to get your verification code';

  @override
  String get totpStep3Body => 'Enter the 6 digit code from your Authenticator app';

  @override
  String get confirmSignUp => 'Enter your confirmation code';

  @override
  String get confirmSignInMfa => 'Enter your sign in code';

  @override
  String get confirmSignInCustomAuth => 'Enter your sign in code';

  @override
  String get confirmSignInNewPassword => 'Change your password to sign in';

  @override
  String get continueSignInWithMfaSelection => 'Select your preferred Two-Factor Auth method';

  @override
  String get continueSignInWithTotpSetup => 'Enable Two-Factor Auth';

  @override
  String get confirmSignInWithTotpMfaCode => 'Enter your one-time passcode';

  @override
  String get resetPassword => 'Send Code';

  @override
  String get verifyUser => 'Account recovery requires verified contact information';
}
