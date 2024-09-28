// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// ignore: camel_case_types
class editscreen extends StatefulWidget {
  const editscreen({super.key});

  @override
  _editscreenState createState() => _editscreenState();
}

// ignore: camel_case_types
class _editscreenState extends State<editscreen> {
  final box = Hive.box('userProfile');

  // Text editing controllers for user inputs
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController activityLevelController = TextEditingController();
  final TextEditingController goalController = TextEditingController();
  final TextEditingController targetWeightController = TextEditingController();
  final TextEditingController weeklyGoalController = TextEditingController();
  final TextEditingController dietTypeController = TextEditingController();
  final TextEditingController additionalNotesController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with existing data
    ageController.text = box.get('age')?.toString() ?? '';
    genderController.text = box.get('gender') ?? '';
    heightController.text = box.get('height')?.toString() ?? '';
    weightController.text = box.get('weight')?.toString() ?? '';
    activityLevelController.text = box.get('activityLevel') ?? '';
    goalController.text = box.get('goal') ?? '';
    targetWeightController.text = box.get('targetWeight')?.toString() ?? '';
    weeklyGoalController.text = box.get('weeklyGoal')?.toString() ?? '';
    dietTypeController.text = box.get('dietType') ?? '';
    additionalNotesController.text = box.get('additionalNotes') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile Goals'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField('Age', ageController),
            _buildTextField('Gender', genderController),
            _buildTextField('Height', heightController),
            _buildTextField('Weight', weightController),
            _buildTextField('Activity Level', activityLevelController),
            _buildTextField('Health Goal', goalController),
            _buildTextField('Target Weight', targetWeightController),
            _buildTextField('Weekly Goal', weeklyGoalController),
            _buildTextField('Diet Type', dietTypeController),
            _buildTextField('Additional Notes', additionalNotesController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfileGoals,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _saveProfileGoals() {
    // Save the data to Hive
    box.put('age', int.tryParse(ageController.text));
    box.put('gender', genderController.text);
    box.put('height', double.tryParse(heightController.text));
    box.put('weight', double.tryParse(weightController.text));
    box.put('activityLevel', activityLevelController.text);
    box.put('goal', goalController.text);
    box.put('targetWeight', int.tryParse(targetWeightController.text));
    box.put('weeklyGoal', int.tryParse(weeklyGoalController.text));
    box.put('dietType', dietTypeController.text);
    box.put('additionalNotes', additionalNotesController.text);

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile and Goals updated successfully!')),
    );

    // Navigate back to ProfilePage
    Navigator.pop(context);
  }
}
