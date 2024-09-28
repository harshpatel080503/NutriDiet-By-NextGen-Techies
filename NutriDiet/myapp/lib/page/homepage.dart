// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';

// class CalorieTargetCard extends StatelessWidget {
//   final String dailyTarget;

//   const CalorieTargetCard({super.key, required this.dailyTarget});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             CircularProgressIndicator(
//               value: 0.7,
//               strokeWidth: 8,
//               backgroundColor: Colors.grey[200],
//               valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
//             ),
//             const SizedBox(width: 16),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('Daily Calorie Target',
//                     style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 4),
//                 Text('$dailyTarget calories',
//                     style: const TextStyle(fontSize: 20, color: Colors.green)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MacronutrientBreakdownCard extends StatelessWidget {
//   final Map<dynamic, dynamic> macros;

//   const MacronutrientBreakdownCard({Key? key, required this.macros})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Macronutrient Breakdown',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 MacroIndicator(
//                     label: 'Protein',
//                     value: macros['Protein']!,
//                     color: Colors.red[400]!),
//                 MacroIndicator(
//                     label: 'Carbs',
//                     value: macros['Carbohydrates']!,
//                     color: Colors.blue[400]!),
//                 MacroIndicator(
//                     label: 'Fats',
//                     value: macros['Fats']!,
//                     color: Colors.yellow[700]!),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MacroIndicator extends StatelessWidget {
//   final String label;
//   final String value;
//   final Color color;

//   MacroIndicator({
//     Key? key,
//     required this.label,
//     required this.value,
//     required this.color,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: 60,
//           height: 60,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: color.withOpacity(0.2),
//           ),
//           child: Center(
//             child: Text(
//               '$value g',
//               style: TextStyle(
//                   fontSize: 14, fontWeight: FontWeight.bold, color: color),
//             ),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(label, style: const TextStyle(fontSize: 14)),
//       ],
//     );
//   }
// }

// class MacronutrientPieChart extends StatelessWidget {
//   final Map<dynamic, dynamic> macros;

//   const MacronutrientPieChart({Key? key, required this.macros})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Macronutrient Breakdown',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Container(
//               height: 200,
//               child: PieChart(
//                 PieChartData(
//                   sectionsSpace: 0,
//                   centerSpaceRadius: 40,
//                   sections: [
//                     PieChartSectionData(
//                       color: Colors.red,
//                       value: macros['Protein']!,
//                       title: 'Protein',
//                       radius: 50,
//                       titleStyle: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ),
//                     PieChartSectionData(
//                       color: Colors.blue,
//                       value: macros['Carbohydrates']!.toDouble(),
//                       title: 'Carbs',
//                       radius: 50,
//                       titleStyle: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ),
//                     PieChartSectionData(
//                       color: Colors.yellow,
//                       value: macros['Fats']!.toDouble(),
//                       title: 'Fats',
//                       radius: 50,
//                       titleStyle: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MealPlanCard extends StatelessWidget {
//   final Map<dynamic, dynamic> mealPlan;

//   MealPlanCard({Key? key, required this.mealPlan}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Meal Plan',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             ...mealPlan.entries
//                 .map((entry) => Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             width: 80,
//                             child: Text(entry.key,
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold)),
//                           ),
//                           Expanded(
//                             child: Text(entry.value),
//                           ),
//                         ],
//                       ),
//                     ))
//                 .toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class TipsCard extends StatelessWidget {
//   final List<dynamic> tips;

//   TipsCard({Key? key, required this.tips}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('General Tips',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             ...tips
//                 .map((tip) => Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4.0),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Icon(Icons.check_circle,
//                               color: Colors.green, size: 20),
//                           const SizedBox(width: 8),
//                           Expanded(child: Text(tip)),
//                         ],
//                       ),
//                     ))
//                 .toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }
