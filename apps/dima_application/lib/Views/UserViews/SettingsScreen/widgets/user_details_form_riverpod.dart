import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    _weightController = TextEditingController(
        text: widget.userDetails?.weightKg.toString());
    _heightController = TextEditingController(
        text: widget.userDetails?.heightCm.toString());
    _preferencesController = TextEditingController(
        text: widget.userDetails?.openTextPreferences ?? '');
    _dietaryRestrictionsController = TextEditingController(
        text: widget.userDetails?.dietaryRestrictions ?? '');
    _dailyMealsPreference = widget.userDetails?.dailyMealsPreference ?? 3;
    _exerciseFrequency = widget.userDetails?.exerciseFrequency ?? ExerciseFrequency.NOT_SPECIFIED;
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

  Future<void> _saveChanges() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    _saveButtonController.forward().then((_) {
      _saveButtonController.reverse();
    });

    final updatedDetails = UserDetails(
      userId: widget.userDetails!.userId,
      weightKg: double.parse(_weightController.text),
      heightCm: double.parse(_heightController.text),
      openTextPreferences: _preferencesController.text,
      dietaryRestrictions: _dietaryRestrictionsController.text,
      activeMealPlanId: widget.userDetails!.activeMealPlanId,
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
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 12),
                const Text('Profile updated successfully'),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
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
                  child: const Icon(Icons.error_outline_rounded, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 12),
                const Text('Failed to update profile'),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  String _getExerciseDisplayText(ExerciseFrequency frequency) {
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
                    'Generation Preferences',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                if (_isDirty && !_isLoading)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: Text(
                      'Unsaved',
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
            _buildSectionHeader('Physical Details', Icons.monitor_weight_rounded, colorScheme, theme),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _weightController,
                    label: 'Weight',
                    suffix: 'kg',
                    icon: Icons.monitor_weight_outlined,
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
                    icon: Icons.height_rounded,
                    keyboardType: TextInputType.number,
                    colorScheme: colorScheme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Meal Preferences Section
            _buildSectionHeader('Meal Preferences', Icons.restaurant_rounded, colorScheme, theme),
            const SizedBox(height: 12),
            _buildDropdownField<int>(
              value: _dailyMealsPreference,
              label: 'Daily Meals',
              icon: Icons.restaurant_menu_rounded,
              items: [2, 3, 4, 5, 6].map((meals) {
                return DropdownMenuItem(
                  value: meals,
                  child: Text('$meals meals per day'),
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
              label: 'Exercise Frequency',
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
            _buildSectionHeader('Allergies', Icons.warning_rounded, colorScheme, theme),
            const SizedBox(height: 12),
            _buildAllergiesSelection(colorScheme, theme),
            const SizedBox(height: 24),

            // Additional Preferences Section
            _buildSectionHeader('Additional Preferences', Icons.note_alt_rounded, colorScheme, theme),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _dietaryRestrictionsController,
              label: 'Dietary restrictions',
              hint: 'Any specific dietary restriction',
              icon: Icons.edit_note_rounded,
              maxLines: 3,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _preferencesController,
              label: 'Dietary preferences',
              hint: 'Any specific dietary preference or notes',
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
                            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
                          ),
                        )
                      : const Icon(Icons.save_rounded, size: 20),
                  label: Text(
                    _isLoading ? 'Saving...' : 'Save Changes',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _isDirty ? colorScheme.onSecondary : colorScheme.onSurface,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: _isDirty && !_isLoading 
                        ? colorScheme.primary 
                        : colorScheme.primary.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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

  Widget _buildSectionHeader(String title, IconData icon, ColorScheme colorScheme, ThemeData theme) {
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
        contentPadding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 12),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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