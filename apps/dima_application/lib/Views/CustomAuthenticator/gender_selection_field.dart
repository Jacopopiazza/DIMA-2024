import 'package:dima_application/Utils/gender_type_enum.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class GenderSelectionField extends StatefulWidget {
  final void Function(String?) onChanged;
  final String? initialValue;
  final bool isRequired;

  const GenderSelectionField({
    super.key,
    required this.onChanged,
    this.initialValue,
    this.isRequired = true,
  });

  @override
  State<GenderSelectionField> createState() => _GenderSelectionFieldState();
}

class _GenderSelectionFieldState extends State<GenderSelectionField> {
  String? _selectedGender;
  final _focusNode = FocusNode();
  bool _isFocused = false;
  final _formFieldKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.initialValue;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding:
          const EdgeInsets.only(bottom: 20.0, top: 8.0), // Added bottom margin
      child: DropdownButtonFormField<String>(
        key: _formFieldKey,
        focusNode: _focusNode,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.signUpDropdownText,
          prefixIcon: const Icon(Icons.wc_rounded, size: 20),
          labelStyle: TextStyle(
            color: _isFocused ? colorScheme.primary : null,
            fontWeight: FontWeight.w500,
          ),
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.error),
          ),
          filled: true,
          fillColor: colorScheme.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        value: _selectedGender,
        items: GenderTypeEnum.values
            .map((genderType) => DropdownMenuItem(
                  value: genderType.value,
                  child: Text(
                    genderType.localizedValue(context),
                    style: theme.textTheme.bodyMedium,
                  ),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedGender = value;
          });
          widget.onChanged(value);

          // Ensure dropdown closes by removing focus after selection
          _focusNode.unfocus();

          // Force UI update to ensure dropdown menu closes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {});
            }
          });
        },
        icon: Icon(Icons.arrow_drop_down, color: colorScheme.primary),
        dropdownColor: colorScheme.surface,
        style: theme.textTheme.bodyMedium,
        validator: widget.isRequired
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a gender';
                }
                return null;
              }
            : null,
        menuMaxHeight: 300,
        isDense: true,
        isExpanded: true,
        // Ensure dropdown properly closes by handling tap events
        selectedItemBuilder: (BuildContext context) {
          return GenderTypeEnum.values.map<Widget>((GenderTypeEnum item) {
            return Container(
              alignment: Alignment.centerLeft,
              child: Text(
                item.localizedValue(context),
                style: theme.textTheme.bodyMedium,
              ),
            );
          }).toList();
        },
      ),
    );
  }
}
