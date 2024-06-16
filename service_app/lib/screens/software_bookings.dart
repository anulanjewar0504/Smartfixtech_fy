import 'package:flutter/material.dart';
import 'package:service_app/screens/authentication/login_page.dart';
import 'package:service_app/screens/orders.dart';
import 'package:service_app/screens/profile_screen.dart';
import 'package:service_app/screens/shopping_screen.dart';
import 'package:service_app/session_manager/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewServiceBookingsPage extends StatefulWidget {
  @override
  _ViewServiceBookingsPageState createState() => _ViewServiceBookingsPageState();
}

class _ViewServiceBookingsPageState extends State<ViewServiceBookingsPage> {
  late Future<List<SoftwareService>> _softwareBookingsFuture;
  late Future<List<HardwareService>> _hardwareBookingsFuture;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _softwareBookingsFuture = fetchSoftwareBookings();
    _hardwareBookingsFuture = fetchHardwareBookings();
  }

  Future<List<SoftwareService>> fetchSoftwareBookings() async {
    final response = await supabase.from('softwareservice').select().eq('userid', SessionManager.userId.toString());
    final List<SoftwareService> bookings = [];

    for (var row in response) {
      bookings.add(SoftwareService(
        timeSlot: row['time_slot'] as String,
        date: row['date'] as String,
        address: row['address'] as String,
        phone: row['phone'] as String,
      ));
    }

    return bookings;
  }

  Future<List<HardwareService>> fetchHardwareBookings() async {
    final response = await supabase.from('hardwareservice').select().eq('userid', SessionManager.userId.toString());
    final List<HardwareService> bookings = [];

    for (var row in response) {
      bookings.add(HardwareService(
        timeSlot: row['time_slot'] as String,
        date: row['date'] as String,
        address: row['address'] as String,
        phone: row['phone'] as String,
      ));
    }

    return bookings;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('View Service Bookings',style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.brown,
          bottom: TabBar(
            tabs: [
              Tab(child:Text("Software",style: TextStyle(color: Colors.white),) ,),
              Tab(child:Text("Hardware",style: TextStyle(color: Colors.white)) ,),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Software Tab View
            FutureBuilder<List<SoftwareService>>(
              future: _softwareBookingsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final bookings = snapshot.data!;
                  return ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      return BookingCard(booking: bookings[index]);
                    },
                  );
                }
              },
            ),
            // Hardware Tab View
            FutureBuilder<List<HardwareService>>(
              future: _hardwareBookingsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final bookings = snapshot.data!;
                  return ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      return BookingCard(booking: bookings[index]);
                    },
                  );
                }
              },
            ),
          ],
        ),
        drawer: NavigationDrawer(),
      ),
    );
  }
}

class SoftwareService {
  final String timeSlot;
  final String date;
  final String address;
  final String phone;

  SoftwareService({
    required this.timeSlot,
    required this.date,
    required this.address,
    required this.phone,
  });
}

class HardwareService {
  final String timeSlot;
  final String date;
  final String address;
  final String phone;

  HardwareService({
    required this.timeSlot,
    required this.date,
    required this.address,
    required this.phone,
  });
}

class BookingCard extends StatelessWidget {
  final dynamic booking;

  BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      color: Colors.brown.shade100,
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time Slot: ${booking.timeSlot}',
              style: TextStyle(color: Colors.brown.shade900),
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${booking.date}',
              style: TextStyle(color: Colors.brown.shade900),
            ),
            SizedBox(height: 8),
            Text(
              'Address: ${booking.address}',
              style: TextStyle(color: Colors.brown.shade900),
            ),
            SizedBox(height: 8),
            Text(
              'Phone: ${booking.phone}',
              style: TextStyle(color: Colors.brown.shade900),
            ),
          ],
        ),
      ),
    );
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
