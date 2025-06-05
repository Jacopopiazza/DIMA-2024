import 'package:dima_application/Views/UserViews/MealScreen/meal_details_view.dart';
import 'package:dima_application/generated/flutter-models/Meal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MealCard extends ConsumerWidget {
  final Meal meal;
  final List<Meal> allMealPlans;

  const MealCard({super.key, required this.meal, required this.allMealPlans});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => MealDetailsDraggablePage(
                  meal: meal,
                  allMealPlans: allMealPlans,
                ),
          ),
        );
      },
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                meal.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
