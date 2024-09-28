// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:myapp/page/homepage.dart';
import 'package:myapp/page/homepage2.dart';
import 'package:myapp/page/search.dart';

class FinalHome extends StatefulWidget {
  const FinalHome({super.key});

  @override
  _FinalHomeState createState() => _FinalHomeState();
}

class _FinalHomeState extends State<FinalHome> {
  final PageController _pageController = PageController(); // For page switching
  int _selectedIndex = 0; // Current index for BottomNavigationBar

  final dietPlansBox = Hive.box('userProfile');

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index); // Navigate to the selected page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics:
            const NeverScrollableScrollPhysics(), // Disable swipe navigation
        children: [
          const homescreen(), // Home page content (your original content)
          SearchPage(), // Replace with your Search page content
          HistoryPage(), // Replace with your History page content
          const ProfilePage(), // Replace with your Profile page content
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        // print(Hive.box('userProfile').get("plan"));

        dynamic value = Hive.box('userProfile').get('plan');
        print(value['General Tips']);
      }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// class HomePage extends StatelessWidget {
//   final dietPlansBox = Hive.box('userProfile');
//   final latestPlan = Hive.box('userProfile').get('plan', defaultValue: {
//     "Daily Calorie Target": 2500,
//     "Macronutrient Breakdown": {
//       "Protein": 150,
//       "Carbohydrates": 300,
//       "Fats": 80,
//     },
//     "Meal Plan": {
//       "Breakfast": "Oatmeal with fruits - 300 calories",
//       "Lunch": "Chicken and Vegetable Stir-Fry - 500 calories",
//       "Dinner": "Salmon with Roasted Vegetables - 600 calories",
//       "Snack": "Greek yogurt with berries - 200 calories"
//     },
//     "General Tips": [
//       "Drink plenty of water throughout the day.",
//       "Aim for a variety of fruits and vegetables in your meals.",
//       "Choose lean protein sources and healthy fats."
//     ]
//   });

//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       slivers: [
//         SliverAppBar(
//           expandedHeight: 120,
//           floating: false,
//           pinned: true,
//           flexibleSpace: FlexibleSpaceBar(
//             title: const Text('Daily Analysis',
//                 style: TextStyle(color: Colors.black)),
//             background: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [Colors.green[100]!, Colors.green[50]!],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SliverToBoxAdapter(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[600]),
//                 ),
//                 const SizedBox(height: 16),
//                 CalorieTargetCard(
//                     dailyTarget: latestPlan['Daily Calorie Target'].toString()),
//                 const SizedBox(height: 16),
//                 MacronutrientBreakdownCard(
//                     macros: latestPlan['Macronutrient Breakdown']),
//                 const SizedBox(height: 16),
//                 MacronutrientPieChart(
//                     macros: latestPlan['Macronutrient Breakdown']),
//                 const SizedBox(height: 16),
//                 MealPlanCard(mealPlan: latestPlan['Meal Plan']),
//                 const SizedBox(height: 16),
//                 TipsCard(tips: latestPlan['General Tips']),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // Placeholder for other pages:
class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Search Page'));
  }
}

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('History Page'));
  }
}
