import 'package:flutter/material.dart';
import 'package:service_app/screens/authentication/login_page.dart';
import 'package:service_app/screens/fix_screen.dart';
import 'package:service_app/screens/general/pp.dart';
import 'package:service_app/screens/hardware_service.dart';
import 'package:service_app/screens/orders.dart';
import 'package:service_app/screens/profile_screen.dart';
import 'package:service_app/screens/software_service.dart';

class ServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Services",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.brown,
      ),
      drawer: NavigationDrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.asset(
                'assets/logo.png',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ServiceCard(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HardwareServicesPage()));
                  },
                  text: 'Hardware Services',
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,

                width: MediaQuery.of(context).size.width * 0.9,
                child: ServiceCard(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SoftwareServicesPage()));
                  },
                  text: 'Software Services',
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ServiceCard(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoPage()));
                  },
                 text: "I'II Fix It My Self",
                ),
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const ServiceCard({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Colors.brown,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }


}
class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.brown,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SmartFixTech',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Fastest and Reliable Service Provider',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer first
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text("Active Bookings"),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer first
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BookingsPage(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.auto_fix_high_rounded),
            title: Text("I'll Fix It Myself"),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer first
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => VideoPage(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer first
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LoginPage(),
              ));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text("Privacy Policy"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PrivacyPolicyPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.article_outlined),
            title: Text("Terms and Conditions"),
            onTap: () {
              // Navigate to Terms and Conditions page
            },
          ),
        ],
      ),
    );
  }
}
