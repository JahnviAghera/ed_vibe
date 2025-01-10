import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'sign_in_widget.dart';
import 'sign_up_widget.dart';
import 'admin_dashboard_screen.dart';
import 'user_dashboard_screen.dart';

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
      title: 'Firebase Auth App',
      initialRoute: '/',
      routes: {
        '/': (context) => SignInWidget(),
        '/signUpAdmin': (context) => SignUpWidget(), // For Admin sign up
        '/signUpStudent': (context) => SignUpWidget(), // For Student sign up
        '/adminDashboard': (context) => AdminDashboardScreen(),
        '/userDashboard': (context) => UserDashboardScreen(),
      },
    );
  }
}
