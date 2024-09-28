// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart'; // Add this import

class homescreen extends StatefulWidget {
  const homescreen({super.key});

  @override
  _homescreenState createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  final dietPlansBox = Hive.box('userProfile');

  // Define your default plan here
  Map<dynamic, dynamic> latestPlan = {
    "Daily Calorie Target": 2500,
    "Macronutrient Breakdown": {
      "Protein": 125,
      "Carbohydrates": 375,
      "Fats": 80,
    },
    "Meal Plan": {
      "Lunch": "Vegetarian Chili - 500 calories",
      "Dinner": "Lentil Curry - 600 calories",
    },
    "General Tips": [
      "Stay hydrated by drinking plenty of water throughout the day.",
      "Incorporate a variety of fruits and vegetables into your diet.",
      "Choose whole grain options over refined grains."
    ]
  };

  @override
  void initState() {
    super.initState();
    fetchPlanFromHive();
  }

  Future<void> fetchPlanFromHive() async {
    // Simulating a delay as if fetching data
    await Future.delayed(const Duration(seconds: 1));
    // Check if the data exists in Hive and fetch it
    if (dietPlansBox.isNotEmpty) {
      final plan = dietPlansBox.get('plan');
      if (plan != null) {
        setState(() {
          latestPlan = plan; // Update the latestPlan with fetched data
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 120,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('Daily Analysis',
                style: TextStyle(color: Colors.black)),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.green[100]!, Colors.green[50]!],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                CalorieTargetCard(
                    dailyTarget: latestPlan['Daily Calorie Target'].toString()),
                const SizedBox(height: 16),
                MacronutrientBreakdownCard(
                  macros: Map<String, dynamic>.from(
                      latestPlan['Macronutrient Breakdown']),
                ),
                const SizedBox(height: 16),
                MacronutrientPieChart(
                  macros: Map<String, dynamic>.from(
                      latestPlan['Macronutrient Breakdown']),
                ),
                const SizedBox(height: 16),
                MealPlanCard(
                  mealPlan: Map<String, dynamic>.from(latestPlan['Meal Plan']),
                ),
                const SizedBox(height: 16),
                TipsCard(
                  tips: latestPlan['General Tips'],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Placeholder classes for the components, replace these with your actual implementations.
class CalorieTargetCard extends StatelessWidget {
  final String dailyTarget;
  const CalorieTargetCard({super.key, required this.dailyTarget});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Daily Calorie Target: $dailyTarget calories'),
      ),
    );
  }
}

class MacronutrientBreakdownCard extends StatelessWidget {
  final Map<String, dynamic> macros;
  const MacronutrientBreakdownCard({super.key, required this.macros});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Macronutrient Breakdown:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Protein: ${macros['Protein']}g'),
            Text('Carbohydrates: ${macros['Carbohydrates']}g'),
            Text('Fats: ${macros['Fats']}g'),
          ],
        ),
      ),
    );
  }
}

class MacronutrientPieChart extends StatelessWidget {
  final Map<String, dynamic> macros;
  const MacronutrientPieChart({super.key, required this.macros});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 200,
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                color: Colors.blue,
                value: macros['Protein'].toDouble(),
                title: 'Protein\n${macros['Protein']}g',
              ),
              PieChartSectionData(
                color: Colors.green,
                value: macros['Carbohydrates'].toDouble(),
                title: 'Carbs\n${macros['Carbohydrates']}g',
              ),
              PieChartSectionData(
                color: Colors.orange,
                value: macros['Fats'].toDouble(),
                title: 'Fats\n${macros['Fats']}g',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MealPlanCard extends StatelessWidget {
  final Map<String, dynamic> mealPlan;
  const MealPlanCard({super.key, required this.mealPlan});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Meal Plan:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...mealPlan.entries
                .map((entry) => Text('${entry.key}: ${entry.value}'))
                .toList(),
          ],
        ),
      ),
    );
  }
}

class TipsCard extends StatelessWidget {
  // final dynamic tips;
  dynamic tips = {};

  TipsCard({super.key, this.tips});
  // const TipsCard({super.key, required this.tips});

  @override
  Widget build(BuildContext context) {
    tips = Hive.box('userProfile').get('plan');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'General Tips:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            OutlinedButton(
                onPressed: () {
                  print(tips);
                  print(tips.runtimeType);
                },
                child: Text("data")),
          ],
        ),
      ),
    );
  }
}
