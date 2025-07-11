import 'package:dima_application/generated/flutter-models/NutritionistProfile.dart';
import 'package:flutter/material.dart';

class SelectNutritionistDialog extends StatefulWidget {
  final String mealPlanId;
  final String planName;
  final Future<List<NutritionistProfile>> Function() onLoadNutritionists;
  final Future<bool> Function(String, String) onAssignNutritionist;

  const SelectNutritionistDialog({
    super.key,
    required this.mealPlanId,
    required this.planName,
    required this.onLoadNutritionists,
    required this.onAssignNutritionist,
  });

  @override
  State<SelectNutritionistDialog> createState() =>
      _SelectNutritionistDialogState();
}

class _SelectNutritionistDialogState extends State<SelectNutritionistDialog> {
  List<NutritionistProfile> _nutritionists = [];
  bool _isLoading = true;
  bool _isAssigning = false;
  String? _selectedNutritionistId;

  @override
  void initState() {
    super.initState();
    _loadNutritionists();
  }

  Future<void> _loadNutritionists() async {
    try {
      final nutritionists = await widget.onLoadNutritionists();
      setState(() {
        _nutritionists = nutritionists;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading nutritionists: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _assignNutritionist() async {
    if (_selectedNutritionistId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a nutritionist'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isAssigning = true;
    });

    try {
      final success = await widget.onAssignNutritionist(
        widget.mealPlanId,
        _selectedNutritionistId!,
      );

      if (mounted) {
        if (success) {
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nutritionist assigned successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to assign nutritionist'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error assigning nutritionist: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAssigning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Request Nutritionist Validation'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a nutritionist to review your meal plan "${widget.planName}":',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_nutritionists.isEmpty)
              const Center(
                child: Text(
                  'No nutritionists available at the moment.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _nutritionists.length,
                  itemBuilder: (context, index) {
                    final nutritionist = _nutritionists[index];
                    final isSelected =
                        _selectedNutritionistId == nutritionist.nutritionistId;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: isSelected
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1)
                          : null,
                      child: RadioListTile<String>(
                        value: nutritionist.nutritionistId,
                        groupValue: _selectedNutritionistId,
                        onChanged: (value) {
                          setState(() {
                            _selectedNutritionistId = value;
                          });
                        },
                        title: Text(
                          '${nutritionist.givenName ?? ''} ${nutritionist.familyName ?? ''}'
                              .trim(),
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (nutritionist.specialization != null)
                              Text(
                                nutritionist.specialization!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            if (nutritionist.bio != null)
                              Text(
                                nutritionist.bio!,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            Row(
                              children: [
                                Icon(
                                  nutritionist.isAvailable == true
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  size: 16,
                                  color: nutritionist.isAvailable == true
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  nutritionist.isAvailable == true
                                      ? 'Available'
                                      : 'Unavailable',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: nutritionist.isAvailable == true
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isAssigning ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isAssigning || _selectedNutritionistId == null
              ? null
              : _assignNutritionist,
          child: _isAssigning
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Request Validation'),
        ),
      ],
    );
  }
}
