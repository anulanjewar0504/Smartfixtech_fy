import 'package:flutter/material.dart';
import 'package:service_app_tech/home_page.dart';
import 'package:service_app_tech/session_manager/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class TechnicianGetOrderPage extends StatefulWidget {
  @override
  _TechnicianGetOrderPageState createState() => _TechnicianGetOrderPageState();
}

class _TechnicianGetOrderPageState extends State<TechnicianGetOrderPage> {
  late Future<List<ServiceOrder>> _hardwareServiceOrdersFuture;
  late Future<List<ServiceOrder>> _softwareServiceOrdersFuture;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _hardwareServiceOrdersFuture = fetchHardwareServiceOrders();
    _softwareServiceOrdersFuture = fetchSoftwareServiceOrders();
  }

  Future<List<ServiceOrder>> fetchHardwareServiceOrders() async {
    final response = await supabase.from('hardwareservice').select().eq('status', 'Looking For Technician');
    final List<ServiceOrder> orders = [];

    for (var row in response) {
      orders.add(ServiceOrder(
        id: row['id'] as int,
        serviceType: 'Hardware',
        timeSlot: row['time_slot'] as String,
        date: row['date'] as String,
        address: row['address'] as String,
        phone: row['phone'] as String,
        status: row['status'] as String,
        des : row['description'] as String,
      ));
    }

    return orders;
  }

  Future<List<ServiceOrder>> fetchSoftwareServiceOrders() async {
    final response = await supabase.from('softwareservice').select().eq('status', 'Looking For Technician');
    final List<ServiceOrder> orders = [];

    for (var row in response) {
      orders.add(ServiceOrder(
        id: row['id'] as int,
        serviceType: 'Software',
        timeSlot: row['time_slot'] as String,
        date: row['date'] as String,
        address: row['address'] as String,
        phone: row['phone'] as String,
        status: row['status'] as String,
        des:row['description'] as String,
      ));
    }
    return orders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Technician Orders',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.brown,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0,20, 0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HardwareServiceOrderListPage(ordersFuture: _hardwareServiceOrdersFuture),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // make square
                  ),
                ),
                child: Text('Hardware Service Orders',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0,20, 0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SoftwareServiceOrderListPage(ordersFuture: _softwareServiceOrdersFuture),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // make square
                  ),
                ),
                child: Text('Software Service Orders',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceOrder {
  final int id;
  final String serviceType;
  final String timeSlot;
  final String date;
  final String address;
  final String phone;
  final String status;
  final String des;

  ServiceOrder({
    required this.id,
    required this.serviceType,
    required this.timeSlot,
    required this.date,
    required this.address,
    required this.phone,
    required this.status,
    required this.des

  });
}

class HardwareServiceOrderListPage extends StatelessWidget {
  final Future<List<ServiceOrder>> ordersFuture;

  HardwareServiceOrderListPage({required this.ordersFuture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
      ),
      body: FutureBuilder<List<ServiceOrder>>(
        future: ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return ServiceOrderCard(order: orders[index]);
              },
            );
          }
        },
      ),
    );
  }
}

class SoftwareServiceOrderListPage extends StatelessWidget {
  final Future<List<ServiceOrder>> ordersFuture;

  SoftwareServiceOrderListPage({required this.ordersFuture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.brown,
      ),
      body: FutureBuilder<List<ServiceOrder>>(
        future: ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return ServiceOrderCard(order: orders[index]);
              },
            );
          }
        },
      ),
    );
  }
}
class ServiceOrderCard extends StatelessWidget {
  final ServiceOrder order;

  ServiceOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      color: Colors.brown.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description: ${order.des}'),
                  SizedBox(height: 8),
                  Text('Time Slot: ${order.timeSlot}'),
                  SizedBox(height: 8),
                  Text('Date: ${order.date}'),
                  SizedBox(height: 8),
                  Text('Address: ${order.address}'),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _launchPhoneCall(order.phone);
                      },
                      icon: Icon(Icons.phone, size: 18, color: Colors.white),
                      label: Text('Call', style: TextStyle(fontSize: 14,color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _takeOrder(order,context);
                      },
                      child: Text('Take Order', style: TextStyle(fontSize: 14,color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to launch phone call
  void _launchPhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Function to take order
  void _takeOrder(ServiceOrder order ,context) async {
    await Supabase.instance.client
        .from('${order.serviceType.toLowerCase()}service')
        .update({'status': 'Taken', 'tid': SessionManager.userId})
        .eq('id', order.id);
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage()));
    }
}
