import 'package:dima_application/providers/app_lifecycle_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLifecycleProvider', () {
    late ProviderContainer container;
    late AppLifecycleNotifier notifier;

    setUpAll(() {
      // Initialize Flutter binding for tests
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(appLifecycleProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    group('Initial state', () {
      test('has unknown state initially', () {
        final state = container.read(appLifecycleProvider);
        expect(state.state, CustomAppLifecycleState.unknown);
        expect(state.timestamp, isA<DateTime>());
        expect(state.timeSinceLastForeground, isNull);
      });

      test('initializes with current timestamp', () {
        final state = container.read(appLifecycleProvider);
        final now = DateTime.now();
        final timeDiff = now.difference(state.timestamp).inSeconds;
        expect(timeDiff, lessThan(1)); // Should be within 1 second
      });
    });

    group('AppLifecycleData', () {
      test('copyWith works correctly', () {
        final original = AppLifecycleData(
          state: CustomAppLifecycleState.unknown,
          timestamp: DateTime(2024, 1, 1),
          timeSinceLastForeground: Duration(minutes: 5),
        );

        final updated = original.copyWith(
          state: CustomAppLifecycleState.resumed,
          timestamp: DateTime(2024, 1, 2),
        );

        expect(updated.state, CustomAppLifecycleState.resumed);
        expect(updated.timestamp, DateTime(2024, 1, 2));
        expect(updated.timeSinceLastForeground, Duration(minutes: 5));
      });

      test('copyWith preserves original values when null', () {
        final original = AppLifecycleData(
          state: CustomAppLifecycleState.paused,
          timestamp: DateTime(2024, 1, 1),
          timeSinceLastForeground: Duration(minutes: 10),
        );

        final updated = original.copyWith();

        expect(updated.state, CustomAppLifecycleState.paused);
        expect(updated.timestamp, DateTime(2024, 1, 1));
        expect(updated.timeSinceLastForeground, Duration(minutes: 10));
      });
    });

    group('Lifecycle state changes', () {
      test('handles resumed state correctly', () {
        // Simulate app resume
        notifier.didChangeAppLifecycleState(AppLifecycleState.resumed);

        final state = container.read(appLifecycleProvider);
        expect(state.state, CustomAppLifecycleState.resumed);
        expect(state.timestamp, isA<DateTime>());
      });

      test('handles paused state correctly', () {
        notifier.didChangeAppLifecycleState(AppLifecycleState.paused);

        final state = container.read(appLifecycleProvider);
        expect(state.state, CustomAppLifecycleState.backgrounded);
        expect(state.timestamp, isA<DateTime>());
      });

      test('handles inactive state correctly', () {
        notifier.didChangeAppLifecycleState(AppLifecycleState.inactive);

        final state = container.read(appLifecycleProvider);
        expect(state.state, CustomAppLifecycleState.inactive);
        expect(state.timestamp, isA<DateTime>());
      });

      test('handles detached state correctly', () {
        notifier.didChangeAppLifecycleState(AppLifecycleState.detached);

        final state = container.read(appLifecycleProvider);
        expect(state.state, CustomAppLifecycleState.detached);
        expect(state.timestamp, isA<DateTime>());
      });

      test('handles hidden state correctly', () {
        notifier.didChangeAppLifecycleState(AppLifecycleState.hidden);

        final state = container.read(appLifecycleProvider);
        expect(state.state, CustomAppLifecycleState.backgrounded);
        expect(state.timestamp, isA<DateTime>());
      });
    });

    group('Background time tracking', () {
      test('calculates time since last foreground correctly', () async {
        // First pause the app
        notifier.didChangeAppLifecycleState(AppLifecycleState.paused);

        // Wait a bit
        await Future.delayed(Duration(milliseconds: 100));

        // Then resume
        notifier.didChangeAppLifecycleState(AppLifecycleState.resumed);

        final state = container.read(appLifecycleProvider);
        expect(state.timeSinceLastForeground, isNotNull);
        expect(state.timeSinceLastForeground!.inMilliseconds, greaterThan(50));
      });

      test('handles resume without previous background', () {
        notifier.didChangeAppLifecycleState(AppLifecycleState.resumed);

        final state = container.read(appLifecycleProvider);
        expect(state.timeSinceLastForeground, isNull);
      });

      test('hasBeenBackgroundedSignificantly returns correct value', () {
        // Initially false
        expect(notifier.hasBeenBackgroundedSignificantly, false);

        // Pause and resume quickly
        notifier.didChangeAppLifecycleState(AppLifecycleState.paused);
        notifier.didChangeAppLifecycleState(AppLifecycleState.resumed);
        expect(notifier.hasBeenBackgroundedSignificantly, false);
      });

      test('timeSinceLastBackground returns correct value', () {
        // Initially null
        expect(notifier.timeSinceLastBackground, isNull);

        // After pause, should have a value
        notifier.didChangeAppLifecycleState(AppLifecycleState.paused);
        expect(notifier.timeSinceLastBackground, isNotNull);
        expect(notifier.timeSinceLastBackground!.inMilliseconds,
            greaterThanOrEqualTo(0));
      });
    });

    group('Edge cases', () {
      test('handles rapid state changes', () {
        notifier.didChangeAppLifecycleState(AppLifecycleState.paused);
        notifier.didChangeAppLifecycleState(AppLifecycleState.resumed);
        notifier.didChangeAppLifecycleState(AppLifecycleState.paused);
        notifier.didChangeAppLifecycleState(AppLifecycleState.resumed);

        final state = container.read(appLifecycleProvider);
        expect(state.state, CustomAppLifecycleState.resumed);
      });

      test('handles multiple resume events', () {
        notifier.didChangeAppLifecycleState(AppLifecycleState.resumed);
        notifier.didChangeAppLifecycleState(AppLifecycleState.resumed);
        notifier.didChangeAppLifecycleState(AppLifecycleState.resumed);

        final state = container.read(appLifecycleProvider);
        expect(state.state, CustomAppLifecycleState.resumed);
      });

      test('handles multiple pause events', () {
        notifier.didChangeAppLifecycleState(AppLifecycleState.paused);
        notifier.didChangeAppLifecycleState(AppLifecycleState.paused);
        notifier.didChangeAppLifecycleState(AppLifecycleState.paused);

        final state = container.read(appLifecycleProvider);
        expect(state.state, CustomAppLifecycleState.backgrounded);
      });
    });

    group('Disposal', () {
      test('disposes correctly', () {
        expect(() => notifier.dispose(), returnsNormally);
      });

      test('can dispose multiple times safely', () {
        notifier.dispose();
        expect(() => notifier.dispose(), returnsNormally);
      });
    });

    group('State transitions', () {
      test('unknown to resumed transition', () {
        notifier.didChangeAppLifecycleState(AppLifecycleState.resumed);
        final state = container.read(appLifecycleProvider);
        expect(state.state, CustomAppLifecycleState.resumed);
      });

      test('resumed to paused transition', () {
        notifier.didChangeAppLifecycleState(AppLifecycleState.resumed);
        notifier.didChangeAppLifecycleState(AppLifecycleState.paused);
        final state = container.read(appLifecycleProvider);
        expect(state.state, CustomAppLifecycleState.backgrounded);
      });

      test('paused to inactive transition', () {
        notifier.didChangeAppLifecycleState(AppLifecycleState.paused);
        notifier.didChangeAppLifecycleState(AppLifecycleState.inactive);
        final state = container.read(appLifecycleProvider);
        expect(state.state, CustomAppLifecycleState.inactive);
      });

      test('inactive to detached transition', () {
        notifier.didChangeAppLifecycleState(AppLifecycleState.inactive);
        notifier.didChangeAppLifecycleState(AppLifecycleState.detached);
        final state = container.read(appLifecycleProvider);
        expect(state.state, CustomAppLifecycleState.detached);
      });
    });

    group('Timestamp accuracy', () {
      test('timestamp is always current', () {
        final before = DateTime.now();
        notifier.didChangeAppLifecycleState(AppLifecycleState.resumed);
        final after = DateTime.now();

        final state = container.read(appLifecycleProvider);
        expect(state.timestamp.isAfter(before.subtract(Duration(seconds: 1))),
            true);
        expect(state.timestamp.isBefore(after.add(Duration(seconds: 1))), true);
      });

      test('different states have different timestamps', () async {
        notifier.didChangeAppLifecycleState(AppLifecycleState.resumed);
        final firstTimestamp = container.read(appLifecycleProvider).timestamp;

        await Future.delayed(Duration(milliseconds: 10));

        notifier.didChangeAppLifecycleState(AppLifecycleState.paused);
        final secondTimestamp = container.read(appLifecycleProvider).timestamp;

        expect(secondTimestamp.isAfter(firstTimestamp), true);
      });
    });

    group('CustomAppLifecycleState enum', () {
      test('all enum values are defined', () {
        expect(CustomAppLifecycleState.values.length, 6);
        expect(CustomAppLifecycleState.values,
            contains(CustomAppLifecycleState.unknown));
        expect(CustomAppLifecycleState.values,
            contains(CustomAppLifecycleState.resumed));
        expect(CustomAppLifecycleState.values,
            contains(CustomAppLifecycleState.paused));
        expect(CustomAppLifecycleState.values,
            contains(CustomAppLifecycleState.inactive));
        expect(CustomAppLifecycleState.values,
            contains(CustomAppLifecycleState.detached));
        expect(CustomAppLifecycleState.values,
            contains(CustomAppLifecycleState.backgrounded));
      });
    });
  });
}
