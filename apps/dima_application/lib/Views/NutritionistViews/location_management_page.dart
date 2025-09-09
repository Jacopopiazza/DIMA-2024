import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:dima_application/generated/flutter-models/NutritionistLocation.dart';
import 'package:dima_application/services/nutritionist_location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocationManagementPage extends StatefulWidget {
  const LocationManagementPage({super.key});

  @override
  State<LocationManagementPage> createState() => _LocationManagementPageState();
}

class _LocationManagementPageState extends State<LocationManagementPage> {
  final NutritionistLocationService _locationService =
      NutritionistLocationService();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isLoading = false;
  bool _isGettingLocation = false;

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);

    try {
      // First check location status
      final status = await _locationService.checkLocationStatus();

      if (status == LocationPermissionStatus.serviceDisabled) {
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

      if (status == LocationPermissionStatus.deniedForever) {
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

      if (status == LocationPermissionStatus.denied) {
        final permissionStatus =
            await _locationService.requestLocationPermission();
        if (permissionStatus != LocationPermissionStatus.granted) {
          _showLocationDialog(
            AppLocalizations.of(context)!.locationPermissionDenied,
            AppLocalizations.of(context)!.locationPermissionsRequired,
          );
          return;
        }
      }

      // Get current position
      final response = await _locationService.getCurrentPosition();
      if (response != null && response.success && response.location != null) {
        _latController.text = response.location!.latitude.toStringAsFixed(6);
        _lngController.text = response.location!.longitude.toStringAsFixed(6);

        // Auto-fill address if it was retrieved
        if (response.location!.address != null &&
            response.location!.address != 'Current Location') {
          _addressController.text = response.location!.address!;
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.location!.address != null &&
                      response.location!.address != 'Current Location'
                  ? AppLocalizations.of(context)!.locationAndAddressRetrievedSuccessfully
                  : AppLocalizations.of(context)!.currentLocationRetrievedSuccessfully),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        throw Exception(response?.message ?? 'Failed to get location');
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

    return false; // Empty fields - disable button
  }

  Future<void> _saveLocation() async {
    final lat = double.tryParse(_latController.text);
    final lng = double.tryParse(_lngController.text);

    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.enterValidLatitudeLongitude),
          backgroundColor: Colors.red.shade600,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final location = await _locationService.updateNutritionistLocation(
        latitude: lat,
        longitude: lng,
        address:
            _addressController.text.isNotEmpty ? _addressController.text : null,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      if (location != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.locationUpdatedSuccessfully),
            backgroundColor: Colors.green.shade600,
          ),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Failed to save location');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.failedToSaveLocation(e.toString())),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.officeLocation),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isLoading || !_canSave() ? null : _saveLocation,
            child: Text(
              AppLocalizations.of(context)!.saveLocation,
              style: TextStyle(
                color: _isLoading || !_canSave()
                    ? colorScheme.onSurface.withOpacity(0.5)
                    : colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(colorScheme),
            const SizedBox(height: 24),
            _buildLocationSection(theme, colorScheme),
            const SizedBox(height: 24),
            _buildAddressSection(theme, colorScheme),
            const SizedBox(height: 24),
            _buildNotesSection(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.setOfficeLocationDescription,
              style: TextStyle(
                color: colorScheme.onPrimaryContainer,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.coordinates,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
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
                ),
                onChanged: (value) => setState(() {}), // Trigger rebuild to update save button
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
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
                ),
                onChanged: (value) => setState(() {}), // Trigger rebuild to update save button
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
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
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.officeAddressOptional,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _addressController,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.address,
            hintText: AppLocalizations.of(context)!.addressPlaceholder,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: const Icon(Icons.location_on),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.additionalNotesOptional,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.notesForPatients,
            hintText: AppLocalizations.of(context)!.notesPlaceholder,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: const Icon(Icons.note),
          ),
        ),
      ],
    );
  }
}
