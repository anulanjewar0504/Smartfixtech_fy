import 'package:flutter/material.dart';
import 'package:service_app_tech/authentication/document_verification.dart';
import 'package:service_app_tech/session_manager/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _nameController = TextEditingController();
  final _ComnameController = TextEditingController();

  Future<void> _registerUser() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final name = _nameController.text;
    final company_name = _ComnameController.text;

    final response = await Supabase.instance.client.from('technician').insert([
      {'email': email, 'name': name, 'pass': password,'company_name':company_name,}
    ]);
    SessionManager.login(email);
    Navigator.of(context)
        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => DocumentVerificationScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3, // Adjust height as needed
              color: Colors.brown,
              child: Center(
                child: Image.asset(
                  'assets/logo.png', // Path to your logo image
                  height: 100, // Adjust height as needed
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.3, // Adjust top position based on logo height
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _ComnameController,
                        decoration: InputDecoration(labelText: 'Company Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Company Name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _passwordConfirmationController,
                        decoration: InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _registerUser();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown
                        ),
                        child: Text('Register',style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }
}
