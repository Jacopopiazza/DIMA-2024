// lib/views/user_views/preferences_page.dart

import 'package:dima_application/generated/flutter-models/AllergenEnum.dart';
import 'package:dima_application/generated/flutter-models/ExerciseFrequency.dart';
import 'package:dima_application/generated/flutter-models/UserDetails.dart';
import 'package:dima_application/models/input/update_user_details_input.dart';
import 'package:dima_application/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import project localizations and helpers
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:dima_application/utils/localization_helpers.dart'; // Import the helpers

import "package:amplify_flutter/amplify_flutter.dart"; // for safePrint

// --- State Management ---

// Represents the different states the page can be in
enum PreferencesStateStatus { initial, loading, loaded, saving, error, saved }

// Immutable state class for the preferences page
@immutable
class PreferencesPageState {
  final PreferencesStateStatus status;
  final UserDetails? userDetails; // Current details fetched from backend
  final String? errorMessage;

  const PreferencesPageState({
    this.status = PreferencesStateStatus.initial,
    this.userDetails,
    this.errorMessage,
  });

  // Creates a copy of the state, updating only specified fields
  PreferencesPageState copyWith({
    PreferencesStateStatus? status,
    UserDetails? userDetails,
    String? errorMessage,
    // Utility flag to easily clear error messages when setting other states
    bool clearError = false,
  }) {
    return PreferencesPageState(
      status: status ?? this.status,
      userDetails: userDetails ?? this.userDetails,
      // Clear error if requested or if setting a non-error status without providing a new error
      errorMessage: clearError || (errorMessage == null && status != PreferencesStateStatus.error)
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}

// Notifier to handle fetching and updating user preferences
class PreferencesNotifier extends StateNotifier<PreferencesPageState> {
  final ApiService _apiService;

  PreferencesNotifier(this._apiService) : super(const PreferencesPageState()) {
    // Fetch initial details when the notifier is created
    fetchUserDetails();
  }

  // Helper to create a deep copy of UserDetails (since Amplify models might be mutable)
  UserDetails _cloneUserDetails(UserDetails original) {
     return UserDetails(
        userId: original.userId,
        updatedAt: original.updatedAt,
        activeMealPlanId: original.activeMealPlanId,
        // Ensure lists are copied, not just referenced
        allergies: List<AllergenEnum>.from(original.allergies ?? []),
        dailyMealsPreference: original.dailyMealsPreference,
        dietaryRestrictions: List<String>.from(original.dietaryRestrictions ?? []),
        exerciseFrequency: original.exerciseFrequency,
        heightCm: original.heightCm,
        openTextPreferences: original.openTextPreferences,
        targetCalories: original.targetCalories,
        weightKg: original.weightKg,
     );
  }

  /// Fetches the current user details from the backend.
  Future<void> fetchUserDetails() async {
    // Set loading state and clear any previous errors
    state = state.copyWith(status: PreferencesStateStatus.loading, clearError: true);
    try {
      final userDetails = await _apiService.getMyUserDetails();
      if (userDetails != null) {
         // Clone for immutability within the state
         final clonedDetails = _cloneUserDetails(userDetails);
         state = state.copyWith(status: PreferencesStateStatus.loaded, userDetails: clonedDetails);
      } else {
         // Handle case where backend returns null (e.g., user not found)
         state = state.copyWith(
             status: PreferencesStateStatus.error,
             // Use a localized string here if possible
             errorMessage: "Failed to load user details. User not found or error occurred."
         );
      }
    } catch (e, stackTrace) { // Catch stack trace for better debugging
      // Use safePrint or a proper logging framework
      safePrint('Error fetching user details: $e\n$stackTrace');
      state = state.copyWith(
          status: PreferencesStateStatus.error,
          // Provide a user-friendly message, potentially based on error type
          errorMessage: "An error occurred while loading preferences: ${e.toString()}"
      );
    }
  }

  /// Saves the updated user details to the backend.
  /// Accepts the data structure required by the ApiService update method.
  Future<bool> saveUserDetails(UpdateUserDetailsInput updatedDetailsInput) async {
    // Set saving state and clear errors
    state = state.copyWith(status: PreferencesStateStatus.saving, clearError: true);
    try {
      // IMPORTANT: Ensure `updatedDetailsInput` matches the exact type and fields
      // expected by `_apiService.updateMyUserDetails`.
      // If it expects `UpdateUserDetailsInput`, construct that instead.
      final result = await _apiService.updateMyUserDetails(updatedDetailsInput);

      if (result != null) {
          // Update state with the confirmed saved details (cloned)
          final savedClonedDetails = _cloneUserDetails(result);
          state = state.copyWith(status: PreferencesStateStatus.saved, userDetails: savedClonedDetails);
          // Reset to 'loaded' state after a short delay to show confirmation in UI
           Future.delayed(const Duration(seconds: 1), () {
             // Check if the notifier is still alive before updating state
             if (mounted) {
                state = state.copyWith(status: PreferencesStateStatus.loaded);
             }
           });
          return true; // Indicate success
      } else {
         // Handle failure case from the API
         state = state.copyWith(
             status: PreferencesStateStatus.error,
             // Use localized string
             errorMessage: "Failed to save user details. Please try again."
          );
         return false; // Indicate failure
      }
    } catch (e, stackTrace) { // Catch stack trace
      safePrint('Error saving user details: $e\n$stackTrace');
      state = state.copyWith(
          status: PreferencesStateStatus.error,
          // Provide user-friendly error
          errorMessage: "An error occurred while saving preferences: ${e.toString()}"
      );
      return false; // Indicate failure
    }
  }
}

// Riverpod provider for the PreferencesNotifier
final preferencesProvider = StateNotifierProvider<PreferencesNotifier, PreferencesPageState>((ref) {
  // Assume apiServiceProvider is defined elsewhere and provides the ApiService instance
  final apiService = ref.watch(apiServiceProvider);
  return PreferencesNotifier(apiService);
});


// --- UI ---

class PreferencesPage extends ConsumerStatefulWidget {
  const PreferencesPage({super.key});

  @override
  ConsumerState<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends ConsumerState<PreferencesPage> {
  // Key to manage the Form state (validation, saving)
  final _formKey = GlobalKey<FormState>();

  // Controllers to manage text field input
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _targetCaloriesController;
  late TextEditingController _dietaryRestrictionsController;
  late TextEditingController _openTextPreferencesController;

  // Local state for multi-select chips and dropdowns
  // Initialized empty, populated when data loads
  Set<AllergenEnum> _selectedAllergens = {};
  ExerciseFrequency? _selectedExerciseFrequency;
  int? _selectedDailyMealsPreference;

  // Flag to prevent multiple simultaneous save attempts
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers (empty initially)
    _weightController = TextEditingController();
    _heightController = TextEditingController();
    _targetCaloriesController = TextEditingController();
    _dietaryRestrictionsController = TextEditingController();
    _openTextPreferencesController = TextEditingController();

    // Listen to state changes from the provider to update the form fields
     ref.listenManual(preferencesProvider, (previous, next) {
        // Update form when data is successfully loaded or after a save completes
        if ((next.status == PreferencesStateStatus.loaded || next.status == PreferencesStateStatus.saved) && next.userDetails != null) {
          // Check if the widget is still mounted before calling setState
          if (mounted) {
             _updateControllersAndState(next.userDetails);
          }
        }
        // Handle potential error states if needed (e.g., clear fields on certain errors)
     });

     // Attempt to populate controllers if data is already available when the widget builds
      WidgetsBinding.instance.addPostFrameCallback((_) {
         if (!mounted) return; // Check mounted status
        final currentState = ref.read(preferencesProvider);
        if ((currentState.status == PreferencesStateStatus.loaded || currentState.status == PreferencesStateStatus.saved) && currentState.userDetails != null) {
           _updateControllersAndState(currentState.userDetails);
        }
        // Optionally trigger fetch if initial state is detected (though notifier does this)
        // else if (currentState.status == PreferencesStateStatus.initial) {
        //    ref.read(preferencesProvider.notifier).fetchUserDetails();
        // }
      });
  }

   /// Updates the text controllers and local selection state from the UserDetails model.
   void _updateControllersAndState(UserDetails? details) {
     if (details == null) return;
     // Call setState to trigger a UI rebuild with the new values
     setState(() {
       _weightController.text = details.weightKg?.toStringAsFixed(1) ?? '';
       _heightController.text = details.heightCm?.toStringAsFixed(1) ?? '';
       _targetCaloriesController.text = details.targetCalories?.round().toString() ?? '';
       // Join list with comma and space for display, handle null/empty list
       _dietaryRestrictionsController.text = (details.dietaryRestrictions ?? []).join(', ');
       _openTextPreferencesController.text = details.openTextPreferences ?? '';
       // Create a new Set from the list for the state
       _selectedAllergens = Set.from(details.allergies ?? []);
       _selectedExerciseFrequency = details.exerciseFrequency;
       _selectedDailyMealsPreference = details.dailyMealsPreference;
     });
   }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _weightController.dispose();
    _heightController.dispose();
    _targetCaloriesController.dispose();
    _dietaryRestrictionsController.dispose();
    _openTextPreferencesController.dispose();
    super.dispose();
  }

  /// Handles form validation and submission.
  Future<void> _submitForm() async {
    // Prevent saving if already in progress
    if (_isSaving) return;

    // Validate the form using the GlobalKey
    if (!_formKey.currentState!.validate()) {
        // Use context safely within the synchronous validation block
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.pleaseCorrectErrors)),
        );
       return;
    }

    // Optional: Trigger onSaved if using them (usually not needed with controllers)
    // _formKey.currentState!.save();

    final originalDetails = ref.read(preferencesProvider).userDetails;
    // Ensure we have the original details to get the userId
    if (originalDetails == null) {
       safePrint("Error: Cannot save, original details are null.");
       // Show an error message if appropriate
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(AppLocalizations.of(context)!.errorSavingPreferences)),
         );
       }
       return;
    }

    // Set the saving flag to disable UI elements
    setState(() { _isSaving = true; });

    // --- Prepare Data for API ---
    // Parse values safely from controllers
    final double? weightKg = double.tryParse(_weightController.text);
    final double? heightCm = double.tryParse(_heightController.text);
    final double? targetCalories = double.tryParse(_targetCaloriesController.text); // Keep as double if API expects double
    final int? dailyMeals = _selectedDailyMealsPreference;
    // Process dietary restrictions: split by comma, trim whitespace, remove empty strings
    final List<String> dietaryRestrictions = _dietaryRestrictionsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    // Handle open text preferences: null if empty after trimming
    final String? openText = _openTextPreferencesController.text.trim().isEmpty
        ? null
        : _openTextPreferencesController.text.trim();

    // Construct the object expected by your API service.
    // This might be UserDetails or a specific Input object like UpdateUserDetailsInput.
    final updatedDetailsForApi = UpdateUserDetailsInput(
        // Provide updated values, potentially null if cleared
        weightKg: weightKg,
        heightCm: heightCm,
        targetCalories: targetCalories,
        allergies: _selectedAllergens.toList(), // Convert Set back to List
        dailyMealsPreference: dailyMeals,
        dietaryRestrictions: dietaryRestrictions,
        exerciseFrequency: _selectedExerciseFrequency,
        openTextPreferences: openText,
        // ** DO NOT ** include fields like createdAt, updatedAt, activeMealPlanId
        // unless your specific backend mutation requires them.
    );

    // --- Call API via Notifier ---
    final success = await ref
        .read(preferencesProvider.notifier)
        .saveUserDetails(updatedDetailsForApi);

    // --- Handle Result (check mounted AFTER await) ---
    if (!mounted) return;

    // Reset the saving flag regardless of outcome
    setState(() { _isSaving = false; });

    // Show feedback SnackBar
    // Get fresh context-dependent variables *after* the mounted check
    final localizations = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final currentTheme = Theme.of(context);

    if (success) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(localizations.preferencesSavedSuccess)),
      );
      // Consider popping the screen on success if desired
      // Navigator.of(context).pop();
    } else {
      // Use the error message stored in the provider state
       scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(ref.read(preferencesProvider).errorMessage ?? localizations.errorSavingPreferences),
          backgroundColor: currentTheme.colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider state for changes
    final state = ref.watch(preferencesProvider);
    // Get localizations and theme safely within the build method
    final localizations = AppLocalizations.of(context)!;
    final currentTheme = Theme.of(context);

    // === Loading State ===
    if (state.status == PreferencesStateStatus.loading || state.status == PreferencesStateStatus.initial) {
      return Scaffold(
        appBar: AppBar(title: Text(localizations.changePreferences)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // === Initial Error State ===
    // Show error only if loading failed and we don't have any details to show
    if (state.status == PreferencesStateStatus.error && state.userDetails == null) {
        return Scaffold(
            appBar: AppBar(title: Text(localizations.changePreferences)),
            body: Center(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Icon(Icons.error_outline, color: currentTheme.colorScheme.error, size: 48),
                            const SizedBox(height: 16),
                            Text(localizations.errorLoadingPreferences, textAlign: TextAlign.center, style: currentTheme.textTheme.headlineSmall),
                            const SizedBox(height: 8),
                            Text(state.errorMessage ?? '', style: currentTheme.textTheme.bodyMedium, textAlign: TextAlign.center),
                             const SizedBox(height: 24),
                             ElevatedButton.icon(
                                icon: const Icon(Icons.refresh),
                                label: Text(localizations.retry),
                                onPressed: state.status == PreferencesStateStatus.loading
                                    ? null // Disable button while loading
                                    : () => ref.read(preferencesProvider.notifier).fetchUserDetails(),
                            )
                        ]
                    )
                ),
            ),
        );
    }

    // === Main Form UI (Loaded or Saving State) ===
    // This part is shown once data is loaded, even if a save is in progress or failed
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.changePreferences),
        actions: [
          // Show progress indicator in AppBar if saving
          if (_isSaving || state.status == PreferencesStateStatus.saving)
             const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0), // Add padding
                child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.white))) // Use white for AppBar
             )
          else
            // Show save button otherwise
            IconButton(
              icon: const Icon(Icons.save_alt_outlined), // Use a different save icon?
              tooltip: localizations.saveChanges,
              onPressed: _isSaving ? null : _submitForm, // Disable if saving
            ),
        ],
      ),
      // Use SafeArea to avoid overlaps with notches, status bars etc.
      body: SafeArea(
        child: SingleChildScrollView(
          // Add padding around the entire form
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            // Disable the entire form visually while saving
            child: AbsorbPointer(
               absorbing: _isSaving || state.status == PreferencesStateStatus.saving,
               child: Opacity( // Slightly fade form while saving
                 opacity: _isSaving || state.status == PreferencesStateStatus.saving ? 0.5 : 1.0,
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // --- Basic Info Section ---
                    _buildSectionHeader(context, localizations.basicInfo),
                    TextFormField(
                      controller: _weightController,
                      decoration: InputDecoration(
                          labelText: localizations.weightKg,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.monitor_weight_outlined) // Example Icon
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}'))],
                       validator: (value) {
                          if (value != null && value.isNotEmpty && double.tryParse(value) == null) {
                              return localizations.invalidNumberFormat;
                          }
                          return null; // Add range validation if needed
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _heightController,
                      decoration: InputDecoration(
                          labelText: localizations.heightCm,
                          border: const OutlineInputBorder(),
                           prefixIcon: const Icon(Icons.height_outlined) // Example Icon
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                       inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}'))],
                       validator: (value) {
                          if (value != null && value.isNotEmpty && double.tryParse(value) == null) {
                              return localizations.invalidNumberFormat;
                          }
                          return null;
                      },
                    ),
                    const SizedBox(height: 16),
                     TextFormField(
                      controller: _targetCaloriesController,
                      decoration: InputDecoration(
                          labelText: localizations.targetCalories,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.local_fire_department_outlined) // Example Icon
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: false),
                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                       validator: (value) {
                          if (value == null || value.isEmpty) return null; // Allow empty
                          final calories = int.tryParse(value);
                          if (calories == null) {
                              return localizations.invalidNumberFormat;
                          }
                           if (calories < 500 || calories > 10000) {
                             return localizations.caloriesOutOfRange;
                           }
                          return null;
                      },
                    ),
                     const SizedBox(height: 24),

                    // --- Dietary Needs Section ---
                     _buildSectionHeader(context, localizations.dietaryNeeds),
                    DropdownButtonFormField<int>(
                       value: _selectedDailyMealsPreference,
                       decoration: InputDecoration(
                           labelText: localizations.mealsPerDay,
                           border: const OutlineInputBorder(),
                           prefixIcon: const Icon(Icons.restaurant_menu_outlined) // Example Icon
                       ),
                       // Provide a reasonable list of options
                       items: [2, 3, 4, 5, 6].map((int value) {
                          return DropdownMenuItem<int>( value: value, child: Text(value.toString()));
                       }).toList(),
                       // Allow clearing the selection if needed by setting value to null
                       onChanged: (int? newValue) { setState(() { _selectedDailyMealsPreference = newValue; }); },
                       // Add validator if this field is required
                    ),
                     const SizedBox(height: 16),
                    TextFormField(
                      controller: _dietaryRestrictionsController,
                      decoration: InputDecoration(
                          labelText: localizations.dietaryRestrictions,
                          hintText: localizations.dietaryRestrictionsHint,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.no_food_outlined) // Example Icon
                      ),
                       // No specific validator unless required
                    ),
                    const SizedBox(height: 16),
                     // Sub-header for Allergies
                     Text(localizations.allergies, style: currentTheme.textTheme.titleMedium),
                     const SizedBox(height: 8),
                     // Use a Card for better visual grouping of chips
                     Card(
                       elevation: 0,
                       shape: RoundedRectangleBorder(
                         side: BorderSide(color: currentTheme.dividerColor),
                         borderRadius: BorderRadius.circular(8),
                       ),
                       clipBehavior: Clip.antiAlias, // Ensures padding respects border radius
                       child: Padding(
                         padding: const EdgeInsets.all(12.0),
                         child: Wrap(
                           spacing: 8.0, // Horizontal space between chips
                           runSpacing: 4.0, // Vertical space between lines of chips
                           children: AllergenEnum.values.map((allergen) {
                             // Use the localization helper function
                             String allergenName = localizeAllergen(context, allergen);
                             final bool isSelected = _selectedAllergens.contains(allergen);
                             return FilterChip(
                               label: Text(allergenName),
                               selected: isSelected,
                               onSelected: (bool selected) {
                                 setState(() {
                                   if (selected) {
                                     _selectedAllergens.add(allergen);
                                   } else {
                                     _selectedAllergens.remove(allergen);
                                   }
                                 });
                               },
                               // Optional: Style selected chips differently
                               selectedColor: currentTheme.colorScheme.primaryContainer,
                               checkmarkColor: currentTheme.colorScheme.onPrimaryContainer,
                             );
                           }).toList(),
                         ),
                       ),
                     ),
                     const SizedBox(height: 24),

                    // --- Lifestyle Section ---
                     _buildSectionHeader(context, localizations.lifestyle),
                     DropdownButtonFormField<ExerciseFrequency>(
                       value: _selectedExerciseFrequency,
                       decoration: InputDecoration(
                           labelText: localizations.exerciseFrequency,
                           border: const OutlineInputBorder(),
                           prefixIcon: const Icon(Icons.fitness_center_outlined) // Example Icon
                       ),
                       // Filter out enum values that shouldn't be selectable
                       items: ExerciseFrequency.values
                        .where((f) => f != ExerciseFrequency.Or /* Add others like NOT_SPECIFIED if needed */ )
                        .map((ExerciseFrequency frequency) {
                          // Use the localization helper function
                          String frequencyName = localizeExerciseFrequency(context, frequency);
                          return DropdownMenuItem<ExerciseFrequency>(
                              value: frequency,
                              child: Text(frequencyName),
                          );
                       }).toList(),
                       onChanged: (ExerciseFrequency? newValue) { setState(() { _selectedExerciseFrequency = newValue; }); },
                        // Add validator if required
                    ),
                     const SizedBox(height: 24),

                     // --- Other Preferences Section ---
                     _buildSectionHeader(context, localizations.otherPreferences),
                     TextFormField(
                        controller: _openTextPreferencesController,
                        decoration: InputDecoration(
                          labelText: localizations.additionalNotes,
                          hintText: localizations.additionalNotesHint,
                          border: const OutlineInputBorder(),
                          // prefixIcon: Icon(Icons.notes_outlined) // Optional icon
                        ),
                        maxLines: 4, // Increase max lines for more text
                        textInputAction: TextInputAction.done, // Change keyboard action
                     ),
                      const SizedBox(height: 30),

                      // Optional: Place save button at the bottom as well/instead
                      // Center(
                      //   child: ElevatedButton.icon(
                      //     icon: _isSaving ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Icon(Icons.save),
                      //     label: Text(localizations.saveChanges),
                      //     onPressed: _isSaving ? null : _submitForm,
                      //   ),
                      // ),

                  ],
                ),
               ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget to build consistent section headers
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0), // Add some top padding too
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary, // Use primary color for headers
        ),
      ),
    );
  }
}

