import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dima_application/services/connectivity_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_setup.dart';

void main() {
  configureTestEnvironment();

  group('ConnectivityService', () {
    late ConnectivityService connectivityService;

    setUp(() {
      connectivityService = ConnectivityService();
    });

    tearDown(() {
      connectivityService.dispose();
    });

    group('Singleton behavior', () {
      test('returns the same instance', () {
        final instance1 = ConnectivityService();
        final instance2 = ConnectivityService();

        expect(identical(instance1, instance2), isTrue);
      });
    });

    group('Service initialization', () {
      test('creates ConnectivityService instance successfully', () {
        expect(connectivityService, isNotNull);
        expect(connectivityService, isA<ConnectivityService>());
      });

      test('has initial connection state', () {
        expect(connectivityService.isConnected, isFalse);
      });
    });

    group('Stream management', () {
      test('connection stream is broadcast', () {
        expect(connectivityService.connectionStream.isBroadcast, isTrue);
      });

      test('multiple listeners can subscribe to connection stream', () {
        final subscription1 =
            connectivityService.connectionStream.listen((_) {});
        final subscription2 =
            connectivityService.connectionStream.listen((_) {});

        expect(subscription1, isNotNull);
        expect(subscription2, isNotNull);

        subscription1.cancel();
        subscription2.cancel();
      });
    });

    group('Public API', () {
      test('exposes isConnected getter', () {
        expect(connectivityService.isConnected, isA<bool>());
      });

      test('exposes connectionStream getter', () {
        expect(connectivityService.connectionStream, isA<Stream<bool>>());
      });

      test('exposes initialize method', () {
        expect(connectivityService.initialize, isA<Future<void> Function()>());
      });

      test('exposes checkConnectivityManually method', () {
        expect(connectivityService.checkConnectivityManually,
            isA<Future<bool> Function()>());
      });

      test('exposes dispose method', () {
        expect(connectivityService.dispose, isA<void Function()>());
      });
    });
  });
}
