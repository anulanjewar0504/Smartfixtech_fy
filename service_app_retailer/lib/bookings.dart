import 'package:flutter/material.dart';
import 'package:service_app_retailer/session_manager/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Booking {
  final String productName;
  final String purchaseDate;
  final String deliveryDate;
  final String userId;

  Booking({
    required this.productName,
    required this.purchaseDate,
    required this.deliveryDate,
    required this.userId,
  });

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      productName: map['product'],
      purchaseDate: map['purchase'],
      deliveryDate: map['delivery'],
      userId: map['userid'],
    );
  }
}

class BookingsPage extends StatefulWidget {
  @override
  _BookingsPageState createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  late Future<List<Booking>> _userBookingsFuture;

  @override
  void initState() {
    super.initState();
    _userBookingsFuture = fetchUserBookings();
  }

  Future<List<Booking>> fetchUserBookings() async {
    try {
      final response = await Supabase.instance.client
          .from('bookings')
          .select()
          .eq('rid', SessionManager.userId.toString());
      final data = response as List<dynamic>;
      final bookings = data.map((item) => Booking.fromMap(item)).toList();
      return bookings;
    } catch (error) {
      throw Exception('Failed to fetch user bookings: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
          backgroundColor: Colors.brown.shade200,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Active'),
            ],
          ),
        ),
        backgroundColor: Colors.brown.shade50,
        body: TabBarView(
          children: [
            FutureBuilder<List<Booking>>(
              future: _userBookingsFuture,
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
                  final userBookings = snapshot.data!;
                  return ListView.builder(
                    itemCount: userBookings.length,
                    itemBuilder: (context, index) {
                      final booking = userBookings[index];
                      return ListTile(
                        title: Text(
                          booking.productName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8), // Add spacing between title and subtitle
                            Text(
                              'Purchase Date:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              booking.purchaseDate,
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 4), // Add spacing between purchase and delivery dates
                            Text(
                              'Delivery Date:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              booking.deliveryDate,
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      );

                    },
                  );
                }
              },
            ),
            Center(
              child: Text(
                'Previous Bookings Content',
                style: TextStyle(color: Colors.brown.shade900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
