import 'dart:async';
import 'package:flutter/material.dart';
import 'package:service_app/screens/authentication/auth_page.dart';
import 'package:service_app/session_manager/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://vkagtjdjdbwpjehnecbk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZrYWd0amRqZGJ3cGplaG5lY2JrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDg5Nzc1OTYsImV4cCI6MjAyNDU1MzU5Nn0.-djMnTzjVMf_JV74IVNgaiyTT7VEaCdBoo3RJS2WAyw',
  );
  SessionManager.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: SplashScreen(), // Display splash screen initially
    );
  }
}
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _visible = false; // Variable to control the visibility of the image

  @override
  void initState() {
    super.initState();
    // After 3 seconds, set _visible to true triggering the animation
    Timer(Duration(seconds: 1), () {
      setState(() {
        _visible = true;
      });
    });
    // After 5 seconds, navigate to the login page
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AuthPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0, // Set opacity based on _visible value
          duration: Duration(seconds: 1), // Duration of the animation
          child: Image.asset(
            'assets/splash.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}