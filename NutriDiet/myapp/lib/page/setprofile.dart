// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/page/sset_goal.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _gender = 'Male';
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _allergiesController = TextEditingController();
  String _foodPreference = 'No Preference';
  String _activityLevel = 'Moderate';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title:
            const Text('Profile Setup', style: TextStyle(color: Colors.white)),
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
                  'Let\'s create your healthy profile!',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _nameController,
                  labelText: 'Name',
                  prefixIcon: Icons.person,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 16),
                _buildGenderSelection(),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _ageController,
                  labelText: 'Age',
                  prefixIcon: Icons.cake,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your age' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _heightController,
                  labelText: 'Height (cm)',
                  prefixIcon: Icons.height,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your height' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _weightController,
                  labelText: 'Weight (kg)',
                  prefixIcon: FontAwesomeIcons.weightScale,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your weight' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _allergiesController,
                  labelText: 'Allergies (comma-separated)',
                  prefixIcon: Icons.warning,
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  value: _foodPreference,
                  items: [
                    'No Preference',
                    'Vegetarian',
                    'Vegan',
                    'Pescatarian'
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _foodPreference = newValue!;
                    });
                  },
                  labelText: 'Food Preference',
                  prefixIcon: Icons.restaurant_menu,
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  value: _activityLevel,
                  items: [
                    'Sedentary',
                    'Lightly Active',
                    'Moderate',
                    'Very Active',
                    'Extremely Active'
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _activityLevel = newValue!;
                    });
                  },
                  labelText: 'Activity Level',
                  prefixIcon: Icons.directions_run,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green[700],
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Continue to Goal Setup',
                      style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
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
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gender',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Row(
          children: [
            Radio(
              value: 'Male',
              groupValue: _gender,
              onChanged: (value) {
                setState(() {
                  _gender = value.toString();
                });
              },
              activeColor: Colors.green[700],
            ),
            const Text('Male'),
            Radio(
              value: 'Female',
              groupValue: _gender,
              onChanged: (value) {
                setState(() {
                  _gender = value.toString();
                });
              },
              activeColor: Colors.green[700],
            ),
            const Text('Female'),
          ],
        ),
      ],
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

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Save data to Hive
      final box = Hive.box('userProfile');
      box.put('name', _nameController.text);
      box.put('gender', _gender);
      box.put('age', int.parse(_ageController.text));
      box.put('height', double.parse(_heightController.text));
      box.put('weight', double.parse(_weightController.text));
      box.put('allergies', _allergiesController.text);
      box.put('foodPreference', _foodPreference);
      box.put('activityLevel', _activityLevel);

      // Navigate to Goal Setup Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const GoalSetupScreen(),
        ),
      );
    }
  }
}

// class GoalSetupScreen extends StatefulWidget {
//   const GoalSetupScreen({super.key});

//   @override
//   _GoalSetupScreenState createState() => _GoalSetupScreenState();
// }

// class _GoalSetupScreenState extends State<GoalSetupScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String _goal = 'Weight Loss';
//   final _targetWeightController = TextEditingController();
//   final _weeklyGoalController = TextEditingController();
//   String _dietType = 'Balanced';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Set Your Goals'),
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'What are your health goals?',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text('Primary Goal', style: TextStyle(fontSize: 16)),
//                 DropdownButtonFormField<String>(
//                   value: _goal,
//                   items: [
//                     'Weight Loss',
//                     'Weight Gain',
//                     'Maintain Weight',
//                     'Improve Fitness'
//                   ].map((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _goal = newValue!;
//                     });
//                   },
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _targetWeightController,
//                   decoration: const InputDecoration(
//                     labelText: 'Target Weight (kg)',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your target weight';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _weeklyGoalController,
//                   decoration: const InputDecoration(
//                     labelText: 'Weekly Goal (kg)',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your weekly goal';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 const Text('Preferred Diet Type',
//                     style: TextStyle(fontSize: 16)),
//                 DropdownButtonFormField<String>(
//                   value: _dietType,
//                   items: [
//                     'Balanced',
//                     'Low-carb',
//                     'High-protein',
//                     'Mediterranean'
//                   ].map((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _dietType = newValue!;
//                     });
//                   },
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       // Save goal data to Hive
//                       final box = Hive.box('userProfile');
//                       box.put('goal', _goal);
//                       box.put('targetWeight',
//                           double.parse(_targetWeightController.text));
//                       box.put('weeklyGoal',
//                           double.parse(_weeklyGoalController.text));
//                       box.put('dietType', _dietType);

//                       // Navigate to the main app screen or dashboard
//                       // For now, we'll just show a success message
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                             content: Text('Goals saved successfully!')),
//                       );
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size(double.infinity, 50),
//                   ),
//                   child: const Text('Save Goals'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }











// // ignore_for_file: library_private_types_in_public_api, unused_field

// import 'package:flutter/material.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//   String _name = '';
//   int _age = 0;
//   double _weight = 0.0;
//   double _height = 0.0;
//   String _gender = 'Male';
//   String _activityLevel = 'Sedentary';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Profile'),
//         backgroundColor: Colors.green,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Name',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your name';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) => _name = value!,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Age',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your age';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) => _age = int.parse(value!),
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Weight (kg)',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your weight';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) => _weight = double.parse(value!),
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Height (cm)',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your height';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) => _height = double.parse(value!),
//               ),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   labelText: 'Gender',
//                   border: OutlineInputBorder(),
//                 ),
//                 value: _gender,
//                 items: ['Male', 'Female', 'Other']
//                     .map((label) => DropdownMenuItem(
//                           value: label,
//                           child: Text(label),
//                         ))
//                     .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _gender = value!;
//                   });
//                 },
//               ),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   labelText: 'Activity Level',
//                   border: OutlineInputBorder(),
//                 ),
//                 value: _activityLevel,
//                 items: [
//                   'Sedentary',
//                   'Lightly Active',
//                   'Moderately Active',
//                   'Very Active',
//                   'Extra Active'
//                 ]
//                     .map((label) => DropdownMenuItem(
//                           value: label,
//                           child: Text(label),
//                         ))
//                     .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _activityLevel = value!;
//                   });
//                 },
//               ),
//               const SizedBox(height: 24),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       _formKey.currentState!.save();
//                       // TODO: Save profile data and navigate to next screen
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //       builder: (context) => GoalSetupPage()),
//                       // );
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 50, vertical: 15),
//                   ),
//                   child: const Text('Save Profile'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
