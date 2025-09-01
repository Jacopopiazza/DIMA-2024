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
    extends ConsumerState<UserProfileSectionRiverpod>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _givenNameController = TextEditingController();
  final _familyNameController = TextEditingController();
  String? _selectedGender;
  DateTime? _selectedDate;
  bool _isLoading = false;
  bool _isInitialized = false;
  bool _isDirty = false;

  late AnimationController _saveButtonController;
  late Animation<double> _saveButtonScale;

  @override
  void initState() {
    super.initState();
    _saveButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _saveButtonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _saveButtonController, curve: Curves.easeInOut),
    );
    
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
    _saveButtonController.dispose();
    _givenNameController.dispose();
    _familyNameController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (!_isDirty) {
      setState(() {
        _isDirty = true;
      });
    }
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
          _isDirty = false;
        });
        safePrint('[UserProfileSection] Loaded attributes: $attributes');
      }
    } catch (e) {
      safePrint('[UserProfileSection] Error loading attributes: $e');
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        if (context.mounted) {
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
                  const Text('Error loading profile data'),
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
  }

  /// Handle save button press
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate() || _isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _saveButtonController.forward().then((_) {
      _saveButtonController.reverse();
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
        if (context.mounted) {
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
                    child: const Icon(Icons.info_outline_rounded, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 12),
                  const Text('No changes to save'),
                ],
              ),
              backgroundColor: Colors.orange.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
        return;
      }

      // Force fresh execution by invalidating the provider cache
      ref.invalidate(updateUserProfileAttributesProvider);
      final success = await ref
          .read(updateUserProfileAttributesProvider(attributes).future);

      if (mounted) {
        if (success) {
          setState(() {
            _isDirty = false;
          });
          if (context.mounted) {
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
                    const Text('Profile updated successfully!'),
                  ],
                ),
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
          // Refresh the attributes
          await _loadUserProfileAttributes();
        } else {
          if (context.mounted) {
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
                    const Text('Failed to update profile. Please try again.'),
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
    } catch (e) {
      if (mounted && context.mounted) {
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
                Text('Error updating profile: $e'),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        _onFieldChanged();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Show loading state while initializing
    if (!_isInitialized) {
      return Container(
        height: 200,
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
        child: Center(
          child: CircularProgressIndicator(
            color: colorScheme.primary,
            strokeWidth: 3,
          ),
        ),
      );
    }

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
                    'User Profile',
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
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _loadUserProfileAttributes,
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  tooltip: 'Refresh Profile',
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.surface,
                    foregroundColor: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Given Name & Family Name Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          key: const ValueKey('given_name_field'),
                          controller: _givenNameController,
                          label: 'Given Name',
                          icon: Icons.person_outline_rounded,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Given Name is required';
                            }
                            return null;
                          },
                          colorScheme: colorScheme,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          key: const ValueKey('family_name_field'),
                          controller: _familyNameController,
                          label: 'Family Name',
                          icon: Icons.person_outline_rounded,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Family Name is required';
                            }
                            return null;
                          },
                          colorScheme: colorScheme,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Gender
                  _buildDropdownField<String>(
                    value: _selectedGender,
                    label: 'Gender',
                    icon: Icons.wc_rounded,
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('Male')),
                      DropdownMenuItem(value: 'female', child: Text('Female')),
                      DropdownMenuItem(value: 'other', child: Text('Other')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                        _onFieldChanged();
                      });
                    },
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 16),

                  // Birthdate
                  InkWell(
                    onTap: _selectDate,
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Birthdate',
                        prefixIcon: const Icon(Icons.cake_rounded, size: 20),
                        suffixIcon: const Icon(Icons.calendar_today_rounded, size: 20),
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
                      child: Text(
                        _selectedDate != null
                            ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
                            : 'Select date',
                        style: TextStyle(
                          color: _selectedDate != null
                              ? colorScheme.onSurface
                              : colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Save button
                  Center(
                    child: ScaleTransition(
                      scale: _saveButtonScale,
                      child: FilledButton.icon(
                        onPressed: (_isDirty && !_isLoading) ? _saveProfile : null,
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
                            color: _isDirty ? colorScheme.onPrimary : colorScheme.onSurface,
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
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    Key? key,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ColorScheme colorScheme,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      key: key,
      controller: controller,
      onChanged: (_) => _onFieldChanged(),
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
        contentPadding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 12),
      ),
      validator: validator,
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
}