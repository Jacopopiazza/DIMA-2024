import 'package:flutter/material.dart';

class EditPlanNameDialog extends StatefulWidget {
  final String currentPlanName;
  final Function(String) onSave;

  const EditPlanNameDialog({
    super.key,
    required this.currentPlanName,
    required this.onSave,
  });

  @override
  State<EditPlanNameDialog> createState() => _EditPlanNameDialogState();
}

class _EditPlanNameDialogState extends State<EditPlanNameDialog> {
  late TextEditingController _controller;

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Plan Name'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Enter new plan name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onSave(_controller.text);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
