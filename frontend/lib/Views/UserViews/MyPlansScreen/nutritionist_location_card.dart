import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:dima_application/generated/flutter-models/NutritionistLocation.dart';
import 'package:dima_application/services/nutritionist_location_service.dart';
import 'package:dima_application/Views/UserViews/MyPlansScreen/nutritionist_location_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class NutritionistLocationCard extends StatefulWidget {
  final String? mealPlanId;
  final String? nutritionistId;

  const NutritionistLocationCard(
      {super.key, this.mealPlanId, this.nutritionistId});

  @override
  State<NutritionistLocationCard> createState() =>
      _NutritionistLocationCardState();
}

class _NutritionistLocationCardState extends State<NutritionistLocationCard> {
  final NutritionistLocationService _locationService =
      NutritionistLocationService();
  NutritionistLocation? _location;
  bool _isLoading = true;
  String? _error;
  String? _resolvedAddress;
  bool _isLocationExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final location = widget.nutritionistId != null
          ? await _locationService.getNutritionistLocation(
              widget.nutritionistId!.replaceAll("NUTR#", ""))
          : null;
      if (mounted && location != null) {
        // Try to get a more detailed address if not already present
        String? resolvedAddress = location.address;
        if (resolvedAddress == null || resolvedAddress == 'Current Location') {
          resolvedAddress = await _locationService.getAddressFromCoordinates(
            location.latitude,
            location.longitude,
          );
        }

        setState(() {
          _location = location;
          _resolvedAddress = resolvedAddress;
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          _location = location;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openInMaps() async {
    if (_location == null) return;

    final lat = _location!.latitude;
    final lng = _location!.longitude;

    // Try Apple Maps first on iOS, then Google Maps as fallback
    final appleMapsUrl = Uri.parse('maps://?q=$lat,$lng');
    final googleMapsUrl = Uri.parse('https://maps.google.com/maps?q=$lat,$lng');

    try {
      if (await canLaunchUrl(appleMapsUrl)) {
        await launchUrl(appleMapsUrl);
      } else if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)!.couldNotOpenMaps(e.toString())),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    }
  }

  void _openFullScreenMap() {
    if (_location == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NutritionistLocationMap(
          location: _location!,
          resolvedAddress: _resolvedAddress,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Only show card if location exists or is loading
    if (_location == null && !_isLoading && _error == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: theme.copyWith(
          dividerColor: Colors.transparent,
        ),
        child: _isLoading
            ? _buildLoadingState(colorScheme)
            : _buildLocationExpansionTile(theme, colorScheme),
      ),
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 16,
                width: 150,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 12,
                width: 100,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationExpansionTile(ThemeData theme, ColorScheme colorScheme) {
    if (_error != null) {
      return _buildErrorState(theme, colorScheme);
    }

    if (_location == null) {
      return const SizedBox.shrink();
    }

    return ExpansionTile(
      initiallyExpanded: _isLocationExpanded,
      onExpansionChanged: (expanded) =>
          setState(() => _isLocationExpanded = expanded),
      tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      childrenPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      collapsedBackgroundColor: Colors.transparent,
      iconColor: colorScheme.onSurface,
      collapsedIconColor: colorScheme.onSurface,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.location_on_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
      title: Text(
        AppLocalizations.of(context)!.nutritionistOffice,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        AppLocalizations.of(context)!.viewOfficeLocationAndDirections,
        style: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 13,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: _buildExpandedLocationContent(theme, colorScheme),
        ),
      ],
    );
  }

  Widget _buildExpandedLocationContent(
      ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        // Address information
        if (_resolvedAddress != null || _location!.address != null)
          _buildInfoRow(
            Icons.place_rounded,
            AppLocalizations.of(context)!.address,
            _resolvedAddress ??
                _location!.address ??
                AppLocalizations.of(context)!.locationCoordinates(
                    _location!.latitude.toStringAsFixed(4),
                    _location!.longitude.toStringAsFixed(4)),
            theme,
            colorScheme,
          ),

        // Additional notes
        if (_location!.notes != null)
          _buildInfoRow(
            Icons.info_outline_rounded,
            AppLocalizations.of(context)!.additionalNotes,
            _location!.notes!,
            theme,
            colorScheme,
          ),

        // Interactive map preview
        const SizedBox(height: 16),
        _buildMapPreview(theme, colorScheme),

        // Action buttons
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _openInMaps,
                icon: const Icon(Icons.directions_rounded, size: 18),
                label: Text(AppLocalizations.of(context)!.directions),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: colorScheme.primary),
                  foregroundColor: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: _openFullScreenMap,
                icon: const Icon(Icons.map_rounded, size: 18),
                label: Text(AppLocalizations.of(context)!.viewMap),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,
      ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              icon,
              size: 16,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.error_outline_rounded,
            color: colorScheme.onErrorContainer,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.locationNotAvailable,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!.couldNotLoadNutritionistLocation,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: _loadLocation,
          child: Text(AppLocalizations.of(context)!.retry),
        ),
      ],
    );
  }

  Widget _buildMapPreview(ThemeData theme, ColorScheme colorScheme) {
    if (_location == null) {
      return Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return InkWell(
      onTap: _openInMaps,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Real OpenStreetMaps
              FlutterMap(
                options: MapOptions(
                  initialCenter:
                      LatLng(_location!.latitude, _location!.longitude),
                  initialZoom: 15.0,
                  interactionOptions: const InteractionOptions(
                    flags:
                        InteractiveFlag.none, // Disable interaction for preview
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.dima_application',
                    maxZoom: 19,
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point:
                            LatLng(_location!.latitude, _location!.longitude),
                        width: 40,
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme.error,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.local_hospital_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Tap overlay for better visual feedback
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        colorScheme.primary.withOpacity(0.05),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // Tap indicator
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.open_in_new_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
