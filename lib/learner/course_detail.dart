import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CoursePage extends StatefulWidget {
  final String courseId;
  final String userId;

  CoursePage({required this.courseId, required this.userId});

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  Map<String, dynamic>? course;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch course data from Firebase on page load
    _fetchCourseData();
  }

  // Fetch course data from Firebase
  Future<void> _fetchCourseData() async {
    final courseRef = FirebaseDatabase.instance.ref().child('courses/${widget.courseId}');
    try {
      final snapshot = await courseRef.get();
      if (snapshot.exists) {
        setState(() {
          course = Map<String, dynamic>.from(snapshot.value as Map);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Course not found!')));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load course data')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Course Details')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (course == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Course Details')),
        body: Center(child: Text('Course data is missing or not loaded')),
      );
    }

    final String courseTitle = course?['title'] ?? 'Course'; // Default to 'Course' if null
    final String courseDescription = course?['description'] ?? 'Course description goes here.'; // Default if null
    final String? courseImageUrl = course?['imageUrl'];

    return Scaffold(
      appBar: AppBar(title: Text(courseTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Course Image (if exists)
            if (courseImageUrl != null && courseImageUrl.isNotEmpty)
              Image.network(courseImageUrl, height: 200, width: double.infinity, fit: BoxFit.cover)
            else
              Image.asset('assets/example.png', height: 200, width: double.infinity, fit: BoxFit.cover),
            SizedBox(height: 16),
            // Course Title and Description
            Text(
              courseTitle,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              courseDescription,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            // Enroll Button
            ElevatedButton(
              onPressed: () async {
                final userCoursesRef = FirebaseDatabase.instance.ref().child('users/${widget.userId}/courses/${widget.courseId}');

                try {
                  await userCoursesRef.set(true);  // Mark the course as enrolled
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You have enrolled in the course!')));
                  Navigator.pop(context); // Go back to the previous screen
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to enroll in the course.')));
                }
              },
              child: Text('Enroll Now'),
            ),
          ],
        ),
      ),
    );
  }
}
