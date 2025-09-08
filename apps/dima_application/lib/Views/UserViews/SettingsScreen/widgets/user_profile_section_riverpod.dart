import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/Utils/gender_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';

import '../../../../providers/cognito_profile_provider.dart';

class UserProfileSectionRiverpod extends ConsumerStatefulWidget {
  final CognitoProfileData profileData;
  final String uniqueId;
  final Future<bool> Function({
    String? givenName,
    String? familyName,
    String? gender,
    String? birthdate,
  }) onUpdateProfile;

  const UserProfileSectionRiverpod({
    Key? key,
    required this.profileData,
    required this.uniqueId,
    required this.onUpdateProfile,
  }) : super(key: key);

  @override
  ConsumerState<UserProfileSectionRiverpod> createState() =>
      _UserProfileSectionRiverpodState();
}

class _UserProfileSectionRiverpodState
    extends ConsumerState<UserProfileSectionRiverpod>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _givenNameController;
  late TextEditingController _familyNameController;
  String? _selectedGender;
  DateTime? _selectedDate;
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
  void didUpdateWidget(UserProfileSectionRiverpod oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profileData != widget.profileData ||
        oldWidget.uniqueId != widget.uniqueId) {
      _initializeControllers();
      setState(() {
        _isDirty = false;
      });
    }
  }

  void _initializeControllers() {
    final attributes = widget.profileData.userAttributes;

    _givenNameController =
        TextEditingController(text: attributes['given_name'] ?? '');
    _familyNameController =
        TextEditingController(text: attributes['family_name'] ?? '');
    _selectedGender = attributes['gender'];

    if (attributes['birthdate'] != null &&
        attributes['birthdate']!.isNotEmpty) {
      try {
        _selectedDate =
            DateFormat('yyyy-MM-dd').parse(attributes['birthdate']!);
      } catch (e) {
        safePrint('[UserProfileSection] Error parsing birthdate: $e');
        _selectedDate = null;
      }
    } else {
      _selectedDate = null;
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
      final success = await widget.onUpdateProfile(
        givenName: null, // Readonly field - don't update
        familyName: null, // Readonly field - don't update
        gender: _selectedGender,
        birthdate: _selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
            : null,
      );

      if (mounted && context.mounted) {
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
                  Text(AppLocalizations.of(context)!.profileUpdatedSuccessfully),
                ],
              ),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
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
                    child: const Icon(Icons.error_outline_rounded,
                        color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Text(AppLocalizations.of(context)!.failedToUpdateProfile),
                ],
              ),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
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
                  child: const Icon(Icons.error_outline_rounded,
                      color: Colors.white, size: 16),
                ),
                const SizedBox(width: 12),
                Text('${AppLocalizations.of(context)!.errorUpdatingProfile}: $e'),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      initialEntryMode: DatePickerEntryMode.calendarOnly,
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
                    AppLocalizations.of(context)!.userProfile,
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

            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Given Name
                  _buildTextField(
                    key: const ValueKey('given_name_field'),
                    controller: _givenNameController,
                    label: AppLocalizations.of(context)!.givenName,
                    icon: Icons.person_outline_rounded,
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppLocalizations.of(context)!.givenNameRequired;
                      }
                      return null;
                    },
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 16),
                  
                  // Family Name
                  _buildTextField(
                    key: const ValueKey('family_name_field'),
                    controller: _familyNameController,
                    label: AppLocalizations.of(context)!.familyName,
                    icon: Icons.person_outline_rounded,
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppLocalizations.of(context)!.familyNameRequired;
                      }
                      return null;
                    },
                    colorScheme: colorScheme,
                  ),
                  // Helper text for readonly fields
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.nameFieldsReadOnly,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Gender
                  _buildDropdownField<String>(
                    value: _selectedGender,
                    label: AppLocalizations.of(context)!.gender,
                    icon: Icons.wc_rounded,
                    items: [
                      DropdownMenuItem(value: 'male', child: Text(AppLocalizations.of(context)!.male)),
                      DropdownMenuItem(value: 'female', child: Text(AppLocalizations.of(context)!.female)),
                      DropdownMenuItem(value: 'other', child: Text(AppLocalizations.of(context)!.other)),
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
                        labelText: AppLocalizations.of(context)!.birthdate,
                        prefixIcon: const Icon(Icons.cake_rounded, size: 20),
                        suffixIcon:
                            const Icon(Icons.calendar_today_rounded, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: colorScheme.outline.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: colorScheme.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      child: Text(
                        _selectedDate != null
                            ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                            : AppLocalizations.of(context)!.selectDate,
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
                        onPressed:
                            (_isDirty && !_isLoading) ? _saveProfile : null,
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
                          _isLoading ? AppLocalizations.of(context)!.saving : AppLocalizations.of(context)!.saveChanges,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _isDirty
                                ? colorScheme.onPrimary
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
    bool readOnly = false,
  }) {
    return TextFormField(
      key: key,
      controller: controller,
      readOnly: readOnly,
      onChanged: readOnly ? null : (_) => _onFieldChanged(),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        suffixIcon: readOnly
            ? Icon(Icons.lock_outline_rounded,
                size: 16, color: colorScheme.onSurface.withOpacity(0.5))
            : null,
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
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
        ),
        filled: true,
        fillColor: readOnly
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surface,
        contentPadding:
            const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 12),
      ),
      style: readOnly
          ? TextStyle(color: colorScheme.onSurface.withOpacity(0.7))
          : null,
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}
