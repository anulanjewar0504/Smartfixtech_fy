import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms and Conditions',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                '1. Introduction',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'These terms and conditions govern your use of the service app; by using the app, you accept these terms and conditions in full. If you disagree with these terms and conditions or any part of these terms and conditions, you must not use this app.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '2. License to use app',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Unless otherwise stated, the service app and its licensors own the intellectual property rights in the app and material on the app. Subject to the license below, all these intellectual property rights are reserved.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              // Add more sections as needed
            ],
          ),
        ),
      ),
    );
  }
}
