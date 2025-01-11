import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yt/learner/course_detail.dart';
import 'package:yt/learner/dashboard.dart';
import 'package:yt/learner/recommendation.dart';
import 'package:yt/learner/search.dart';
import 'package:yt/learner/signin.dart';
import 'package:yt/learner/signup.dart';
import 'package:yt/learner/user_preferences.dart';
// import 'sign_in_widget.dart';
// import 'sign_up_widget.dart';
// import 'admin_dashboard_screen.dart';
// import 'user_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EdVibe',
      initialRoute: '/sign-in',
      routes: {
        // '/': (context) => SignInWidget(),
        '/': (context) => Dashboard(),
        '/sign-up': (context) => SignUpScreen(), // For Admin sign up
        '/sign-in': (context) => SignInScreen(), // For Admin sign up
        '/pref': (context) => UserGoalsScreen(),
        '/skills': (context) => UserSkillsScreen(),
        '/search': (context) => SearchScreen(),
        // '/recommendations': (context) => const RecommendationScreen(),
        // '/courseDetail': (context) => const CourseDetailPage(courseId: courseId, userId: userId),
        // '/myCourses': (context) => const MyCoursesScreen(),
        // '/recommend': (context) => SeeAllRecommendations(courses: courses, user: user),
        // '/signUpStudent': (context) => SignUpWidget(), // For Student sign up
        // '/adminDashboard': (context) => AdminDashboardScreen(),
        // '/userDashboard': (context) => UserDashboardScreen(),
      },
    );
  }
}
