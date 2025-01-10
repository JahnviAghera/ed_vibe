import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String _verificationId = "";

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signInWithEmailPassword() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacementNamed(context, '/');
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User Signed In!')));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Error')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> signInWithPhone(String phoneNumber) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Phone number automatically verified')));
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Verification failed: ${e.message}')));
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP sent to $phoneNumber')));
        _showOtpDialog();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto retrieval timeout
      },
    );
  }

  void _showOtpDialog() {
    TextEditingController otpController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter OTP'),
          content: Column(
            children: [
              TextField(
                controller: otpController,
                decoration: InputDecoration(hintText: 'Enter OTP'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final credential = PhoneAuthProvider.credential(
                  verificationId: _verificationId,
                  smsCode: otpController.text,
                );

                try {
                  await FirebaseAuth.instance.signInWithCredential(credential);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Phone number verified')));
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to verify OTP')));
                }
              },
              child: Text('Verify'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In'),automaticallyImplyLeading: false,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email/Password Sign-In
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: signInWithEmailPassword,
              child: Text('Sign In with Email'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: signInWithGoogle,
              child: Text('Sign In with Google'),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: (){
                Navigator.pushReplacementNamed(context, '/sign-up');
              },
              child: Text('Dont have an account? Register'),
            )
            // Phone Number Input
            // TextField(
            //   controller: _phoneController,
            //   decoration: InputDecoration(labelText: 'Phone Number'),
            //   keyboardType: TextInputType.phone,
            //   onSubmitted: (phoneNumber) {
            //     signInWithPhone(phoneNumber);
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}