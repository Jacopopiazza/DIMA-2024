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
      if (mounted) {
        setState(() {
          _nutritionists = nutritionists;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a nutritionist'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isAssigning = true;
      });
    }

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
              content: Text('Validation request sent successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to send validation request'),
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
            content: Text('Error sending validation request: $e'),
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

  Widget _buildProfileImage(String? imageUrl, {double size = 60}) {
    if (imageUrl == null || imageUrl.isEmpty) {
      // Fallback to a default avatar icon
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.person,
          size: size * 0.5,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      );
    }

    return ClipOval(
      child: Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          // Fallback to default avatar on error
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              size: size * 0.5,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          );
        },
      ),
    );
  }

  Widget _buildNutritionistCard(NutritionistProfile nutritionist) {
    final isSelected = _selectedNutritionistId == nutritionist.nutritionistId;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: isSelected
          ? colorScheme.primary.withOpacity(0.1)
          : colorScheme.surface,
      elevation: isSelected ? 2 : 1,
      child: InkWell(
        onTap: () {
          if (mounted) {
            setState(() {
              _selectedNutritionistId = nutritionist.nutritionistId;
            });
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Profile Image
              _buildProfileImage(nutritionist.profilePictureUrl),
              const SizedBox(width: 16),

              // Nutritionist Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      '${nutritionist.givenName ?? ''} ${nutritionist.familyName ?? ''}'
                          .trim(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Specialization/Role
                    if (nutritionist.specialization != null &&
                        nutritionist.specialization!.isNotEmpty)
                      Text(
                        nutritionist.specialization!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                    // Bio (truncated)
                    if (nutritionist.bio != null &&
                        nutritionist.bio!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          nutritionist.bio!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    // Availability Status
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
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
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: nutritionist.isAvailable == true
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Selection Indicator
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: colorScheme.primary,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
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
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_nutritionists.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 48,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No nutritionists available at the moment.',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _nutritionists.length,
                  itemBuilder: (context, index) {
                    final nutritionist = _nutritionists[index];
                    return _buildNutritionistCard(nutritionist);
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
