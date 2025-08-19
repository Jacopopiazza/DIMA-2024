import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../generated/flutter-models/UserDetails.dart';
import '../../../../generated/flutter-models/ExerciseFrequency.dart';
import '../../../../generated/flutter-models/AllergenEnum.dart';
import '../../../../Utils/localization_helpers.dart';

class UserDetailsFormRiverpod extends ConsumerStatefulWidget {
  final UserDetails userDetails;
  final Future<bool> Function(UserDetails) onUpdate;

  const UserDetailsFormRiverpod({
    Key? key,
    required this.userDetails,
    required this.onUpdate,
  }) : super(key: key);

  @override
  ConsumerState<UserDetailsFormRiverpod> createState() => _UserDetailsFormRiverpodState();
}

class _UserDetailsFormRiverpodState extends ConsumerState<UserDetailsFormRiverpod> {
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _targetCaloriesController;
  late TextEditingController _preferencesController;
  late int _dailyMealsPreference;
  late ExerciseFrequency? _exerciseFrequency;
  late List<AllergenEnum> _selectedAllergies;
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(UserDetailsFormRiverpod oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the userDetails prop changes (e.g., from a refresh), reset the form
    if (oldWidget.userDetails != widget.userDetails) {
      _initializeControllers();
      setState(() {
        _isDirty = false;
      });
    }
  }

  void _initializeControllers() {
    _weightController = TextEditingController(text: widget.userDetails.weightKg?.toString() ?? '');
    _heightController = TextEditingController(text: widget.userDetails.heightCm?.toString() ?? '');
    _preferencesController = TextEditingController(text: widget.userDetails.openTextPreferences ?? '');
    _dailyMealsPreference = widget.userDetails.dailyMealsPreference ?? 3;
    _exerciseFrequency = widget.userDetails.exerciseFrequency;
    _selectedAllergies = widget.userDetails.allergies?.toList() ?? [];
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _targetCaloriesController.dispose();
    _preferencesController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (!_isDirty) {
      setState(() {
        _isDirty = true;
      });
    }
  }

  void _onDropdownChanged() {
    if (!_isDirty) {
      setState(() {
        _isDirty = true;
      });
    }
  }

  void _onAllergiesChanged(List<AllergenEnum> allergies) {
    setState(() {
      _selectedAllergies = allergies;
      if (!_isDirty) {
        _isDirty = true;
      }
    });
  }

  Future<void> _saveChanges() async {
    final updatedDetails = UserDetails(
      userId: widget.userDetails.userId,
      weightKg: double.tryParse(_weightController.text),
      heightCm: double.tryParse(_heightController.text),
      openTextPreferences: _preferencesController.text,
      activeMealPlanId: widget.userDetails.activeMealPlanId,
      allergies: _selectedAllergies,
      dailyMealsPreference: _dailyMealsPreference,
      exerciseFrequency: _exerciseFrequency,
    );

    // The onUpdate function now returns a boolean indicating success.
    final success = await widget.onUpdate(updatedDetails);
    
    if (mounted) {
      if (success) {
        setState(() {
          _isDirty = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User details updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error updating user details. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark 
          ? theme.colorScheme.secondary.withOpacity(0.1)
          : theme.colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(isDark ? 0.3 : 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person_outline, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Personal Details',
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.monitor_weight_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _onFieldChanged(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _heightController,
                    decoration: const InputDecoration(
                      labelText: 'Height (cm)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.height),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _onFieldChanged(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _targetCaloriesController,
              decoration: const InputDecoration(
                labelText: 'Target Daily Calories',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.local_fire_department),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _onFieldChanged(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _dailyMealsPreference,
              decoration: const InputDecoration(
                labelText: 'Daily Meals',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.restaurant),
              ),
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
                    _onDropdownChanged();
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ExerciseFrequency>(
              value: _exerciseFrequency,
              decoration: const InputDecoration(
                labelText: 'Exercise Frequency',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.fitness_center),
              ),
              items: ExerciseFrequency.values.map((frequency) {
                return DropdownMenuItem(
                  value: frequency,
                  child: Text(frequency.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _exerciseFrequency = value;
                  _onDropdownChanged();
                });
              },
            ),
            const SizedBox(height: 16),
            // Allergies Multi-Select
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Allergies'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AllergenEnum.values.map((allergen) {
                    final isSelected = _selectedAllergies.contains(allergen);
                    return FilterChip(
                      label: Text(localizeAllergen(context, allergen)),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedAllergies.add(allergen);
                          } else {
                            _selectedAllergies.remove(allergen);
                          }
                          _onAllergiesChanged(_selectedAllergies);
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _preferencesController,
              decoration: const InputDecoration(
                labelText: 'Additional Preferences',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note_alt_outlined),
              ),
              maxLines: 3,
              onChanged: (_) => _onFieldChanged(),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: _isDirty ? _saveChanges : null,
                icon: const Icon(Icons.save),
                label: const Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 