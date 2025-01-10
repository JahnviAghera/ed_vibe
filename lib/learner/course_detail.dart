import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CourseDetailPage extends StatefulWidget {
  final String courseId;
  final String userId;

  const CourseDetailPage({Key? key, required this.courseId, required this.userId}) : super(key: key);

  @override
  _CourseDetailPageState createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  late DatabaseReference _courseRef;
  late DatabaseReference _userRef;

  Map<String, dynamic> course = {};
  bool isEnrolled = false;

  @override
  void initState() {
    super.initState();
    _courseRef = _dbRef.child('courses').child(widget.courseId);
    _userRef = _dbRef.child('users').child(widget.userId);
    fetchCourseDetails();
  }

  Future<void> fetchCourseDetails() async {
    // Fetch course details from Firebase
    final courseSnapshot = await _courseRef.get();
    if (courseSnapshot.exists) {
      setState(() {
        course = Map<String, dynamic>.from(courseSnapshot.value as Map);
      });
    }

    // Check if the user is already enrolled in this course
    final userSnapshot = await _userRef.get();
    if (userSnapshot.exists) {
      final userData = Map<String, dynamic>.from(userSnapshot.value as Map);
      setState(() {
        isEnrolled = userData['enrolledCourses']?.contains(widget.courseId) ?? false;
      });
    }
  }

  Future<void> enrollInCourse() async {
    // Enroll the user in the course by updating Firebase
    await _userRef.update({
      'enrolledCourses': FieldValue.arrayUnion([widget.courseId])
    });
    setState(() {
      isEnrolled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course['title'] ?? 'Course Details'),
      ),
      body: course.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/example.png',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              // Course Title and Description
              Text(
                course['title'] ?? 'Course Title',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                course['description'] ?? 'Course description goes here.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              // Instructor Information
              Text(
                'Instructor: ${course['instructor'] ?? 'Instructor Name'}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Duration: ${course['duration'] ?? 'N/A'}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              // Enrollment Button
              ElevatedButton(
                onPressed: isEnrolled
                    ? null // Disable if already enrolled
                    : enrollInCourse,
                style: ElevatedButton.styleFrom(

                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  isEnrolled ? 'Enrolled' : 'Enroll Now',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
