import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserGoalsScreen extends StatefulWidget {
  @override
  _UserGoalsScreenState createState() => _UserGoalsScreenState();
}

class _UserGoalsScreenState extends State<UserGoalsScreen> {
  List<String> predefinedGoals = [
    'Learn Flutter',
    'Master AI',
    'Improve Communication Skills',
    'Become a Data Scientist',
    'Web Development'
  ];
  List<String> selectedGoals = [];

  Future<void> saveUserGoals() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Check if the user document exists
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        // If the document doesn't exist, create it
        if (!userDoc.exists) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'goals': [],
            'skills': [],
          });
        }

        // Now update the goals field
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'goals': selectedGoals,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Goals Saved!')));
        Navigator.pushReplacementNamed(context, '/skills');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Learning Goals')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Select learning goals:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: predefinedGoals.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(predefinedGoals[index]),
                    onTap: () {
                      setState(() {
                        if (selectedGoals.contains(predefinedGoals[index])) {
                          selectedGoals.remove(predefinedGoals[index]);
                        } else {
                          selectedGoals.add(predefinedGoals[index]);
                        }
                      });
                    },
                    selected: selectedGoals.contains(predefinedGoals[index]),
                  );
                },
              ),
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: selectedGoals.map((goal) => Chip(label: Text(goal))).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: saveUserGoals,
              child: Text('Save Goals'),
            ),
          ],
        ),
      ),
    );
  }
}
class UserSkillsScreen extends StatefulWidget {
  @override
  _UserSkillsScreenState createState() => _UserSkillsScreenState();
}

class _UserSkillsScreenState extends State<UserSkillsScreen> {
  List<String> predefinedSkills = [
    'Dart',
    'Python',
    'Machine Learning',
    'Public Speaking',
    'React'
  ];
  List<String> selectedSkills = [];

  Future<void> saveUserSkills() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Check if the user document exists
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        // If the document doesn't exist, create it
        if (!userDoc.exists) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'goals': [],
            'skills': [],
          });
        }

        // Now update the skills field
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'skills': selectedSkills,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Skills Saved!')));
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Skills')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Select skills to learn:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: predefinedSkills.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(predefinedSkills[index]),
                    onTap: () {
                      setState(() {
                        if (selectedSkills.contains(predefinedSkills[index])) {
                          selectedSkills.remove(predefinedSkills[index]);
                        } else {
                          selectedSkills.add(predefinedSkills[index]);
                        }
                      });
                    },
                    selected: selectedSkills.contains(predefinedSkills[index]),
                  );
                },
              ),
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: selectedSkills.map((skill) => Chip(label: Text(skill))).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: saveUserSkills,
              child: Text('Save Skills'),
            ),
          ],
        ),
      ),
    );
  }
}