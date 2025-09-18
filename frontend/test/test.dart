// This file is used to configure test coverage exclusions
// Files and patterns listed here will be excluded from coverage reports

// @dart=2.18

// Coverage exclusions:
// - Generated files (*.g.dart, *.freezed.dart)
// - Main entry point
// - Firebase options
// - Generated models from Amplify
// - Platform-specific implementations

// To exclude files from coverage, use the following patterns in your test command:
// flutter test --coverage --coverage-skip-symbols-glob '**/*.g.dart,**/*.freezed.dart,**/main.dart,**/generated/**/*,**/l10n/**/*'

import 'package:flutter_test/flutter_test.dart';

void main() {
  // This file exists purely for coverage configuration
  test('coverage configuration file', () {
    expect(true, isTrue);
  });
}
