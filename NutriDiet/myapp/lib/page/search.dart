import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myapp/page/goal.dart';
import 'package:myapp/page/sset_goal.dart'; // Ensure this import points to your GoalSetupScreen file

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('userProfile');

    // Retrieve user data from Hive
    final age = box.get('age')?.toString() ?? 'N/A';
    final gender = box.get('gender') ?? 'N/A';
    final height = box.get('height')?.toString() ?? 'N/A';
    final weight = box.get('weight')?.toString() ?? 'N/A';
    final activityLevel = box.get('activityLevel') ?? 'N/A';
    final goal = box.get('goal') ?? 'N/A';
    final targetWeight = box.get('targetWeight')?.toString() ?? 'N/A';
    final weeklyGoal = box.get('weeklyGoal')?.toString() ?? 'N/A';
    final dietType = box.get('dietType') ?? 'N/A';
    final additionalNotes = box.get('additionalNotes') ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileInfo('Age', age),
            _buildProfileInfo('Gender', gender),
            _buildProfileInfo('Height', height),
            _buildProfileInfo('Weight', weight),
            _buildProfileInfo('Activity Level', activityLevel),
            _buildProfileInfo('Health Goal', goal),
            _buildProfileInfo('Target Weight', targetWeight),
            _buildProfileInfo('Weekly Goal', weeklyGoal),
            _buildProfileInfo('Diet Type', dietType),
            _buildProfileInfo('Additional Notes', additionalNotes),
            const SizedBox(height: 20),
            _buildEditButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const editscreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green[700],
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Edit Goals and Profile',
            style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
