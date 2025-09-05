import 'package:flutter/material.dart';

class ActionConfirmationDialog extends StatefulWidget {
  final String title;
  final String content;
  final String actionLabel;
  final Color? actionColor;
  final Color? textColor;
  final Color? actionTextColor;
  final IconData? actionIcon;
  final Future<void> Function() onConfirm;

  const ActionConfirmationDialog(
      {super.key,
      required this.title,
      required this.content,
      required this.actionLabel,
      required this.onConfirm,
      this.actionColor,
      this.actionIcon,
      this.textColor,
      this.actionTextColor});

  @override
  State<ActionConfirmationDialog> createState() =>
      _ActionConfirmationDialogState();
}

class _ActionConfirmationDialogState extends State<ActionConfirmationDialog> {
  bool _isLoading = false;

  Future<void> _handleAction() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onConfirm();
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Action failed: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(widget.title),
      content: Text(widget.content),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text('Cancel',
              style:
                  TextStyle(color: widget.textColor ?? colorScheme.onSurface)),
        ),
        FilledButton.icon(
          onPressed: _isLoading ? null : _handleAction,
          style: FilledButton.styleFrom(
            backgroundColor: widget.actionColor,
            foregroundColor: Colors.white,
          ),
          icon: _isLoading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(colorScheme.onSurface),
                  ),
                )
              : Icon(widget.actionIcon ?? Icons.check,
                  color: widget.actionTextColor ?? colorScheme.onPrimary),
          label: Text(widget.actionLabel,
              style: TextStyle(
                  color: _isLoading
                      ? colorScheme.onSurface
                      : widget.actionTextColor ?? colorScheme.onPrimary)),
        ),
      ],
    );
  }
}
