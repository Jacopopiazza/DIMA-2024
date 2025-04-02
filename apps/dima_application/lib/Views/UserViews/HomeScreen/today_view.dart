import 'package:flutter/material.dart';
import 'meal_card.dart'; // Import the MealCard widget
import 'progress_card.dart'; // Import the ProgressCard widget

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  // Placeholder URLs - Replace with your actual image sources or assets
  final String lunchImageUrl =
      'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1887&q=80'; // Salad example
  final String dinnerImageUrl =
      'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80'; // Bowl example

  @override
  Widget build(BuildContext context) {
    // Data placeholders - replace with actual data source/state management
    const String currentCalories = '1,284';
    const double fatProgress = 0.28;
    const double proteinProgress = 0.65;
    const double carbProgress = 0.85;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Use the new ProgressCard widget
            ProgressCard(
              calories: currentCalories,
              fatPercent: fatProgress,
              proteinPercent: proteinProgress,
              carbPercent: carbProgress,
              onViewMorePressed: () {
                // Handle View More action
                print("View More Tapped!");
              },
            ),
            const SizedBox(height: 20),
            // Use the new MealCard widget
            MealCard(
              title: 'Lunch',
              imageUrl: lunchImageUrl,
              onTap: () {
                 // Handle Lunch Card tap
                 print("Lunch Card Tapped!");
              }
            ),
            const SizedBox(height: 20),
            // Use the new MealCard widget
            MealCard(
              title: 'Dinner',
              imageUrl: dinnerImageUrl,
               onTap: () {
                 // Handle Dinner Card tap
                 print("Dinner Card Tapped!");
              }
            ),
            const SizedBox(height: 20), // Add some space at the bottom
          ],
        ),
      ),
    );
  }
}