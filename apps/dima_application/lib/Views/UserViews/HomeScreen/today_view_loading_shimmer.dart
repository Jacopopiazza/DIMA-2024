import 'package:dima_application/Views/UserViews/HomeScreen/meal_card.dart';
import 'package:dima_application/Views/UserViews/HomeScreen/progress_card.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkMode ? Colors.grey[850]! : Colors.grey[300]!;
    final highlightColor = isDarkMode ? Colors.grey[700]! : Colors.grey[100]!;
    final titleStyle = Theme.of(context).textTheme.headlineSmall ??
        const TextStyle(fontSize: 24);
    final titleHeight = titleStyle.fontSize! * (titleStyle.height ?? 1.2);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProgressCard(isLoading: true),
          const SizedBox(height: 24),
          Container(
            width: 200,
            height: titleHeight,
            color: baseColor,
            margin: const EdgeInsets.only(bottom: 8.0),
          ),
          MealCard.loading(context),
          MealCard.loading(context),
          MealCard.loading(context),
        ],
      ),
    );
  }
}