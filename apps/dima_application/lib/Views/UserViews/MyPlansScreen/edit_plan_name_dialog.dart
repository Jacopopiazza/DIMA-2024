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
  _EditPlanNameDialogState createState() => _EditPlanNameDialogState();
}

class _EditPlanNameDialogState extends State<EditPlanNameDialog> {
  late TextEditingController _textController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.currentPlanName);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(_textController.text);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Plan Name'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _textController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Plan Name',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a plan name';
            }
            return null;
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
