import 'package:dima_application/Views/UserViews/SettingsScreen/settings_screen_riverpod.dart';
import 'package:dima_application/generated/flutter-models/AllergenEnum.dart';
import 'package:dima_application/generated/flutter-models/ExerciseFrequency.dart';
import 'package:dima_application/providers/meal_plans_provider.dart';
import 'package:dima_application/providers/user_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GenerateMealPlanPage extends ConsumerStatefulWidget {
  const GenerateMealPlanPage({super.key});

  @override
  ConsumerState<GenerateMealPlanPage> createState() =>
      _GenerateMealPlanPageState();
}

class _GenerateMealPlanPageState extends ConsumerState<GenerateMealPlanPage>
    with SingleTickerProviderStateMixin {
  bool _showPreferenceOverrides = false;
  bool _useOverrides = false;
  bool _isGenerating = false;

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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

    final locale = Localizations.localeOf(context);
    prefs['language'] = locale.languageCode;
    print('Generated preferences: $prefs');

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

    final locale = Localizations.localeOf(context);
    prefs['language'] = locale.languageCode;
    print('Generated preferences: $prefs');

    return prefs;
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
    if (_isGenerating) return;

    setState(() {
      _isGenerating = true;
    });

    final userDetailsAsync = ref.read(userDetailsProvider);
    final userDetails = userDetailsAsync.value?.$1;
    final preferences = _buildPreferencesFromUserDetails(userDetails);

    final success = await ref
        .read(mealPlansProvider.notifier)
        .createMealPlan(prefsOverride: preferences);

    setState(() {
      _isGenerating = false;
    });

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                    'Meal plan generation started! You\'ll receive a notification when it\'s ready.'),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 4),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.error_outline,
                    color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
              const Text('Failed to start meal plan generation'),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDetailsAsync = ref.watch(userDetailsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        title: Text(
          'Create Meal Plan',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: userDetailsAsync.when(
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: CircularProgressIndicator(
                  color: colorScheme.primary,
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Loading your preferences...',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        error: (error, stack) =>
            _buildErrorState(error.toString(), colorScheme, theme),
        data: (data) {
          final userDetails = data.$1;
          final hasUserDetails = userDetails != null &&
              (userDetails.weightKg > 0 ||
                  userDetails.heightCm > 0 ||
                  userDetails.dailyMealsPreference > 0 ||
                  (userDetails.allergies?.isNotEmpty ?? false) ||
                  (userDetails.dietaryRestrictions?.isNotEmpty ?? false) ||
                  (userDetails.openTextPreferences?.isNotEmpty ?? false));

          // Initialize overrides when data is available
          if (!_showPreferenceOverrides) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _initializeOverrides(userDetails);
            });
          }

          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header section
                          _buildHeaderSection(colorScheme, theme),
                          const SizedBox(height: 32),

                          // User Details Status Section
                          if (!hasUserDetails) ...[
                            _buildNoUserDetailsCard(colorScheme, theme),
                            const SizedBox(height: 24),
                          ] else ...[
                            _buildUserDetailsCard(
                                userDetails, colorScheme, theme),
                            const SizedBox(height: 24),
                          ],

                          // Preference Override Section
                          _buildPreferenceOverrideSection(
                              userDetails, colorScheme, theme),
                          const SizedBox(height: 120), // Space for FAB
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: _buildGenerateButton(colorScheme, theme),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildErrorState(
      String error, ColorScheme colorScheme, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Unable to load your preferences',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => ref.refresh(userDetailsProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.1),
            colorScheme.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.restaurant_menu_rounded,
              size: 32,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Personalized Meal Plan',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll create a customized weekly meal plan based on your preferences, dietary needs, and lifestyle.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoUserDetailsCard(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.info_outline_rounded,
                size: 32,
                color: Colors.orange.shade700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Profile Details Found',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'For the most personalized meal plan, please set up your profile with your weight, height, dietary preferences, and allergies.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.orange.shade700,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.tonalIcon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const SettingsScreenRiverpod(showBackButton: true),
                  ),
                );
              },
              icon: const Icon(Icons.settings_rounded),
              label: const Text('Complete Profile'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.orange.shade600,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Or continue with default preferences below',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetailsCard(
      dynamic userDetails, ColorScheme colorScheme, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Profile Details Found',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildUserDetailsSummary(userDetails, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetailsSummary(dynamic userDetails, ThemeData theme) {
    final details = <String>[];

    if (userDetails.weightKg != null) {
      details.add('${userDetails.weightKg}kg');
    }
    if (userDetails.heightCm != null) {
      details.add('${userDetails.heightCm}cm');
    }
    if (userDetails.dailyMealsPreference != null) {
      details.add('${userDetails.dailyMealsPreference} meals/day');
    }
    if (userDetails.exerciseFrequency != null) {
      final freq = userDetails.exerciseFrequency!;
      details.add(_getExerciseFrequencyDisplayText(freq));
    }
    if (userDetails.allergies != null && userDetails.allergies.isNotEmpty) {
      details.add('${userDetails.allergies.length} allergies');
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: details
          .map((detail) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Text(
                  detail,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildPreferenceOverrideSection(
      dynamic userDetails, ColorScheme colorScheme, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tune_rounded,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Custom Preferences',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Switch.adaptive(
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
                  activeColor: colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _useOverrides
                    ? Colors.orange.shade50
                    : Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _useOverrides
                      ? Colors.orange.shade200
                      : Colors.green.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _useOverrides ? Icons.edit_rounded : Icons.person_rounded,
                    size: 16,
                    color: _useOverrides
                        ? Colors.orange.shade700
                        : Colors.green.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _useOverrides
                          ? 'Using custom preferences for this meal plan'
                          : 'Using your profile preferences',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _useOverrides
                            ? Colors.orange.shade700
                            : Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_useOverrides) ...[
              const SizedBox(height: 20),
              _buildOverrideForm(colorScheme, theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOverrideForm(ColorScheme colorScheme, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Physical Details Section
        _buildSectionHeader('Physical Details', Icons.monitor_weight_rounded,
            colorScheme, theme),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _weightController,
                label: 'Weight',
                suffix: 'kg',
                keyboardType: TextInputType.number,
                colorScheme: colorScheme,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _heightController,
                label: 'Height',
                suffix: 'cm',
                keyboardType: TextInputType.number,
                colorScheme: colorScheme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Meal Preferences Section
        _buildSectionHeader(
            'Meal Preferences', Icons.restaurant_rounded, colorScheme, theme),
        const SizedBox(height: 12),
        _buildDropdownField<int>(
          value: _dailyMealsPreference,
          label: 'Daily Meals',
          items: [
            for (int i = 1; i <= 6; i++)
              DropdownMenuItem(value: i, child: Text('$i meals'))
          ],
          onChanged: (value) => setState(() => _dailyMealsPreference = value),
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 16),
        _buildDropdownField<ExerciseFrequency>(
          value: _exerciseFrequency,
          label: 'Exercise Frequency',
          items: ExerciseFrequency.values
              .map((freq) => DropdownMenuItem(
                    value: freq,
                    child: Text(_getExerciseFrequencyDisplayText(freq)),
                  ))
              .toList(),
          onChanged: (value) => setState(() => _exerciseFrequency = value),
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 24),

        // Dietary Information Section
        _buildSectionHeader('Dietary Information', Icons.local_dining_rounded,
            colorScheme, theme),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _dietaryRestrictionsController,
          label: 'Dietary Restrictions',
          hint: 'e.g., vegetarian, low-sodium, etc.',
          maxLines: 2,
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _openTextPreferencesController,
          label: 'Additional Preferences',
          hint: 'Any other food preferences or requirements',
          maxLines: 2,
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 24),

        // Allergies Section
        _buildSectionHeader(
            'Allergies', Icons.warning_rounded, colorScheme, theme),
        const SizedBox(height: 12),
        _buildAllergiesSelection(colorScheme, theme),
      ],
    );
  }

  Widget _buildSectionHeader(
      String title, IconData icon, ColorScheme colorScheme, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, color: colorScheme.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? suffix,
    TextInputType? keyboardType,
    int maxLines = 1,
    required ColorScheme colorScheme,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required T? value,
    required String label,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required ColorScheme colorScheme,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  Widget _buildAllergiesSelection(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select any allergies you have:',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AllergenEnum.values.map((allergen) {
              final isSelected = _selectedAllergies.contains(allergen);
              final allergenName = allergen.name
                  .replaceAll('_', ' ')
                  .toLowerCase()
                  .split(' ')
                  .map((word) => word.isEmpty
                      ? ''
                      : '${word[0].toUpperCase()}${word.substring(1)}')
                  .join(' ');

              return FilterChip(
                label: Text(
                  allergenName,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
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
                backgroundColor: colorScheme.surface,
                selectedColor: colorScheme.primary.withOpacity(0.2),
                checkmarkColor: colorScheme.primary,
                side: BorderSide(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.outline.withOpacity(0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton(ColorScheme colorScheme, ThemeData theme) {
    final isCustom = _useOverrides;
    final buttonColor = isCustom ? Colors.orange.shade600 : colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FilledButton.icon(
        onPressed: _isGenerating ? null : _generateMealPlan,
        icon: _isGenerating
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Icon(
                isCustom ? Icons.tune_rounded : Icons.auto_awesome_rounded,
                size: 20,
                color: Colors.white,
              ),
        label: Text(
          _isGenerating
              ? 'Creating Meal Plan...'
              : isCustom
                  ? 'Generate with Custom Preferences'
                  : 'Generate Personalized Plan',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor:
              _isGenerating ? buttonColor.withOpacity(0.7) : buttonColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: _isGenerating ? 0 : 4,
        ),
      ),
    );
  }
}
