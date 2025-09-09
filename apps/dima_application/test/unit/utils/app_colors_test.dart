import 'package:dima_application/Utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_setup.dart';

void main() {
  configureTestEnvironment();

  group('AppColors', () {
    test('has correct color values', () {
      expect(AppColors.currentPlan, Colors.green);
      expect(AppColors.modifyAction, Colors.amber);
      expect(AppColors.deleteAction, Colors.red);
    });

    test('all colors are accessible', () {
      expect(AppColors.currentPlan, isA<Color>());
      expect(AppColors.modifyAction, isA<Color>());
      expect(AppColors.deleteAction, isA<Color>());
    });

    test('colors have correct values', () {
      expect(AppColors.currentPlan.value, Colors.green.value);
      expect(AppColors.modifyAction.value, Colors.amber.value);
      expect(AppColors.deleteAction.value, Colors.red.value);
    });
  });
}
