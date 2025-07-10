import 'package:flutter/material.dart';

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
    if (value.trim().isEmpty) {
      return 'Plan name cannot be empty';
    }
    if (value.trim().length < 2) {
      return 'Plan name must be at least 2 characters long';
    }
    if (value.trim().length > 50) {
      return 'Plan name must be less than 50 characters';
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
            content: Text('Failed to update plan name: $e'),
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
      title: const Text('Modify Plan Name'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            enabled: !_isLoading,
            decoration: const InputDecoration(
              hintText: 'Enter new plan name',
              border: OutlineInputBorder(),
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
                _validateInput(_controller.text.trim()) ?? 'Valid name',
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
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSave,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
