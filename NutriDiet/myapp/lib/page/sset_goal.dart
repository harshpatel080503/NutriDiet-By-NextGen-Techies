// ignore_for_file: library_private_types_in_public_api, unused_local_variable, use_build_context_synchronously, unused_element

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive/hive.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/page/gate.dart';
import 'package:myapp/page/setprofile.dart';

class GoalSetupScreen extends StatefulWidget {
  const GoalSetupScreen({super.key});

  @override
  _GoalSetupScreenState createState() => _GoalSetupScreenState();
}

class _GoalSetupScreenState extends State<GoalSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _goal = 'Weight Loss';
  final _targetWeightController = TextEditingController();
  final _weeklyGoalController = TextEditingController();
  final _additionalNotesController = TextEditingController();
  String _dietType = 'Balanced';
  bool isloading = false;

  final box = Hive.box('userProfile');

  Future<void> gonext() async {
    isloading = true;
    setState(() {});
    String prompt = '''
  Create a personalized nutrition plan for one day based on the following user information:

Age: ${box.get("age")}
Gender: ${box.get("gender")}
Height: ${box.get("height")}
Current Weight: ${box.get("weight")}
Activity Level: ${box.get("activityLevel")}
Diet Type: ${box.get("dietType")}
Target Weight: ${box.get("targetWeight")}
Food Preference: ${box.get("foodPreference")}
Allergies: ${box.get("allergies")}
Additional Notes: ${box.get("additionalNotes")}
Output Format:

Daily Calorie Target: [Number] calories
Macronutrient Breakdown:
Protein: [Number only] 
Carbohydrates: [Number only] 
Fats: [Number only] 
Meal Plan:
Lunch: [Dish Name] (Ingredients: [List]) - [Calories]
Dinner: [Dish Name] (Ingredients: [List]) - [Calories]
General Tips:
Tip 1: [Tip]
Tip 2: [Tip]
Tip 3: [Tip]
    ''';

    final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: "AIzaSyCKLL1KxCeuLKh3qsYWWpWYZlryKs422I4",
        generationConfig:
            GenerationConfig(responseMimeType: "application/json"));
    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final data = response.text;
      final jsonData = jsonDecode(data!);
      box.put("plan", jsonData);
      final olddata = box.get("histroy") ?? [];
      final value = [...olddata, jsonData];
      box.put("histroy", value);
      box.put('lastPlanTime', DateTime.now().toIso8601String());
      setState(() {
        isloading = false;
      });
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const LandingPage()),
      // );
    } catch (e) {
      showPopup(context, e.toString());
    }

    // print("start..........");
    // final content = [Content.text(prompt)];
    // final response = await model.generateContent(content);
    // final data = response.text;
    // // print(data);
    // // showPopup(context, data!);
    // final jsonData = jsonDecode(data!);
    // // print(jsonData);

    // box.put("plan", jsonData);
    // final olddata = box.get("histroy") ?? [];
    // final value = [...olddata, jsonData];
    // box.put("histroy", value);
  }

  void showPopup(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Popup'),
          content: SingleChildScrollView(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileSetupScreen()));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title:
            const Text('Set Your Goals', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'What is your primary health goal?',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                const SizedBox(height: 20),
                _buildGoalSelection(),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _targetWeightController,
                  labelText: 'Target Weight (kg)',
                  prefixIcon: FontAwesomeIcons.scaleBalanced,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your target weight' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _weeklyGoalController,
                  labelText: _goal == 'Muscle Gain'
                      ? 'Weekly Muscle Gain Goal (kg)'
                      : 'Weekly Weight Change Goal (kg)',
                  prefixIcon: FontAwesomeIcons.chartLine,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your weekly goal' : null,
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  value: _dietType,
                  items: [
                    'Balanced',
                    'Low-carb',
                    'High-protein',
                    'Mediterranean'
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _dietType = newValue!;
                    });
                  },
                  labelText: 'Preferred Diet Type',
                  prefixIcon: FontAwesomeIcons.utensils,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _additionalNotesController,
                  labelText: 'Additional Notes or Goals',
                  prefixIcon: FontAwesomeIcons.noteSticky,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                isloading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _saveGoals,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green[700],
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Save Goals and Start Journey',
                            style: TextStyle(fontSize: 18)),
                      ),
                const SizedBox(height: 16),
                _buildMotivationalCard(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        print(Hive.box("userProfile").get("plan"));
        // print(Hive.box("userProfile").get("plan"));
      }),
    );
  }

  Widget _buildGoalSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select your goal:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: [
            _buildGoalChip('Weight Loss', FontAwesomeIcons.weightScale),
            _buildGoalChip('Weight Gain', FontAwesomeIcons.plus),
            _buildGoalChip('Muscle Gain', FontAwesomeIcons.dumbbell),
            _buildGoalChip('Maintain Weight', FontAwesomeIcons.equals),
          ],
        ),
      ],
    );
  }

  Widget _buildGoalChip(String label, IconData icon) {
    return ChoiceChip(
      label: Text(label),
      selected: _goal == label,
      onSelected: (bool selected) {
        setState(() {
          _goal = selected ? label : _goal;
        });
      },
      avatar: Icon(icon, size: 18),
      selectedColor: Colors.green[200],
      backgroundColor: Colors.white,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int? maxLines,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon, color: Colors.green[700]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines ?? 1,
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String labelText,
    required IconData prefixIcon,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon, color: Colors.green[700]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildMotivationalCard() {
    return Card(
      elevation: 4,
      color: Colors.green[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Stay Motivated!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Your health journey is important. Remember to celebrate small victories!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _saveGoals() {
    if (_formKey.currentState!.validate()) {
      box.put("targetWeight", _targetWeightController.text);
      box.put("weeklyGoal", _weeklyGoalController.text);
      box.put("dietType", _dietType);
      box.put("additionalNotes", _additionalNotesController.text);
      gonext();
      // Optionally navigate to the next screen after saving goals
      // Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
    }
  }
}
