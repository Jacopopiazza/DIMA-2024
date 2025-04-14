// lib/providers/isar_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

/// Provider for the global Isar database instance
/// 
/// This provider must be overridden in main.dart with an actual Isar instance.
/// It will throw an error if accessed before being properly initialized.
/// 
/// Usage example in main.dart:
/// ```dart
/// void main() async {
///   // Initialize Isar
///   final isar = await Isar.open([
///     MealPlanSchema,
///     DailyCompletionSchema,
///     // other schemas...
///   ]);
///   
///   // Override the provider
///   runApp(
///     ProviderScope(
///       overrides: [
///         isarProvider.overrideWithValue(isar),
///       ],
///       child: MyApp(),
///     ),
///   );
/// }
/// ```
final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('isarProvider was not overridden');
});