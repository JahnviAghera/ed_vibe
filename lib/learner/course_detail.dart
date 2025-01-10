import 'package:flutter/material.dart';

class CourseDetailPage extends StatelessWidget {
  final String courseId;
  final String userId;

  // Constructor to accept courseId and userId
  const CourseDetailPage({
    Key? key,
    required this.courseId,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course ID: $courseId',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'User ID: $userId',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),
            // Add your course details content here
            Text(
              'Course Content will be displayed here.',
              style: TextStyle(fontSize: 14),
            ),
            // You can add more widgets to display the course content.
          ],
        ),
      ),
    );
  }
}
