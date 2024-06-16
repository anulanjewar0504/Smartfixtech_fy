import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:service_app/screens/authentication/login_page.dart';
import 'package:service_app/screens/general/pp.dart';
import 'package:service_app/screens/orders.dart';
import 'package:service_app/screens/fix_screen.dart';
import 'package:service_app/screens/profile_screen.dart';
import 'package:service_app/screens/service_screen.dart';
import 'package:service_app/screens/shopping_screen.dart';
import 'package:service_app/screens/software_bookings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),
    ServicePage(),
    ShoppingPage(),
    ViewServiceBookingsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.build),
              label: 'Services',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Shopping',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'My Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'My Account',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.brown.shade600,
          onTap: _onItemTapped,
          unselectedItemColor: Colors.grey.shade300,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class HomeContent extends StatefulWidget {
  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<String> offerImageUrls = [];

  List<String> topServicesImageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchImageUrls();
  }

  Future<void> fetchImageUrls() async {

    final supabase = Supabase.instance.client;
    final offerResponse = await supabase.from('offers').select('url');
    setState(() {
      offerImageUrls = List<String>.from(offerResponse.map((e) => e['url'] as String));
    });

    // Fetch top services image URLs from the 'slides' table
    final slidesResponse = await supabase.from('slides').select('url');
      setState(() {
        topServicesImageUrls = List<String>.from(slidesResponse.map((e) => e['url'] as String));
      });
  }

  @override
  Widget build(BuildContext context) {
    if(topServicesImageUrls == null){
      return CircularProgressIndicator(
      );
    }
    else {
      return Scaffold(
        appBar: AppBar(
          title: Text('SmartFixTech',style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.brown,
        ),
        body: ListView(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(12.0),
            //   child: TextFormField(
            //     decoration: InputDecoration(
            //       hintText: 'Search...',
            //       prefixIcon: Icon(Icons.search),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8.0),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Offers',
                style: TextStyle(color: Colors.black,fontSize:20.5, fontWeight: FontWeight.bold,),),
            ),
            SizedBox(
              height: 200,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                ),
                items: offerImageUrls.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                        ),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Top Services',
                style: TextStyle(color: Colors.black,fontSize:20.5, fontWeight: FontWeight.bold,),),
            ),
            SizedBox(
              height: 200,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                ),
                items: topServicesImageUrls.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                        ),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: LinearGradient(
                    colors: [
                      Colors.brown.shade200,
                      Colors.brown.shade400,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.computer, color: Colors.white, size: 24.0), // Icon before text
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            'All Computer services on demand',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive font size
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Icon(Icons.check, color: Colors.white, size: 24.0), // Icon for "Quality and genuine spare parts"
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            'Quality and genuine spare parts',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive font size
                             fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Icon(Icons.run_circle_outlined, color: Colors.white, size: 24.0), // Icon for "Quality and genuine spare parts"
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            'Fastest And Reliable PC Support',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive font size
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Image.asset(
                          'assets/appliance.png',
                          height: MediaQuery.of(context).size.width * 0.5, // Responsive image size
                        ), // Image
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Add more widgets for additional content below the carousel sliders and container
          ],
        ),
        drawer: NavigationDrawer(),
      );
    }
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
