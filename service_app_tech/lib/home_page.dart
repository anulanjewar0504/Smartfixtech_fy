import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:service_app_tech/authentication/auth_page.dart';
import 'package:service_app_tech/general/pp.dart';
import 'package:service_app_tech/general/tnc.dart';
import 'package:service_app_tech/screens/edit_profile.dart';
import 'package:service_app_tech/screens/get_orders.dart';
import 'package:service_app_tech/screens/verification_screen.dart';
import 'package:service_app_tech/screens/view_orders.dart';
import 'package:service_app_tech/session_manager/session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isActive = true;
  String isVerified = '';
  String imgUrl = '';
  String technicianName = 'Technician';
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTechnicianName();
  }

  Future<void> fetchTechnicianName() async {

    final technician = await Supabase.instance.client
      .from('technician')
      .select()
      .eq('email', SessionManager.userId.toString())
      .single();

    setState(() {
      technicianName = technician['name'] as String;
      isVerified =  technician['isVerified'] as String;
      imgUrl = technician['image_url'] as String;
      log(isVerified.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
  if(isVerified == 'false'){
    return VerifyingPage();
  }
  if(isVerified == ''){
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.brown,
          // Adjust the strokeWidth as needed
        ),
      ),
    );

  }
  else if(!isActive){
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Homepage',style: TextStyle(color: Colors.white),),
    ),
    body: SingleChildScrollView(
    child: Container(
    padding: EdgeInsets.all(20.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    SizedBox(height: 20.0),
    CircleAvatar(
    radius: MediaQuery
        .of(context)
        .size
        .width * 0.15,
    backgroundImage: NetworkImage(
    imgUrl),
    ),
    SizedBox(height: 20.0),
    GestureDetector(
    onTap: () {
    // Implement toggle functionality
    setState(() {
    isActive = !isActive;
    });
    },
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Container(
    width: 24,
    height: 24,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: isActive ? Colors.green : Colors.red,
    ),
    child: const Icon(
    Icons.check,
    color: Colors.white,
    size: 16,
    ),
    ),
    const SizedBox(width: 8),
    Text(
    isActive ? 'Active' : 'Inactive',
    style: const TextStyle(
    fontSize: 18, fontWeight: FontWeight.bold),
    ),
    ],
    ),
    ),
    SizedBox(height: 20.0),
    Text(
    '$technicianName',
    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    ),
      SizedBox(height: 30.0),

      ContainerButton(
        title: 'Edit Profile',
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (
              context) => EditProfile()));
        },
      ),
      SizedBox(height: 10.0),
      ContainerButton(
        title: 'Log Out',
        onPressed: () {
          SessionManager.logout();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => AuthPage()), (
              route) => false);
        },
      ),
    ],
    ),
    ),
    ),
    );
  }
  else {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Homepage',style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.0),
              CircleAvatar(
                radius: MediaQuery
                    .of(context)
                    .size
                    .width * 0.15,
                backgroundImage: NetworkImage(imgUrl)),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  // Implement toggle functionality
                  setState(() {
                    isActive = !isActive;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive ? Colors.green : Colors.red,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isActive ? 'Active' : 'Inactive',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                '$technicianName',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30.0),
              Column(
                children: [
                  ContainerButton(
                    title: 'Get Orders',
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (
                          context) => TechnicianGetOrderPage()));
                    },
                  ),
                  SizedBox(height: 10.0),
                  ContainerButton(
                    title: 'View Orders',
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (
                          context) => ViewOrdersPage()));
                    },
                  ),
                  SizedBox(height: 10.0),
                  ContainerButton(
                    title: 'Edit Profile',
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (
                          context) => EditProfile()));
                    },
                  ),
                  SizedBox(height: 10.0),
                  ContainerButton(
                    title: 'Terms And Condition',
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (
                          context) => TermsAndConditionsPage()));
                    },
                  ), SizedBox(height: 10.0),
                  ContainerButton(
                    title: 'Privacy Policy',
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (
                          context) => PrivacyPolicyPage()));
                    },
                  ),
                  SizedBox(height: 10.0),
                  ContainerButton(
                    title: 'Log Out',
                    onPressed: () {
                      SessionManager.logout();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => AuthPage()), (
                          route) => false);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  }
}

class ContainerButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  ContainerButton({required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: Colors.brown,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

