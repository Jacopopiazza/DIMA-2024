import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';

import '../../../../Utils/localization_helpers.dart';
import '../../../../generated/flutter-models/AllergenEnum.dart';
import '../../../../generated/flutter-models/ExerciseFrequency.dart';
import '../../../../generated/flutter-models/UserDetails.dart';

class UserDetailsFormRiverpod extends ConsumerStatefulWidget {
  final UserDetails? userDetails;
  final Future<bool> Function(UserDetails) onUpdate;

  const UserDetailsFormRiverpod({
    Key? key,
    this.userDetails,
    required this.onUpdate,
  }) : super(key: key);

  @override
  ConsumerState<UserDetailsFormRiverpod> createState() =>
      _UserDetailsFormRiverpodState();
}

class _UserDetailsFormRiverpodState
    extends ConsumerState<UserDetailsFormRiverpod>
    with SingleTickerProviderStateMixin {
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _preferencesController;
  late TextEditingController _dietaryRestrictionsController;
  late int _dailyMealsPreference;
  late ExerciseFrequency _exerciseFrequency;
  late List<AllergenEnum> _selectedAllergies;
  bool _isDirty = false;
  bool _isLoading = false;

  late AnimationController _saveButtonController;
  late Animation<double> _saveButtonScale;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _saveButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _saveButtonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _saveButtonController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(UserDetailsFormRiverpod oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userDetails != widget.userDetails) {
      _initializeControllers();
      setState(() {
        _isDirty = false;
      });
    }
  }

  void _initializeControllers() {
    _weightController =
        TextEditingController(text: widget.userDetails?.weightKg.toString());
    _heightController =
        TextEditingController(text: widget.userDetails?.heightCm.toString());
    _preferencesController = TextEditingController(
        text: widget.userDetails?.openTextPreferences ?? '');
    _dietaryRestrictionsController = TextEditingController(
        text: widget.userDetails?.dietaryRestrictions ?? '');
    _dailyMealsPreference = widget.userDetails?.dailyMealsPreference ?? 3;
    _exerciseFrequency = widget.userDetails?.exerciseFrequency ??
        ExerciseFrequency.NOT_SPECIFIED;
    _selectedAllergies = widget.userDetails?.allergies?.toList() ?? [];
  }

  @override
  void dispose() {
    _saveButtonController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _preferencesController.dispose();
    _dietaryRestrictionsController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (!_isDirty) {
      setState(() {
        _isDirty = true;
      });
    }
  }

  // Inline validation helpers for weight and height
  bool? _isWeightValid() {
    if (_weightController.text.isEmpty) return null;
    final v = double.tryParse(_weightController.text);
    if (v == null) return false;
    return v >= 30 && v <= 300;
  }

  bool? _isHeightValid() {
    if (_heightController.text.isEmpty) return null;
    final v = double.tryParse(_heightController.text);
    if (v == null) return false;
    return v >= 50 && v <= 250;
  }

  Future<void> _saveChanges() async {
    if (_isLoading) return;

    // Validate required fields
    if (_weightController.text.isEmpty) {
      _showErrorSnackBar(AppLocalizations.of(context)!.weightIsRequired);
      return;
    }

    if (_heightController.text.isEmpty) {
      _showErrorSnackBar(AppLocalizations.of(context)!.heightIsRequired);
      return;
    }

    // Validate weight range
    final weightValid = _isWeightValid();
    if (weightValid == false) {
      _showErrorSnackBar(AppLocalizations.of(context)!.weightMustBeBetween);
      return;
    }

    // Validate height range
    final heightValid = _isHeightValid();
    if (heightValid == false) {
      _showErrorSnackBar(AppLocalizations.of(context)!.heightMustBeBetween);
      return;
    }

    double? weightKg;
    double? heightCm;

    try {
      weightKg = double.parse(_weightController.text);
    } catch (e) {
      _showErrorSnackBar(AppLocalizations.of(context)!.pleaseEnterValidWeight);
      return;
    }

    try {
      heightCm = double.parse(_heightController.text);
    } catch (e) {
      _showErrorSnackBar(AppLocalizations.of(context)!.pleaseEnterValidHeight);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _saveButtonController.forward().then((_) {
      _saveButtonController.reverse();
    });

    final updatedDetails = UserDetails(
      userId: widget.userDetails?.userId ?? '',
      weightKg: weightKg,
      heightCm: heightCm,
      openTextPreferences: _preferencesController.text,
      dietaryRestrictions: _dietaryRestrictionsController.text,
      activeMealPlanId: widget.userDetails?.activeMealPlanId,
      allergies: _selectedAllergies,
      dailyMealsPreference: _dailyMealsPreference,
      exerciseFrequency: _exerciseFrequency,
    );

    final success = await widget.onUpdate(updatedDetails);

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      if (success) {
        setState(() {
          _isDirty = false;
        });
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
                  child: const Icon(Icons.check_rounded,
                      color: Colors.white, size: 16),
                ),
                const SizedBox(width: 12),
                Text(AppLocalizations.of(context)!
                    .profileUpdatedSuccessfullyShort),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      } else {
        _showErrorSnackBar(
            AppLocalizations.of(context)!.failedToUpdateProfileShort);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
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
                child: const Icon(Icons.error_outline_rounded,
                    color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  String _getExerciseDisplayText(ExerciseFrequency frequency) {
    switch (frequency) {
      case ExerciseFrequency.NOT_SPECIFIED:
        return AppLocalizations.of(context)!.notSpecified;
      case ExerciseFrequency.NONE:
        return AppLocalizations.of(context)!.noExercise;
      case ExerciseFrequency.ONCE_A_WEEK:
        return AppLocalizations.of(context)!.onceAWeek;
      case ExerciseFrequency.TWICE_A_WEEK:
        return AppLocalizations.of(context)!.twiceAWeek;
      case ExerciseFrequency.THREE_TIMES_A_WEEK:
        return AppLocalizations.of(context)!.threeTimes;
      case ExerciseFrequency.FOUR_TIMES_A_WEEK:
        return AppLocalizations.of(context)!.fourTimes;
      case ExerciseFrequency.FIVE_TIMES_A_WEEK:
        return AppLocalizations.of(context)!.fiveTimes;
      case ExerciseFrequency.SIX_TIMES_A_WEEK:
        return AppLocalizations.of(context)!.sixTimes;
      case ExerciseFrequency.EVERY_DAY:
        return AppLocalizations.of(context)!.everyDay;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    color: colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.generationPreferences,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                if (_isDirty && !_isLoading)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.unsaved,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Physical Details Section
            _buildSectionHeader(AppLocalizations.of(context)!.physicalDetails,
                Icons.monitor_weight_rounded, colorScheme, theme),
            const SizedBox(height: 12),
            // Weight
            _buildTextField(
              controller: _weightController,
              label: AppLocalizations.of(context)!.weight,
              suffix: 'kg',
              icon: Icons.monitor_weight_outlined,
              keyboardType: TextInputType.number,
              colorScheme: colorScheme,
              helperText: AppLocalizations.of(context)!.weightAllowed,
              errorText: _isWeightValid() == false
                  ? AppLocalizations.of(context)!.weightMustBeBetween
                  : null,
              suffixIcon: _isWeightValid() == null
                  ? null
                  : Icon(
                      _isWeightValid() == true
                          ? Icons.check_circle_rounded
                          : Icons.error_outline_rounded,
                      color:
                          _isWeightValid() == true ? Colors.green : Colors.red,
                      size: 20,
                    ),
            ),
            const SizedBox(height: 16),

            // Height
            _buildTextField(
              controller: _heightController,
              label: AppLocalizations.of(context)!.height,
              suffix: 'cm',
              icon: Icons.height_rounded,
              keyboardType: TextInputType.number,
              colorScheme: colorScheme,
              helperText: AppLocalizations.of(context)!.heightAllowed,
              errorText: _isHeightValid() == false
                  ? AppLocalizations.of(context)!.heightMustBeBetween
                  : null,
              suffixIcon: _isHeightValid() == null
                  ? null
                  : Icon(
                      _isHeightValid() == true
                          ? Icons.check_circle_rounded
                          : Icons.error_outline_rounded,
                      color:
                          _isHeightValid() == true ? Colors.green : Colors.red,
                      size: 20,
                    ),
            ),
            const SizedBox(height: 24),

            // Meal Preferences Section
            _buildSectionHeader(AppLocalizations.of(context)!.mealPreferences,
                Icons.restaurant_rounded, colorScheme, theme),
            const SizedBox(height: 12),
            _buildDropdownField<int>(
              value: _dailyMealsPreference,
              label: AppLocalizations.of(context)!.dailyMeals,
              icon: Icons.restaurant_menu_rounded,
              items: [2, 3, 4, 5, 6].map((meals) {
                return DropdownMenuItem(
                  value: meals,
                  child: Text(AppLocalizations.of(context)!.mealsPerDay(meals)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _dailyMealsPreference = value;
                    _onFieldChanged();
                  });
                }
              },
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 16),
            _buildDropdownField<ExerciseFrequency>(
              value: _exerciseFrequency,
              label: AppLocalizations.of(context)!.exerciseFrequency,
              icon: Icons.fitness_center_rounded,
              items: ExerciseFrequency.values.map((frequency) {
                return DropdownMenuItem(
                  value: frequency,
                  child: Text(_getExerciseDisplayText(frequency)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _exerciseFrequency = value ?? ExerciseFrequency.NOT_SPECIFIED;
                  _onFieldChanged();
                });
              },
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 24),

            // Allergies Section
            _buildSectionHeader(AppLocalizations.of(context)!.allergies,
                Icons.warning_rounded, colorScheme, theme),
            const SizedBox(height: 12),
            _buildAllergiesSelection(colorScheme, theme),
            const SizedBox(height: 24),

            // Additional Preferences Section
            _buildSectionHeader(
                AppLocalizations.of(context)!.additionalPreferences,
                Icons.note_alt_rounded,
                colorScheme,
                theme),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _dietaryRestrictionsController,
              label: AppLocalizations.of(context)!.dietaryRestrictions,
              hint: AppLocalizations.of(context)!.anySpecificDietaryRestriction,
              icon: Icons.edit_note_rounded,
              maxLines: 3,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _preferencesController,
              label: AppLocalizations.of(context)!.dietaryPreferences,
              hint: AppLocalizations.of(context)!.anySpecificDietaryPreference,
              icon: Icons.edit_note_rounded,
              maxLines: 3,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 32),

            // Save Button
            Center(
              child: ScaleTransition(
                scale: _saveButtonScale,
                child: FilledButton.icon(
                  onPressed: (_isDirty && !_isLoading) ? _saveChanges : null,
                  icon: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                colorScheme.onPrimary),
                          ),
                        )
                      : const Icon(Icons.save_rounded, size: 20),
                  label: Text(
                    _isLoading
                        ? AppLocalizations.of(context)!.saving
                        : AppLocalizations.of(context)!.saveChanges,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _isDirty
                          ? colorScheme.onSecondary
                          : colorScheme.onSurface,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: _isDirty && !_isLoading
                        ? colorScheme.primary
                        : colorScheme.primary.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    required ColorScheme colorScheme,
    String? helperText,
    String? errorText,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: (_) => _onFieldChanged(),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
        prefixIcon: Icon(icon, size: 20),
        suffixIcon: suffixIcon,
        helperText: errorText == null ? helperText : null,
        errorText: errorText,
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
            const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 12),
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required T? value,
    required String label,
    required IconData icon,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required ColorScheme colorScheme,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
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
            AppLocalizations.of(context)!.selectAllergies,
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
              final allergenName = localizeAllergen(context, allergen);

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
                    _onFieldChanged();
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
}
