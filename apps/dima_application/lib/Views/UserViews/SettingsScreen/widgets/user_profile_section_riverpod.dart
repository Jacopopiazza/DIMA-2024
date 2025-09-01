import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../providers/cognito_profile_provider.dart';

class UserProfileSectionRiverpod extends ConsumerStatefulWidget {
  const UserProfileSectionRiverpod({super.key});

  @override
  ConsumerState<UserProfileSectionRiverpod> createState() =>
      _UserProfileSectionRiverpodState();
}

class _UserProfileSectionRiverpodState
    extends ConsumerState<UserProfileSectionRiverpod> {
  final _formKey = GlobalKey<FormState>();
  final _givenNameController = TextEditingController();
  final _familyNameController = TextEditingController();
  String? _selectedGender;
  DateTime? _selectedDate;
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Schedule the attributes loading for after the widget is fully initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserProfileAttributes();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure text controllers are properly initialized
    if (_givenNameController.text.isEmpty &&
        _familyNameController.text.isEmpty) {
      // Only load if controllers are empty to avoid overwriting user input
      _loadUserProfileAttributes();
    }
  }

  @override
  void dispose() {
    _givenNameController.dispose();
    _familyNameController.dispose();
    super.dispose();
  }

  /// Load current user profile attributes
  Future<void> _loadUserProfileAttributes() async {
    try {
      safePrint('[UserProfileSection] Loading user profile attributes...');

      // Force refresh by invalidating the provider cache
      ref.invalidate(userProfileAttributesProvider);

      final attributes = await ref.read(userProfileAttributesProvider.future);
      if (mounted) {
        setState(() {
          // Only set text if controllers are empty to avoid overwriting user input
          if (_givenNameController.text.isEmpty) {
            _givenNameController.text = attributes['given_name'] ?? '';
          }
          if (_familyNameController.text.isEmpty) {
            _familyNameController.text = attributes['family_name'] ?? '';
          }
          _selectedGender = attributes['gender'];
          if (attributes['birthdate'] != null &&
              attributes['birthdate']!.isNotEmpty) {
            try {
              _selectedDate =
                  DateFormat('yyyy-MM-dd').parse(attributes['birthdate']!);
            } catch (e) {
              safePrint('[UserProfileSection] Error parsing birthdate: $e');
            }
          }
          _isInitialized = true;
        });
        safePrint('[UserProfileSection] Loaded attributes: $attributes');
      }
    } catch (e) {
      safePrint('[UserProfileSection] Error loading attributes: $e');
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading profile data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Handle save button press
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final attributes = <String, String>{};
      if (_givenNameController.text.isNotEmpty) {
        attributes['given_name'] = _givenNameController.text.trim();
      }
      if (_familyNameController.text.isNotEmpty) {
        attributes['family_name'] = _familyNameController.text.trim();
      }
      if (_selectedGender != null) {
        attributes['gender'] = _selectedGender!;
      }
      if (_selectedDate != null) {
        attributes['birthdate'] =
            DateFormat('yyyy-MM-dd').format(_selectedDate!);
      }

      if (attributes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No changes to save'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Force fresh execution by invalidating the provider cache
      ref.invalidate(updateUserProfileAttributesProvider);
      final success = await ref
          .read(updateUserProfileAttributesProvider(attributes).future);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          // Refresh the attributes
          await _loadUserProfileAttributes();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update profile. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Show date picker for birthdate
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Show loading state while initializing
    if (!_isInitialized) {
      return Container(
        decoration: BoxDecoration(
          color: isDark
              ? theme.colorScheme.secondary.withValues(alpha: 0.1)
              : theme.colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                theme.colorScheme.primary.withValues(alpha: isDark ? 0.3 : 0.2),
            width: 1,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.secondary.withValues(alpha: 0.1)
            : theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              theme.colorScheme.primary.withValues(alpha: isDark ? 0.3 : 0.2),
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
                Icon(
                  Icons.person,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'User Profile',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _loadUserProfileAttributes,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh Profile',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Given Name
                  TextFormField(
                    key: const ValueKey('given_name_field'),
                    controller: _givenNameController,
                    enabled: true,
                    decoration: InputDecoration(
                      labelText: 'Given Name',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Given Name is required';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      // Handle text changes without triggering rebuilds
                    },
                  ),
                  const SizedBox(height: 16),

                  // Family Name
                  TextFormField(
                    key: const ValueKey('family_name_field'),
                    controller: _familyNameController,
                    enabled: true,
                    decoration: InputDecoration(
                      labelText: 'Family Name',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Family Name is required';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      // Handle text changes without triggering rebuilds
                    },
                  ),
                  const SizedBox(height: 16),

                  // Gender
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.wc),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: 'male',
                        child: Text('Male'),
                      ),
                      const DropdownMenuItem(
                        value: 'female',
                        child: Text('Female'),
                      ),
                      const DropdownMenuItem(
                        value: 'other',
                        child: Text('Other'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Birthdate
                  InkWell(
                    onTap: _selectDate,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Birthdate',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.cake),
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _selectedDate != null
                            ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
                            : 'Select date',
                        style: TextStyle(
                          color: _selectedDate != null
                              ? theme.textTheme.bodyLarge?.color
                              : theme.textTheme.bodyLarge?.color
                                  ?.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveProfile,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
