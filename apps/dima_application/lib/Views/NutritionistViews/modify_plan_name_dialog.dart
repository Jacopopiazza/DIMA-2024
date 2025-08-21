import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ModifyPlanNameDialog extends StatefulWidget {
  final MealPlan mealPlan;
  final Function(String, Map<String, dynamic>) onSave;

  const ModifyPlanNameDialog({
    super.key,
    required this.mealPlan,
    required this.onSave,
  });

  @override
  State<ModifyPlanNameDialog> createState() => _ModifyPlanNameDialogState();
}

class _ModifyPlanNameDialogState extends State<ModifyPlanNameDialog> {
  late TextEditingController _planNameController;
  late PlanStatus? _selectedStatus;
  bool _isLoading = false;
  bool _isBasicInfoExpanded = true;
  bool _isDailyPlanExpanded = false;
  bool _isMetadataExpanded = false;

  @override
  void initState() {
    super.initState();
    _planNameController =
        TextEditingController(text: widget.mealPlan.planName ?? 'Unnamed Plan');
    _selectedStatus = widget.mealPlan.status;
  }

  @override
  void dispose() {
    _planNameController.dispose();
    super.dispose();
  }

  String? _validatePlanName(String value) {
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

  bool _hasChanges() {
    return _planNameController.text.trim() !=
            (widget.mealPlan.planName ?? 'Unnamed Plan') ||
        _selectedStatus != widget.mealPlan.status;
  }

  Map<String, dynamic> _getChangedFields() {
    Map<String, dynamic> changes = {};

    final newName = _planNameController.text.trim();
    if (newName != (widget.mealPlan.planName ?? 'Unnamed Plan')) {
      changes['planName'] = newName;
    }

    if (_selectedStatus != widget.mealPlan.status) {
      changes['status'] = _selectedStatus;
    }

    return changes;
  }

  Future<void> _handleSave() async {
    final newName = _planNameController.text.trim();
    final validationError = _validatePlanName(newName);

    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_hasChanges()) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final changes = _getChangedFields();
      await widget.onSave(widget.mealPlan.mealPlanId, changes);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to modify plan: $e'),
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

  Widget _buildBasicInfoSection() {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        initiallyExpanded: _isBasicInfoExpanded,
        onExpansionChanged: (expanded) =>
            setState(() => _isBasicInfoExpanded = expanded),
        leading: const Icon(Icons.edit),
        title: const Text('Basic Information'),
        subtitle: const Text('Editable fields'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _planNameController,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Plan Name',
                    hintText: 'Enter plan name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                if (_planNameController.text.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _validatePlanName(_planNameController.text.trim()) ??
                          'Valid name',
                      style: TextStyle(
                        color: _validatePlanName(
                                    _planNameController.text.trim()) !=
                                null
                            ? Colors.red
                            : Colors.green,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                DropdownButtonFormField<PlanStatus>(
                  value: _selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Plan Status',
                    border: OutlineInputBorder(),
                  ),
                  items: PlanStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(_formatEnumValue(status.name)),
                    );
                  }).toList(),
                  onChanged: (PlanStatus? newStatus) {
                    setState(() => _selectedStatus = newStatus);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyPlanSection() {
    final dailyPlan = widget.mealPlan.dailyPlan;
    if (dailyPlan == null) {
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ExpansionTile(
          initiallyExpanded: _isDailyPlanExpanded,
          onExpansionChanged: (expanded) =>
              setState(() => _isDailyPlanExpanded = expanded),
          leading: const Icon(Icons.restaurant_menu),
          title: const Text('Daily Plan'),
          subtitle: const Text('No meal plan data available'),
          children: const [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text('No daily plan data found for this meal plan.'),
            ),
          ],
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        initiallyExpanded: _isDailyPlanExpanded,
        onExpansionChanged: (expanded) =>
            setState(() => _isDailyPlanExpanded = expanded),
        leading: const Icon(Icons.restaurant_menu),
        title: const Text('Daily Plan'),
        subtitle: const Text('7-day meal schedule (Read-only)'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDayMeals('Monday', dailyPlan.monday),
                _buildDayMeals('Tuesday', dailyPlan.tuesday),
                _buildDayMeals('Wednesday', dailyPlan.wednesday),
                _buildDayMeals('Thursday', dailyPlan.thursday),
                _buildDayMeals('Friday', dailyPlan.friday),
                _buildDayMeals('Saturday', dailyPlan.saturday),
                _buildDayMeals('Sunday', dailyPlan.sunday),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayMeals(String dayName, List<Meal>? meals) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dayName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          if (meals == null || meals.isEmpty)
            const Text('No meals planned', style: TextStyle(color: Colors.grey))
          else
            ...meals.map((meal) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                      '• ${meal.recipeName ?? 'Unnamed meal'} (${_formatEnumValue(meal.name.name)})'),
                )),
        ],
      ),
    );
  }

  Widget _buildMetadataSection() {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        initiallyExpanded: _isMetadataExpanded,
        onExpansionChanged: (expanded) =>
            setState(() => _isMetadataExpanded = expanded),
        leading: const Icon(Icons.info),
        title: const Text('Metadata'),
        subtitle: const Text('Read-only information'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow('Plan ID', widget.mealPlan.mealPlanId),
                _buildInfoRow('User ID', widget.mealPlan.userId),
                _buildInfoRow('Assigned Nutritionist',
                    widget.mealPlan.assignedNutritionistId ?? 'None'),
                _buildInfoRow('Chat ID', widget.mealPlan.chatId ?? 'None'),
                _buildInfoRow(
                    'Validation Status',
                    _formatEnumValue(
                        widget.mealPlan.validationStatus?.name ?? 'UNKNOWN')),
                _buildInfoRow('Generated At',
                    _formatDateTime(widget.mealPlan.generatedAt)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(dynamic dateTime) {
    if (dateTime == null) return 'Not set';
    try {
      final dt = dateTime.getDateTime();
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(dt);
    } catch (e) {
      return 'Invalid date';
    }
  }

  String _formatEnumValue(String enumValue) {
    return enumValue
        .split('_')
        .map((word) => word.toLowerCase().replaceFirstMapped(
            RegExp(r'^.'), (match) => match.group(0)!.toUpperCase()))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit_note, color: Colors.white),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Modify Meal Plan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildBasicInfoSection(),
                    _buildDailyPlanSection(),
                    _buildMetadataSection(),
                  ],
                ),
              ),
            ),
            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed:
                        _isLoading ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed:
                        _isLoading || !_hasChanges() ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Save Changes'),
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
