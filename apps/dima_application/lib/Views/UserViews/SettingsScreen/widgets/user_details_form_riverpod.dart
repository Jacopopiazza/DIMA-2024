import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dima_application/generated/flutter-models/UserDetails.dart';
import 'package:dima_application/generated/flutter-models/ExerciseFrequency.dart';
import 'package:dima_application/providers/user_details_provider.dart';
import 'package:dima_application/generated/flutter-models/AllergenEnum.dart';
 

class UserDetailsFormRiverpod extends ConsumerStatefulWidget {
  final UserDetails userDetails;

  const UserDetailsFormRiverpod({
    Key? key,
    required this.userDetails,
  }) : super(key: key);

  @override
  ConsumerState<UserDetailsFormRiverpod> createState() => _UserDetailsFormRiverpodState();
}

class _UserDetailsFormRiverpodState extends ConsumerState<UserDetailsFormRiverpod> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _targetCaloriesController;
  late TextEditingController _preferencesController;
  late int _dailyMealsPreference;
  late ExerciseFrequency? _exerciseFrequency;
  late List<AllergenEnum> _allergies;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _heightController = TextEditingController(
      text: widget.userDetails.heightCm?.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: widget.userDetails.weightKg?.toString() ?? '',
    );
    _targetCaloriesController = TextEditingController(
      text: widget.userDetails.targetCalories?.toString() ?? '',
    );
    _preferencesController = TextEditingController(
      text: widget.userDetails.openTextPreferences ?? '',
    );
    _dailyMealsPreference = widget.userDetails.dailyMealsPreference ?? 3;
    _exerciseFrequency = widget.userDetails.exerciseFrequency;
    _allergies = List.from(widget.userDetails.allergies ?? []);
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _targetCaloriesController.dispose();
    _preferencesController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedDetails = widget.userDetails.copyWith(
        heightCm: double.tryParse(_heightController.text),
        weightKg: double.tryParse(_weightController.text),
        targetCalories: double.tryParse(_targetCaloriesController.text),
        openTextPreferences: _preferencesController.text,
        dailyMealsPreference: _dailyMealsPreference,
        exerciseFrequency: _exerciseFrequency,
        allergies: _allergies,
      );

      await ref.read(userDetailsProvider.notifier).updateUserDetails(updatedDetails);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User details updated successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personal Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final height = double.tryParse(value);
                    if (height == null || height <= 0) {
                      return 'Please enter a valid height';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final weight = double.tryParse(value);
                    if (weight == null || weight <= 0) {
                      return 'Please enter a valid weight';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _targetCaloriesController,
                decoration: const InputDecoration(
                  labelText: 'Target Daily Calories',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final calories = double.tryParse(value);
                    if (calories == null || calories <= 0) {
                      return 'Please enter a valid calorie target';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _dailyMealsPreference,
                decoration: const InputDecoration(
                  labelText: 'Daily Meals',
                  border: OutlineInputBorder(),
                ),
                items: [2, 3, 4, 5, 6].map((meals) {
                  return DropdownMenuItem(
                    value: meals,
                    child: Text('$meals meals per day'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _dailyMealsPreference = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ExerciseFrequency>(
                value: _exerciseFrequency,
                decoration: const InputDecoration(
                  labelText: 'Exercise Frequency',
                  border: OutlineInputBorder(),
                ),
                items: ExerciseFrequency.values.map((frequency) {
                  return DropdownMenuItem(
                    value: frequency,
                    child: Text(frequency.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _exerciseFrequency = value);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _preferencesController,
                decoration: const InputDecoration(
                  labelText: 'Additional Preferences',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  child: const Text('Update Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 