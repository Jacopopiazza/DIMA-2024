import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:dima_application/generated/flutter-models/NutritionistLocation.dart';
import 'package:dima_application/services/nutritionist_location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NutritionistLocationSection extends StatefulWidget {
  final VoidCallback? onLocationUpdated;

  const NutritionistLocationSection({
    super.key,
    this.onLocationUpdated,
  });

  @override
  State<NutritionistLocationSection> createState() =>
      _NutritionistLocationSectionState();
}

class _NutritionistLocationSectionState
    extends State<NutritionistLocationSection> {
  final NutritionistLocationService _locationService =
      NutritionistLocationService();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isGettingLocation = false;
  bool _isSaving = false;
  bool _hasLocation = false;
  NutritionistLocation? _currentLocation;

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentLocation() async {
    try {
      final location = await _locationService.getMyLocation();
      if (location != null && mounted) {
        setState(() {
          _currentLocation = location;
          _hasLocation = true;
          _latController.text = location.latitude.toStringAsFixed(6);
          _lngController.text = location.longitude.toStringAsFixed(6);
          _addressController.text = location.address ?? '';
          _notesController.text = location.notes ?? '';
        });
      }
    } catch (e) {
      // Handle error silently for now since this is optional
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);

    try {
      // Directly get current position - the service handles permissions internally
      final response = await _locationService.getCurrentPosition();

      if (response.success && response.location != null) {
        _latController.text = response.location!.latitude.toStringAsFixed(6);
        _lngController.text = response.location!.longitude.toStringAsFixed(6);

        // Auto-fill address if it was retrieved
        if (response.location!.address != null &&
            response.location!.address != 'Current Location') {
          _addressController.text = response.location!.address!;
        }

        setState(() {
          _hasLocation = true;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.location!.address != null &&
                      response.location!.address != 'Current Location'
                  ? AppLocalizations.of(context)!
                      .locationAndAddressRetrievedSuccessfully
                  : AppLocalizations.of(context)!
                      .currentLocationRetrievedSuccessfully),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        String errorMessage = response.message;

        // Handle specific permission errors with actionable dialogs
        if (errorMessage.contains('Location services are disabled')) {
          _showLocationDialog(
            AppLocalizations.of(context)!.locationServicesDisabled,
            AppLocalizations.of(context)!.enableLocationServicesMessage,
            actionText: AppLocalizations.of(context)!.openSettings,
            onAction: () async {
              await _locationService.openLocationSettings();
            },
          );
          return;
        }

        if (errorMessage.contains('permanently denied')) {
          _showLocationDialog(
            AppLocalizations.of(context)!.locationPermissionRequired,
            AppLocalizations.of(context)!.locationPermissionsPermanentlyDenied,
            actionText: AppLocalizations.of(context)!.openSettings,
            onAction: () async {
              await _locationService.openLocationSettings();
            },
          );
          return;
        }

        if (errorMessage.contains('permissions are denied')) {
          _showLocationDialog(
            AppLocalizations.of(context)!.locationPermissionDenied,
            AppLocalizations.of(context)!.locationPermissionsRequired,
          );
          return;
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGettingLocation = false);
      }
    }
  }

  Future<void> _saveLocation() async {
    final latText = _latController.text.trim();
    final lngText = _lngController.text.trim();

    // Check if both are empty (user wants to remove location)
    if (latText.isEmpty && lngText.isEmpty) {
      await _removeLocation();
      return;
    }

    // Check if only one is filled (invalid state)
    if ((latText.isEmpty && lngText.isNotEmpty) ||
        (latText.isNotEmpty && lngText.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(AppLocalizations.of(context)!.enterBothCoordinatesOrNeither),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    // Parse coordinates
    final lat = double.tryParse(latText);
    final lng = double.tryParse(lngText);

    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(AppLocalizations.of(context)!.enterValidLatitudeLongitude),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final location = await _locationService.updateNutritionistLocation(
        latitude: lat,
        longitude: lng,
        address:
            _addressController.text.isNotEmpty ? _addressController.text : null,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      if (location != null) {
        setState(() {
          _currentLocation = location;
          _hasLocation = true;
        });

        widget.onLocationUpdated?.call();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  AppLocalizations.of(context)!.locationUpdatedSuccessfully),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!
                .failedToSaveLocation(e.toString())),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _removeLocation() async {
    setState(() => _isSaving = true);

    try {
      await _locationService.removeNutritionistLocation();

      setState(() {
        _currentLocation = null;
        _hasLocation = false;
        _latController.clear();
        _lngController.clear();
        _addressController.clear();
        _notesController.clear();
      });

      widget.onLocationUpdated?.call();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(context)!.locationRemovedSuccessfully),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove location: ${e.toString()}'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showLocationDialog(String title, String content,
      {String? actionText, VoidCallback? onAction}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            if (actionText != null && onAction != null)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onAction();
                },
                child: Text(actionText),
              ),
          ],
        );
      },
    );
  }

  bool _canSave() {
    final latText = _latController.text.trim();
    final lngText = _lngController.text.trim();

    // Both coordinates must be provided and valid
    if (latText.isNotEmpty && lngText.isNotEmpty) {
      final lat = double.tryParse(latText);
      final lng = double.tryParse(lngText);
      return lat != null && lng != null;
    }

    return false; // Empty fields or only one field filled - disable button
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.primary.withOpacity(0.1)
            : colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withOpacity(isDark ? 0.3 : 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.officeLocation,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context)!
                            .setOfficeLocationDescription,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Current location status (if available)
            if (_hasLocation && _currentLocation != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.green.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Office location is set',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Coordinates section
            Text(
              AppLocalizations.of(context)!.coordinates,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _latController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
                    ],
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.latitude,
                      hintText: '45.4642',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.my_location),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _hasLocation = _latController.text.isNotEmpty &&
                            _lngController.text.isNotEmpty;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _lngController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
                    ],
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.longitude,
                      hintText: '7.8994',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.place),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _hasLocation = _latController.text.isNotEmpty &&
                            _lngController.text.isNotEmpty;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Auto-detect location button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isGettingLocation ? null : _getCurrentLocation,
                icon: _isGettingLocation
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.primary,
                        ),
                      )
                    : const Icon(Icons.gps_fixed),
                label: Text(_isGettingLocation
                    ? AppLocalizations.of(context)!.gettingLocation
                    : AppLocalizations.of(context)!.useCurrentLocation),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: colorScheme.primary),
                  foregroundColor: colorScheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Address section
            Text(
              AppLocalizations.of(context)!.officeAddressOptional,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _addressController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.address,
                hintText: AppLocalizations.of(context)!.addressPlaceholder,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.location_on),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),

            const SizedBox(height: 24),

            // Notes section
            Text(
              AppLocalizations.of(context)!.additionalNotesOptional,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.notesForPatients,
                hintText: AppLocalizations.of(context)!.notesPlaceholder,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.note),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),

            const SizedBox(height: 24),

            // Clear Location button (only show if there's location data)
            if (_hasLocation && _currentLocation != null) ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isSaving
                      ? null
                      : () async {
                          _latController.clear();
                          _lngController.clear();
                          _addressController.clear();
                          _notesController.clear();
                          await _removeLocation();
                        },
                  icon: _isSaving
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.delete_forever_rounded,
                          color: Colors.white),
                  label: Text(_isSaving
                      ? AppLocalizations.of(context)!.removingLocation
                      : AppLocalizations.of(context)!.clearLocation),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shadowColor: Colors.red.withOpacity(0.3),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Save button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSaving || !_canSave() ? null : _saveLocation,
                icon: _isSaving
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(AppLocalizations.of(context)!.saveLocation),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
