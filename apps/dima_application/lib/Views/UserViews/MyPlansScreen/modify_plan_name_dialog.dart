import 'package:flutter/material.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';

class ModifyPlanNameDialog extends StatefulWidget {
  final String currentPlanName;
  final String mealPlanId;
  final Function(String, String) onSave;

  const ModifyPlanNameDialog({
    super.key,
    required this.currentPlanName,
    required this.mealPlanId,
    required this.onSave,
  });

  @override
  State<ModifyPlanNameDialog> createState() => _ModifyPlanNameDialogState();
}

class _ModifyPlanNameDialogState extends State<ModifyPlanNameDialog> {
  late TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentPlanName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validateInput(String value) {
    final localizations = AppLocalizations.of(context)!;
    if (value.trim().isEmpty) {
      return localizations.planNameCannotBeEmpty;
    }
    if (value.trim().length < 2) {
      return localizations.planNameMinLength;
    }
    if (value.trim().length > 50) {
      return localizations.planNameMaxLength;
    }
    return null;
  }

  Future<void> _handleSave() async {
    final newName = _controller.text.trim();
    final validationError = _validateInput(newName);

    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (newName == widget.currentPlanName) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onSave(widget.mealPlanId, newName);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.failedToUpdatePlanName +
                e.toString()),
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.modifyPlanName),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            enabled: !_isLoading,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.enterNewPlanName,
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              // Clear any previous validation errors
              setState(() {});
            },
          ),
          if (_controller.text.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _validateInput(_controller.text.trim()) ??
                    AppLocalizations.of(context)!.validName,
                style: TextStyle(
                  color: _validateInput(_controller.text.trim()) != null
                      ? Colors.red
                      : Colors.green,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSave,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(AppLocalizations.of(context)!.save),
        ),
      ],
    );
  }
}
