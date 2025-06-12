import 'package:isar/isar.dart';

class MealPlansListService {
  final Isar isar;
  static const Duration _cacheValidityDuration = Duration(hours: 24);

  MealPlansListService({required this.isar});
}
