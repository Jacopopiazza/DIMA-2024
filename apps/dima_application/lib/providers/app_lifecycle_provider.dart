import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import required providers
import 'today_page_provider.dart';
import 'meal_plans_provider.dart';
import 'user_details_provider.dart';
import 'cognito_profile_provider.dart';
import 'subscription_status_provider.dart';

/// Enum representing different app lifecycle states
enum CustomAppLifecycleState {
  unknown,
  resumed,
  paused,
  inactive,
  detached,
  backgrounded,
}

/// Data class to track app lifecycle with timing information
class AppLifecycleData {
  final CustomAppLifecycleState state;
  final DateTime timestamp;
  final Duration? timeSinceLastForeground;

  const AppLifecycleData({
    required this.state,
    required this.timestamp,
    this.timeSinceLastForeground,
  });

  AppLifecycleData copyWith({
    CustomAppLifecycleState? state,
    DateTime? timestamp,
    Duration? timeSinceLastForeground,
  }) {
    return AppLifecycleData(
      state: state ?? this.state,
      timestamp: timestamp ?? this.timestamp,
      timeSinceLastForeground: timeSinceLastForeground ?? this.timeSinceLastForeground,
    );
  }
}

/// Provider that manages app lifecycle state changes
final appLifecycleProvider = StateNotifierProvider<AppLifecycleNotifier, AppLifecycleData>((ref) {
  return AppLifecycleNotifier(ref);
});

/// AppLifecycleNotifier manages app lifecycle state changes and timing
class AppLifecycleNotifier extends StateNotifier<AppLifecycleData> with WidgetsBindingObserver {
  final Ref ref;
  DateTime? _lastBackgroundTime;
  DateTime? _lastForegroundTime;

  AppLifecycleNotifier(this.ref) : super(AppLifecycleData(
    state: CustomAppLifecycleState.unknown,
    timestamp: DateTime.now(),
  )) {
    _initialize();
  }

  void _initialize() {
    print('[AppLifecycleProvider] Initializing app lifecycle observer...');
    WidgetsBinding.instance.addObserver(this);
    
    // Set initial state based on current app state
    final currentState = WidgetsBinding.instance.lifecycleState;
    if (currentState != null) {
      _handleLifecycleChange(currentState);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('[AppLifecycleProvider] App lifecycle changed to: $state');
    _handleLifecycleChange(state);
  }

  void _handleLifecycleChange(AppLifecycleState lifecycleState) {
    final now = DateTime.now();
    Duration? timeSinceLastForeground;

    switch (lifecycleState) {
      case AppLifecycleState.resumed:
        print('[AppLifecycleProvider] App resumed - calculating time since background');
        _lastForegroundTime = now;
        
        if (_lastBackgroundTime != null) {
          timeSinceLastForeground = now.difference(_lastBackgroundTime!);
          print('[AppLifecycleProvider] App was backgrounded for: ${timeSinceLastForeground.inSeconds} seconds');
          
          // If app was backgrounded for more than 30 seconds, trigger data refresh
          if (timeSinceLastForeground.inSeconds > 30) {
            print('[AppLifecycleProvider] App was backgrounded for significant time, triggering data refresh...');
            _onAppResumedFromBackground(timeSinceLastForeground);
          }
        }
        
        this.state = AppLifecycleData(
          state: CustomAppLifecycleState.resumed,
          timestamp: now,
          timeSinceLastForeground: timeSinceLastForeground,
        );
        break;

      case AppLifecycleState.paused:
        print('[AppLifecycleProvider] App paused/backgrounded');
        _lastBackgroundTime = now;
        this.state = AppLifecycleData(
          state: CustomAppLifecycleState.backgrounded,
          timestamp: now,
        );
        break;

      case AppLifecycleState.inactive:
        print('[AppLifecycleProvider] App inactive');
        this.state = AppLifecycleData(
          state: CustomAppLifecycleState.inactive,
          timestamp: now,
        );
        break;

      case AppLifecycleState.detached:
        print('[AppLifecycleProvider] App detached');
        this.state = AppLifecycleData(
          state: CustomAppLifecycleState.detached,
          timestamp: now,
        );
        break;

      case AppLifecycleState.hidden:
        print('[AppLifecycleProvider] App hidden');
        // Treat as backgrounded for our purposes
        _lastBackgroundTime = now;
        this.state = AppLifecycleData(
          state: CustomAppLifecycleState.backgrounded,
          timestamp: now,
        );
        break;
    }
  }

  void _onAppResumedFromBackground(Duration backgroundDuration) {
    print('[AppLifecycleProvider] Processing app resume after ${backgroundDuration.inSeconds}s...');
    
    // Refresh stale providers when app resumes from significant background time
    Future.microtask(() {
      if (mounted) {
        _refreshStaleProviders();
      }
    });
  }

  void _refreshStaleProviders() {
    try {
      print('[AppLifecycleProvider] Refreshing potentially stale providers...');
      
      // Only refresh providers that might have stale data
      // User details and cognito profile are less likely to change
      ref.invalidate(todayPageProvider);
      ref.invalidate(mealPlansProvider);
      
      // These are less critical but refresh anyway for completeness
      ref.invalidate(userDetailsProvider);
      ref.invalidate(cognitoProfileProvider);
      ref.invalidate(subscriptionStatusProvider);
      
      print('[AppLifecycleProvider] Stale providers refreshed');
    } catch (e) {
      print('[AppLifecycleProvider] Error refreshing stale providers: $e');
    }
  }

  /// Check if app has been backgrounded for significant time
  bool get hasBeenBackgroundedSignificantly {
    if (_lastBackgroundTime == null || _lastForegroundTime == null) return false;
    final backgroundDuration = _lastForegroundTime!.difference(_lastBackgroundTime!);
    return backgroundDuration.inSeconds > 30;
  }

  /// Get time since last background event
  Duration? get timeSinceLastBackground {
    if (_lastBackgroundTime == null) return null;
    return DateTime.now().difference(_lastBackgroundTime!);
  }

  @override
  void dispose() {
    print('[AppLifecycleProvider] Disposing app lifecycle observer...');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

