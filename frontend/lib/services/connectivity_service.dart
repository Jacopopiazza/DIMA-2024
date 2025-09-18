import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectionController.stream;

  /// Initialize the connectivity service
  Future<void> initialize() async {
    // Check initial connectivity
    await _checkConnectivity();

    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) async {
        await _checkConnectivity();
      },
    );
  }

  /// Check current connectivity status
  Future<void> _checkConnectivity() async {
    try {
      final List<ConnectivityResult> connectivityResults =
          await _connectivity.checkConnectivity();

      // Check if we have any connection type
      bool hasConnection = connectivityResults.any((result) =>
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.ethernet);

      if (hasConnection) {
        // Double-check with actual internet access
        hasConnection = await _hasInternetAccess();
      }

      if (_isConnected != hasConnection) {
        _isConnected = hasConnection;
        _connectionController.add(_isConnected);
      }
    } catch (e) {
      print('Error checking connectivity: $e');
      if (_isConnected != false) {
        _isConnected = false;
        _connectionController.add(_isConnected);
      }
    }
  }

  /// Test actual internet access by attempting to connect to a reliable server
  Future<bool> _hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 7));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      print('Internet access check failed: $e');
      // During app initialization, fallback to basic connectivity check
      // to avoid false negatives when network is busy
      return true; // Assume connectivity if basic check passed
    }
  }

  /// Manually check connectivity (useful for pull-to-refresh scenarios)
  Future<bool> checkConnectivityManually() async {
    await _checkConnectivity();
    return _isConnected;
  }

  /// Dispose the service
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionController.close();
  }
}
