import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/flutter-models/ModelProvider.dart';
import '../../providers/meal_plans_provider.dart';
import '../../providers/user_details_provider.dart';
import '../UserViews/SettingsScreen/settings_screen_riverpod.dart';

class GenerateMealPlanPage extends ConsumerStatefulWidget {
  const GenerateMealPlanPage({super.key});

  @override
  ConsumerState<GenerateMealPlanPage> createState() =>
      _GenerateMealPlanPageState();
}

class _GenerateMealPlanPageState extends ConsumerState<GenerateMealPlanPage> {
  bool _showPreferenceOverrides = false;
  bool _useOverrides = false;

  // Override controllers
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _dietaryRestrictionsController =
      TextEditingController();
  final TextEditingController _openTextPreferencesController =
      TextEditingController();

  // Override values
  int? _dailyMealsPreference;
  ExerciseFrequency? _exerciseFrequency;
  List<AllergenEnum> _selectedAllergies = [];

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _dietaryRestrictionsController.dispose();
    _openTextPreferencesController.dispose();
    super.dispose();
  }

  /// Initialize override fields with user details as defaults
  void _initializeOverrides(dynamic userDetails) {
    if (userDetails != null) {
      _weightController.text = userDetails.weightKg?.toString() ?? '';
      _heightController.text = userDetails.heightCm?.toString() ?? '';
      _dietaryRestrictionsController.text =
          userDetails.dietaryRestrictions ?? '';
      _openTextPreferencesController.text =
          userDetails.openTextPreferences ?? '';
      _dailyMealsPreference = userDetails.dailyMealsPreference;
      _exerciseFrequency = userDetails.exerciseFrequency;
      _selectedAllergies = (userDetails.allergies as List<dynamic>?)
              ?.map((e) => AllergenEnum.values.firstWhere(
                    (allergen) => allergen.name == e,
                    orElse: () => AllergenEnum.GLUTEN_CEREALS,
                  ))
              .toList() ??
          [];
    } else {
      // Set reasonable defaults
      _weightController.text = '70';
      _heightController.text = '170';
      _dailyMealsPreference = 3;
      _exerciseFrequency = ExerciseFrequency.TWICE_A_WEEK;
      _selectedAllergies = [];
      _dietaryRestrictionsController.text = '';
      _openTextPreferencesController.text = '';
    }
  }

  /// Converts UserDetails to preferences format for meal plan creation
  Map<String, dynamic> _buildPreferencesFromUserDetails(dynamic userDetails) {
    if (_useOverrides) {
      return _buildOverridePreferences();
    }

    if (userDetails == null) return _buildDefaultPreferences();

    final prefs = <String, dynamic>{};

    if (userDetails.weightKg != null) {
      prefs['weightKg'] = userDetails.weightKg;
    }
    if (userDetails.heightCm != null) {
      prefs['heightCm'] = userDetails.heightCm;
    }
    if (userDetails.dailyMealsPreference != null) {
      prefs['dailyMealsPreference'] = userDetails.dailyMealsPreference;
    }
    if (userDetails.exerciseFrequency != null) {
      final freq = userDetails.exerciseFrequency;
      // Ensure enum is serialized as string
      prefs['exerciseFrequency'] = freq is Enum ? freq.name : freq.toString();
    }
    if (userDetails.allergies != null && userDetails.allergies.isNotEmpty) {
      final allergies = userDetails.allergies as List<dynamic>;
      // Ensure enums are serialized as string list
      prefs['allergies'] =
          allergies.map((e) => e is Enum ? e.name : e.toString()).toList();
    }
    if (userDetails.dietaryRestrictions != null &&
        userDetails.dietaryRestrictions.isNotEmpty) {
      prefs['dietaryRestrictions'] = userDetails.dietaryRestrictions;
    }
    if (userDetails.openTextPreferences != null &&
        userDetails.openTextPreferences.isNotEmpty) {
      prefs['openTextPreferences'] = userDetails.openTextPreferences;
    }

    // Add a default dateOfBirth if not present (required for meal plan generation)
    // Use a reasonable default (30 years old) if user hasn't provided their date of birth
    if (!prefs.containsKey('dateOfBirth')) {
      final thirtyYearsAgo =
          DateTime.now().subtract(const Duration(days: 30 * 365));
      prefs['dateOfBirth'] =
          '${thirtyYearsAgo.year}-${thirtyYearsAgo.month.toString().padLeft(2, '0')}-${thirtyYearsAgo.day.toString().padLeft(2, '0')}';
    }

    return prefs;
  }

  /// Build preferences from override fields
  Map<String, dynamic> _buildOverridePreferences() {
    final prefs = <String, dynamic>{};

    if (_weightController.text.isNotEmpty) {
      prefs['weightKg'] = double.tryParse(_weightController.text);
    }
    if (_heightController.text.isNotEmpty) {
      prefs['heightCm'] = double.tryParse(_heightController.text);
    }
    if (_dailyMealsPreference != null) {
      prefs['dailyMealsPreference'] = _dailyMealsPreference;
    }
    if (_exerciseFrequency != null) {
      prefs['exerciseFrequency'] = _exerciseFrequency!.name;
    }
    if (_selectedAllergies.isNotEmpty) {
      prefs['allergies'] = _selectedAllergies.map((e) => e.name).toList();
    }
    if (_dietaryRestrictionsController.text.isNotEmpty) {
      prefs['dietaryRestrictions'] = _dietaryRestrictionsController.text;
    }
    if (_openTextPreferencesController.text.isNotEmpty) {
      prefs['openTextPreferences'] = _openTextPreferencesController.text;
    }

    // Add default dateOfBirth
    final thirtyYearsAgo =
        DateTime.now().subtract(const Duration(days: 30 * 365));
    prefs['dateOfBirth'] =
        '${thirtyYearsAgo.year}-${thirtyYearsAgo.month.toString().padLeft(2, '0')}-${thirtyYearsAgo.day.toString().padLeft(2, '0')}';

    return prefs;
  }

  /// Build default preferences when no user details are available
  Map<String, dynamic> _buildDefaultPreferences() {
    final thirtyYearsAgo =
        DateTime.now().subtract(const Duration(days: 30 * 365));
    return {
      'weightKg': 70.0,
      'heightCm': 170.0,
      'dailyMealsPreference': 3,
      'exerciseFrequency': ExerciseFrequency.TWICE_A_WEEK.name,
      'allergies': <String>[],
      'dietaryRestrictions': '',
      'openTextPreferences': '',
      'dateOfBirth':
          '${thirtyYearsAgo.year}-${thirtyYearsAgo.month.toString().padLeft(2, '0')}-${thirtyYearsAgo.day.toString().padLeft(2, '0')}',
    };
  }

  /// Convert ExerciseFrequency enum to user-friendly display text
  String _getExerciseFrequencyDisplayText(ExerciseFrequency frequency) {
    switch (frequency) {
      case ExerciseFrequency.NOT_SPECIFIED:
        return 'Not specified';
      case ExerciseFrequency.NONE:
        return 'No exercise';
      case ExerciseFrequency.ONCE_A_WEEK:
        return 'Once a week';
      case ExerciseFrequency.TWICE_A_WEEK:
        return 'Twice a week';
      case ExerciseFrequency.THREE_TIMES_A_WEEK:
        return '3 times a week';
      case ExerciseFrequency.FOUR_TIMES_A_WEEK:
        return '4 times a week';
      case ExerciseFrequency.FIVE_TIMES_A_WEEK:
        return '5 times a week';
      case ExerciseFrequency.SIX_TIMES_A_WEEK:
        return '6 times a week';
      case ExerciseFrequency.EVERY_DAY:
        return 'Every day';
    }
  }

  /// Generate meal plan with current preferences
  Future<void> _generateMealPlan() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Creating meal plan...'),
        duration: Duration(seconds: 1),
      ),
    );

    final userDetailsAsync = ref.read(userDetailsProvider);
    final userDetails = userDetailsAsync.value?.$1;
    final preferences = _buildPreferencesFromUserDetails(userDetails);

    final success = await ref
        .read(mealPlansProvider.notifier)
        .createMealPlan(prefsOverride: preferences);

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Meal plan generation started! You\'ll receive a notification when it\'s ready.'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 4),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to start meal plan generation'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDetailsAsync = ref.watch(userDetailsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate New Meal Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: _generateMealPlan,
            tooltip: 'Create Meal Plan',
          ),
        ],
      ),
      body: userDetailsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text('Error loading user details: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(userDetailsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (data) {
          final userDetails = data.$1;
          final hasUserDetails = userDetails != null &&
              (userDetails.weightKg != null ||
                  userDetails.heightCm != null ||
                  userDetails.dailyMealsPreference != null ||
                  userDetails.exerciseFrequency != null ||
                  (userDetails.allergies?.isNotEmpty ?? false) ||
                  (userDetails.dietaryRestrictions?.isNotEmpty ?? false) ||
                  (userDetails.openTextPreferences?.isNotEmpty ?? false));

          // Initialize overrides when data is available
          if (!_showPreferenceOverrides) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _initializeOverrides(userDetails);
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // User Details Status Section
                if (!hasUserDetails) ...[
                  _buildNoUserDetailsGuidance(),
                  const SizedBox(height: 24),
                ] else ...[
                  _buildUserDetailsStatus(userDetails),
                  const SizedBox(height: 24),
                ],

                // Preference Override Section
                _buildPreferenceOverrideSection(userDetails),
                const SizedBox(height: 24),

                // Generate Button
                _buildGenerateButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoUserDetailsGuidance() {
    return Card(
      color: Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              Icons.info_outline,
              size: 48,
              color: Colors.orange[600],
            ),
            const SizedBox(height: 12),
            Text(
              'No User Details Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'To generate personalized meal plans, please set up your profile first. This includes your weight, height, dietary preferences, and allergies.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.orange[700]),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreenRiverpod(),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
              label: const Text('Go to Settings'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[600],
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Or continue with default preferences below',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetailsStatus(dynamic userDetails) {
    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[600]),
                const SizedBox(width: 8),
                Text(
                  'Profile Details Found',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildUserDetailsSummary(userDetails),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetailsSummary(dynamic userDetails) {
    final details = <String>[];

    if (userDetails.weightKg != null) {
      details.add('Weight: ${userDetails.weightKg}kg');
    }
    if (userDetails.heightCm != null) {
      details.add('Height: ${userDetails.heightCm}cm');
    }
    if (userDetails.dailyMealsPreference != null) {
      details.add('Daily meals: ${userDetails.dailyMealsPreference}');
    }
    if (userDetails.exerciseFrequency != null) {
      final freq = userDetails.exerciseFrequency!;
      details.add('Exercise: ${_getExerciseFrequencyDisplayText(freq)}');
    }
    if (userDetails.allergies != null && userDetails.allergies.isNotEmpty) {
      details.add('Allergies: ${userDetails.allergies.length} items');
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: details
          .map((detail) => Chip(
                label: Text(
                  detail,
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.green[100],
              ))
          .toList(),
    );
  }

  Widget _buildPreferenceOverrideSection(dynamic userDetails) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Preference Overrides',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Switch(
                  value: _useOverrides,
                  onChanged: (value) {
                    setState(() {
                      _useOverrides = value;
                      if (value && !_showPreferenceOverrides) {
                        _showPreferenceOverrides = true;
                        _initializeOverrides(userDetails);
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _useOverrides
                  ? 'Using custom preferences for this meal plan'
                  : 'Using your profile preferences',
              style: TextStyle(
                color: _useOverrides ? Colors.orange[700] : Colors.green[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            if (_useOverrides) ...[
              const SizedBox(height: 16),
              if (!_showPreferenceOverrides)
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showPreferenceOverrides = true;
                      _initializeOverrides(userDetails);
                    });
                  },
                  icon: const Icon(Icons.tune),
                  label: const Text('Configure Overrides'),
                )
              else
                _buildOverrideForm(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOverrideForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.orange[600], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'These preferences will override your profile settings for this meal plan only',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Physical Details
        Text(
          'Physical Details',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Meal Preferences
        Text(
          'Meal Preferences',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: _dailyMealsPreference,
          decoration: const InputDecoration(
            labelText: 'Daily Meals',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          items: [
            for (int i = 1; i <= 6; i++)
              DropdownMenuItem(value: i, child: Text('$i meals')),
          ],
          onChanged: (value) => setState(() => _dailyMealsPreference = value),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<ExerciseFrequency>(
          value: _exerciseFrequency,
          decoration: const InputDecoration(
            labelText: 'Exercise Frequency',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          items: ExerciseFrequency.values
              .map((freq) => DropdownMenuItem(
                    value: freq,
                    child: Text(_getExerciseFrequencyDisplayText(freq)),
                  ))
              .toList(),
          onChanged: (value) => setState(() => _exerciseFrequency = value),
        ),
        const SizedBox(height: 16),

        // Dietary Restrictions
        Text(
          'Dietary Information',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _dietaryRestrictionsController,
          decoration: const InputDecoration(
            labelText: 'Dietary Restrictions',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _openTextPreferencesController,
          decoration: const InputDecoration(
            labelText: 'Additional Preferences',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 16),

        // Allergies
        Text(
          'Allergies',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: AllergenEnum.values.map((allergen) {
            final isSelected = _selectedAllergies.contains(allergen);
            return FilterChip(
              label: Text(
                allergen.name.replaceAll('_', ' ').toLowerCase(),
                style: TextStyle(fontSize: 12),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedAllergies.add(allergen);
                  } else {
                    _selectedAllergies.remove(allergen);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return ElevatedButton.icon(
      onPressed: _generateMealPlan,
      icon: const Icon(Icons.restaurant_menu),
      label: Text(_useOverrides
          ? 'Generate with Custom Preferences'
          : 'Generate with Profile Preferences'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        backgroundColor: _useOverrides ? Colors.orange[600] : null,
        foregroundColor: _useOverrides ? Colors.white : null,
      ),
    );
  }
}
