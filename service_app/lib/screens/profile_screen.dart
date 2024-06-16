import 'package:flutter/material.dart';
import 'package:service_app/screens/authentication/auth_page.dart';
import 'package:service_app/screens/authentication/login_page.dart';
import 'package:service_app/screens/edit_profile_screen.dart';
import 'package:service_app/screens/orders.dart';
import 'package:service_app/screens/general/pp.dart';
import 'package:service_app/screens/general/tnc.dart';
import 'package:service_app/screens/shopping_screen.dart';
import 'package:service_app/screens/wishlist.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:service_app/session_manager/session.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.brown,
      ),
      body: FutureBuilder(
        future: _getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userData = snapshot.data as Map<String, dynamic>;
            final String userName = userData['name'];
            final String userEmail = SessionManager.userId.toString();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.brown,
                          radius: 40,
                          child: Icon(Icons.person, color: Colors.white,size: 35,),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name:',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
                            ),
                            SizedBox(height: 2),
                            AutoSizeText(
                              userName,
                              maxLines: 2,
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Email:',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
                            ),
                            SizedBox(height: 2),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.62,
                              child: AutoSizeText(
                                userEmail,
                                maxLines: 2,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    SizedBox(height: 10),
                    _buildOptionButton('Edit Profile', () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
                    }),
                    SizedBox(height: 20),
                    _buildOptionButton('Terms and Conditions', () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TermsAndConditionsPage()));
                    }),
                    SizedBox(height: 20),
                    _buildOptionButton('Privacy Policy', () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyPage()));
                    }),
                    SizedBox(height: 20),
                    _buildOptionButton('Contact Us', () {
                      _launchPhoneCall('8788501591');
                    }),
                    SizedBox(height: 20),
                    _buildOptionButton('Log Out', () {
                      SessionManager.logout();
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> AuthPage()), (route) => false);
                    }),
                  ],
                ),
              ),
            );
          }
        },
      ),
      drawer: NavigationDrawer(),
    );
  }

  Widget _buildOptionButton(String text, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: AutoSizeText(
            text,
            maxLines: 1,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _launchPhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Map<String, dynamic>> _getUserInfo() async {
    final response = await Supabase.instance.client
        .from('users')
        .select()
        .eq('email', SessionManager.userId.toString())
        .single();

    return response as Map<String, dynamic>;
  }
}

// Navigation Drawer widget
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
                  'Explore a world of services',
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
            title: Text("Products"),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer first
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ShoppingPage(),
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
              // Navigate to Privacy Policy page
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
