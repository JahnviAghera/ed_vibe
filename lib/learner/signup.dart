import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

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

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _signUpWithEmailPassword() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacementNamed(context, '/pref');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User Created!')));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Error')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signUpWithGoogle() async {
    try {
      setState(() {
        _isLoading = true;
      });

      User? user = await signInWithGoogle();
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google Sign-In successful')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP sent to $phoneNumber')));
        _verifyPhone(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto retrieval timeout
      },
    );
  }

  Future<void> _verifyPhone(String verificationId) async {
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
                  verificationId: verificationId,
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
      appBar: AppBar(title: Text('Sign Up'),
      automaticallyImplyLeading: false,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email/Password SignUp
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
              onPressed: _signUpWithEmailPassword,
              child: Text('Sign Up with Email'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _signUpWithGoogle,
              child: Text('Sign Up with Google'),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: (){
                Navigator.pushReplacementNamed(context, '/sign-in');
              },
              child: Text('Already have an account? Login'),
            ),
            // Phone Number Input
            // TextField(
            //   controller: _phoneController,
            //   decoration: InputDecoration(labelText: 'Phone Number'),
            //   keyboardType: TextInputType.phone,
            //   onSubmitted: (phoneNumber) => signInWithPhone(phoneNumber),
            // ),
          ],
        ),
      ),
    );
  }
}