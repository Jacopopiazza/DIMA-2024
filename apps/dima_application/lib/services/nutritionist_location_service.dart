import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/AmplifyWrapper/AmplifyGraphQL.dart';
import 'package:dima_application/generated/flutter-models/NutritionistLocation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class NutritionistLocationService {
  final AmplifyGraphQL _amplifyGraphQL;

  NutritionistLocationService({AmplifyGraphQL? amplifyGraphQL})
      : _amplifyGraphQL = amplifyGraphQL ?? AmplifyGraphQL();

  Future<NutritionistLocation?> updateNutritionistLocation({
    required double latitude,
    required double longitude,
    String? address,
    String? notes,
  }) async {
    try {
      safePrint(
          '[NutritionistLocationService] Updating location: lat=$latitude, lng=$longitude');

      const String updateLocationMutation = '''
        mutation UpdateNutritionistLocation(\$input: NutritionistLocationInput!) {
          updateNutritionistLocation(input: \$input) {
            nutritionistId
            latitude
            longitude
            address
            notes
            updatedAt
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: updateLocationMutation,
        variables: {
          'input': {
            'latitude': latitude,
            'longitude': longitude,
            'address': address,
            'notes': notes,
          }
        },
      );

      final operation = _amplifyGraphQL.mutate(request: request);
      final result = await operation.response;

      if (result.hasErrors) {
        safePrint(
            '[NutritionistLocationService] Error updating location: ${result.errors}');
        throw Exception(
            result.errors?.join(', ') ?? 'Failed to update location');
      }

      if (result.data == null) {
        safePrint(
            '[NutritionistLocationService] No data returned after updating location');
        throw Exception('Failed to update location: No data returned');
      }

      Map<String, dynamic> jsonData;
      if (result.data is String) {
        safePrint(
            '[NutritionistLocationService] Response is String, decoding JSON...');
        jsonData = json.decode(result.data!);
      } else if (result.data is Map<String, dynamic>) {
        safePrint('[NutritionistLocationService] Response is already Map...');
        jsonData = result.data as Map<String, dynamic>;
      } else {
        safePrint(
            '[NutritionistLocationService] Unexpected response data type: ${result.data.runtimeType}');
        throw Exception('GraphQL query failed with errors');
      }

      safePrint('[NutritionistLocationService] Parsed JSON data: $jsonData');

      if (jsonData['updateNutritionistLocation'] != null) {
        final locationData = jsonData['updateNutritionistLocation'];
        safePrint(
            '[NutritionistLocationService] Location data found: $locationData');
        return NutritionistLocation.fromJson(locationData);
      }

      throw Exception('Failed to update location: No location data returned');
    } catch (e) {
      safePrint(
          '[NutritionistLocationService] Error updating location: ${e.toString()}');
      throw Exception('Failed to update location: ${e.toString()}');
    }
  }

  Future<void> removeNutritionistLocation() async {
    try {
      safePrint('[NutritionistLocationService] Removing nutritionist location');

      const String removeLocationMutation = '''
        mutation RemoveNutritionistLocation {
          removeNutritionistLocation {
            nutritionistId
            latitude
            longitude
            address
            notes
            updatedAt
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: removeLocationMutation,
        variables: {},
      );

      final operation = _amplifyGraphQL.mutate(request: request);
      final result = await operation.response;

      if (result.hasErrors) {
        safePrint(
            '[NutritionistLocationService] Error removing location: ${result.errors}');
        throw Exception(
            result.errors?.join(', ') ?? 'Failed to remove location');
      }

      if (result.data == null) {
        safePrint(
            '[NutritionistLocationService] No data returned for removing location');
        throw Exception('Failed to remove location: No data returned');
      }

      // For remove operation, we just need to check if it completed successfully
      // The actual data content doesn't matter as much as the absence of errors
      safePrint('[NutritionistLocationService] Location removed successfully');
    } catch (e) {
      safePrint(
          '[NutritionistLocationService] Error removing location: ${e.toString()}');
      throw Exception('Failed to remove location: ${e.toString()}');
    }
  }

  Future<NutritionistLocation?> getMyLocation() async {
    try {
      safePrint(
          '[NutritionistLocationService] Fetching my nutritionist location');

      const String getMyLocationQuery = '''
        query GetMyLocation {
          getMyLocation {
            nutritionistId
            latitude
            longitude
            address
            notes
            updatedAt
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: getMyLocationQuery,
        variables: {},
      );

      final operation = _amplifyGraphQL.query(request: request);
      final result = await operation.response;

      if (result.hasErrors) {
        safePrint(
            '[NutritionistLocationService] Error fetching my location: ${result.errors}');
        return null;
      }

      if (result.data == null) {
        safePrint(
            '[NutritionistLocationService] No data returned for my location');
        return null;
      }

      Map<String, dynamic> jsonData;
      if (result.data is String) {
        safePrint(
            '[NutritionistLocationService] Response is String, decoding JSON...');
        jsonData = json.decode(result.data!);
      } else if (result.data is Map<String, dynamic>) {
        safePrint('[NutritionistLocationService] Response is already Map...');
        jsonData = result.data as Map<String, dynamic>;
      } else {
        safePrint(
            '[NutritionistLocationService] Unexpected response data type: ${result.data.runtimeType}');
        throw Exception('GraphQL query failed with errors');
      }

      safePrint('[NutritionistLocationService] Parsed JSON data: $jsonData');

      if (jsonData['getMyLocation'] != null) {
        final locationData = jsonData['getMyLocation'];
        safePrint(
            '[NutritionistLocationService] Location data found: $locationData');
        return NutritionistLocation.fromJson(locationData);
      }

      return null; // No location set
    } catch (e) {
      safePrint(
          '[NutritionistLocationService] Error fetching my location: ${e.toString()}');
      return null;
    }
  }

  Future<NutritionistLocation?> getNutritionistLocation(
      String nutritionistId) async {
    try {
      safePrint(
          '[NutritionistLocationService] Fetching location for nutritionist: $nutritionistId');

      const String getNutritionistLocationQuery = '''
        query GetNutritionistLocation(\$nutritionistId: ID!) {
          getNutritionistLocation(nutritionistId: \$nutritionistId) {
            nutritionistId
            latitude
            longitude
            address
            notes
            updatedAt
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: getNutritionistLocationQuery,
        variables: {'nutritionistId': nutritionistId},
      );

      safePrint(
          '[NutritionistLocationService] Sending request: ${request.toJson()}');

      final operation = _amplifyGraphQL.query(request: request);
      final result = await operation.response;

      if (result.hasErrors) {
        safePrint(
            '[NutritionistLocationService] Error updating location: ${result.errors}');
        throw Exception(
            result.errors?.join(', ') ?? 'Failed to update location');
      }

      if (result.data == null) {
        safePrint(
            '[NutritionistLocationService] No data returned after updating location');
        throw Exception('Failed to update location: No data returned');
      }

      safePrint(
          '[NutritionistLocationService] Raw response data: ${result.data}');

      Map<String, dynamic> jsonData;
      if (result.data is String) {
        safePrint(
            '[NutritionistLocationService] Response is String, decoding JSON...');
        jsonData = json.decode(result.data!);
      } else if (result.data is Map<String, dynamic>) {
        safePrint('[NutritionistLocationService] Response is already Map...');
        jsonData = result.data as Map<String, dynamic>;
      } else {
        safePrint(
            '[NutritionistLocationService] Unexpected response data type: ${result.data.runtimeType}');
        throw Exception('GraphQL query failed with errors');
      }

      safePrint('[NutritionistLocationService] Parsed JSON data: $jsonData');

      if (jsonData['getNutritionistLocation'] != null) {
        final locationData = jsonData['getNutritionistLocation'];
        safePrint(
            '[NutritionistLocationService] Location data found: $locationData');
        return NutritionistLocation.fromJson(locationData);
      }

      return null; // No location set for this nutritionist
    } catch (e) {
      safePrint(
          '[NutritionistLocationService] Error fetching nutritionist location: ${e.toString()}');
      return null;
    }
  }

  Future<CurrentLocationResult> getCurrentPosition() async {
    try {
      safePrint('[NutritionistLocationService] Getting current position');

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return CurrentLocationResult(
          success: false,
          message:
              'Location services are disabled. Please enable location services.',
          location: null,
        );
      }

      // Check for location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return CurrentLocationResult(
            success: false,
            message:
                'Location permissions are denied. Please allow location access.',
            location: null,
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return CurrentLocationResult(
          success: false,
          message:
              'Location permissions are permanently denied. Please enable in settings.',
          location: null,
        );
      }

      // Get current position with high accuracy
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        ),
      );

      // Try to get address from coordinates using reverse geocoding
      String? address;
      try {
        safePrint(
            '[NutritionistLocationService] Starting reverse geocoding for lat: ${position.latitude}, lng: ${position.longitude}');

        List<Placemark>? placemarks;
        try {
          placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          safePrint(
              '[NutritionistLocationService] placemarkFromCoordinates succeeded, found ${placemarks.length} placemarks');
        } catch (geocodingError) {
          safePrint(
              '[NutritionistLocationService] placemarkFromCoordinates failed: $geocodingError');
          address = null; // Let user enter address manually
          return CurrentLocationResult(
            success: true,
            message: 'Location retrieved successfully',
            location: CurrentLocationData(
              latitude: position.latitude,
              longitude: position.longitude,
              address: address,
            ),
          );
        }

        safePrint(
            '[NutritionistLocationService] Received ${placemarks?.length ?? 0} placemarks');

        if (placemarks != null && placemarks.isNotEmpty) {
          final place = placemarks.first;

          // Build a readable address safely
          List<String> addressParts = [];

          // Use safe string access
          final street = place.street;
          if (street != null && street.isNotEmpty) {
            addressParts.add(street);
          }

          final subThoroughfare = place.subThoroughfare;
          if (subThoroughfare != null && subThoroughfare.isNotEmpty) {
            addressParts.add(subThoroughfare);
          }

          final locality = place.locality;
          if (locality != null && locality.isNotEmpty) {
            addressParts.add(locality);
          }

          final administrativeArea = place.administrativeArea;
          if (administrativeArea != null && administrativeArea.isNotEmpty) {
            addressParts.add(administrativeArea);
          }

          final country = place.country;
          if (country != null && country.isNotEmpty) {
            addressParts.add(country);
          }

          address = addressParts.isNotEmpty
              ? addressParts.join(', ')
              : null; // No address found, let user enter manually

          safePrint('[NutritionistLocationService] Final address: $address');
        } else {
          safePrint('[NutritionistLocationService] No placemarks returned');
          address = null; // No address found, let user enter manually
        }
      } catch (e) {
        safePrint('[NutritionistLocationService] Reverse geocoding failed: $e');
        address = null; // Let user enter address manually
      }

      return CurrentLocationResult(
        success: true,
        message: 'Location retrieved successfully',
        location: CurrentLocationData(
          latitude: position.latitude,
          longitude: position.longitude,
          address: address,
        ),
      );
    } catch (e) {
      safePrint(
          '[NutritionistLocationService] Error getting current position: ${e.toString()}');
      String errorMessage = 'Failed to get current location';

      // Provide more specific error messages based on the type of error
      if (e is LocationServiceDisabledException) {
        errorMessage =
            'Location services are disabled. Please enable location services.';
      } else if (e is PermissionDeniedException) {
        errorMessage =
            'Location permissions are denied. Please allow location access.';
      } else if (e is TimeoutException) {
        errorMessage = 'Location request timed out. Please try again.';
      } else {
        errorMessage = 'Failed to get current location: ${e.toString()}';
      }

      return CurrentLocationResult(
        success: false,
        message: errorMessage,
        location: null,
      );
    }
  }

  /// Checks if location permissions are granted and location services are enabled
  Future<LocationPermissionStatus> checkLocationStatus() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationPermissionStatus.serviceDisabled;
      }

      // Check for location permissions
      LocationPermission permission = await Geolocator.checkPermission();

      switch (permission) {
        case LocationPermission.denied:
          return LocationPermissionStatus.denied;
        case LocationPermission.deniedForever:
          return LocationPermissionStatus.deniedForever;
        case LocationPermission.whileInUse:
        case LocationPermission.always:
          return LocationPermissionStatus.granted;
        default:
          return LocationPermissionStatus.denied;
      }
    } catch (e) {
      safePrint(
          '[NutritionistLocationService] Error checking location status: ${e.toString()}');
      return LocationPermissionStatus.unknown;
    }
  }

  /// Requests location permissions from the user
  Future<LocationPermissionStatus> requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      switch (permission) {
        case LocationPermission.denied:
          return LocationPermissionStatus.denied;
        case LocationPermission.deniedForever:
          return LocationPermissionStatus.deniedForever;
        case LocationPermission.whileInUse:
        case LocationPermission.always:
          return LocationPermissionStatus.granted;
        default:
          return LocationPermissionStatus.denied;
      }
    } catch (e) {
      safePrint(
          '[NutritionistLocationService] Error requesting location permission: ${e.toString()}');
      return LocationPermissionStatus.unknown;
    }
  }

  /// Opens the app settings for location permissions (when permanently denied)
  Future<bool> openLocationSettings() async {
    try {
      return await Geolocator.openLocationSettings();
    } catch (e) {
      safePrint(
          '[NutritionistLocationService] Error opening location settings: ${e.toString()}');
      return false;
    }
  }

  /// Gets address from coordinates using reverse geocoding
  Future<String?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      safePrint(
          '[NutritionistLocationService] Getting address for coordinates: $latitude, $longitude');

      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        List<String> addressParts = [];

        // Build address in logical order: street number, street, city, region, country
        if (place.subThoroughfare != null &&
            place.subThoroughfare!.isNotEmpty) {
          addressParts.add(place.subThoroughfare!);
        }
        if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty) {
          addressParts.add(place.thoroughfare!);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          addressParts.add(place.locality!);
        }
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          addressParts.add(place.administrativeArea!);
        }
        if (place.country != null && place.country!.isNotEmpty) {
          addressParts.add(place.country!);
        }

        final address =
            addressParts.isNotEmpty ? addressParts.join(', ') : null;
        safePrint('[NutritionistLocationService] Found address: $address');
        return address;
      }

      return null;
    } catch (e) {
      safePrint(
          '[NutritionistLocationService] Error in reverse geocoding: ${e.toString()}');
      return null;
    }
  }
}

enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
  unknown,
}

class CurrentLocationData {
  final double latitude;
  final double longitude;
  final String? address;

  const CurrentLocationData({
    required this.latitude,
    required this.longitude,
    this.address,
  });
}

class CurrentLocationResult {
  final bool success;
  final String message;
  final CurrentLocationData? location;

  const CurrentLocationResult({
    required this.success,
    required this.message,
    this.location,
  });
}
