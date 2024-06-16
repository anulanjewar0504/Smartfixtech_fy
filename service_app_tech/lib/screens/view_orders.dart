import 'package:flutter/material.dart';
import 'package:service_app_tech/screens/get_orders.dart';
import 'package:service_app_tech/session_manager/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewOrdersPage extends StatefulWidget {
  @override
  _ViewOrdersPageState createState() => _ViewOrdersPageState();
}

class _ViewOrdersPageState extends State<ViewOrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<ServiceOrder>> _hardwareServiceOrdersFuture;
  late Future<List<ServiceOrder>> _softwareServiceOrdersFuture;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _hardwareServiceOrdersFuture = fetchHardwareServiceOrders();
    _softwareServiceOrdersFuture = fetchSoftwareServiceOrders();
  }
  Future<List<ServiceOrder>> fetchHardwareServiceOrders() async {
    final response = await supabase.from('hardwareservice').select().eq('tid', SessionManager.userId.toString());
    final List<ServiceOrder> orders = [];

    for (var row in response) {
      orders.add(ServiceOrder(
        id: row['id'] as int,
        serviceType: 'Hardware',
        timeSlot: row['time_slot'] as String,
        date: row['date'] as String,
        address: row['address'] as String,
        phone: row['phone'] as String,
        status: row['status'] as String, des: row['description'],
      ));
    }

    return orders;
  }

  Future<List<ServiceOrder>> fetchSoftwareServiceOrders() async {
    final response = await supabase.from('softwareservice').select().eq('tid', SessionManager.userId.toString());
    final List<ServiceOrder> orders = [];

    for (var row in response) {
      orders.add(ServiceOrder(
        id: row['id'] as int,
        serviceType: 'Software',
        timeSlot: row['time_slot'] as String,
        date: row['date'] as String,
        address: row['address'] as String,
        phone: row['phone'] as String, status: row['status'] as String,
        des: row['description'] as String,
      ));
    }

    return orders;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('View Orders',style: TextStyle(color: Colors.white),),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(child: Text('Software',style: TextStyle(color: Colors.white),),),
            Tab(child: Text('Hardware',style: TextStyle(color: Colors.white),),),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SoftwareViewOrders(ordersFuture: _softwareServiceOrdersFuture,),
          HardwareViewOrders(ordersFuture: _hardwareServiceOrdersFuture,),
        ],
      ),
    );
  }
}

class SoftwareViewOrders extends StatelessWidget {
  final Future<List<ServiceOrder>> ordersFuture;

  SoftwareViewOrders({required this.ordersFuture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

class HardwareViewOrders extends StatelessWidget {
  final Future<List<ServiceOrder>> ordersFuture;

  HardwareViewOrders({required this.ordersFuture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  if (order.status == 'Completed')
                    Text('Status: ${order.status}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                  if (order.status != 'Completed')
                    Text('Status: ${order.status}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 9),
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
                      onPressed: () async{
                        await launchURL('tel: ${order.phone}');
                      },
                      icon: Icon(Icons.phone, size: 18, color: Colors.white),
                      label: Text('Call',
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  if (order.status != 'Completed')
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _takeOrder(order, context);
                        },
                        child: Text('Mark as Completed',
                            style: TextStyle(
                                fontSize: 14, color: Colors.white)),
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

  Future launchURL(String url) async {
    var uri = Uri.parse(url);
    try {
      await launchUrl(uri);
    } catch (e) {
      throw 'Could not launch $uri: $e';
    }
  }


  // Function to take order
  void _takeOrder(ServiceOrder order, context) async {
    // Update status in Supabase table
    await Supabase.instance.client
        .from('${order.serviceType.toLowerCase()}service')
        .update({'status': 'Completed'})
        .eq('id', order.id);
    // Show dialog box
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown.shade200,
          title: Text('Order Completed'),
          content: Text('Rs 899 credited to your account.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewOrdersPage()));
              },
              child: Text('Recived',style: TextStyle(color: Colors.white),),
              style: TextButton.styleFrom(
                backgroundColor: Colors.brown
              ),
            ),
          ],
        );
      },
    );
  }

}
