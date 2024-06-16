import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final hardwareServiceResponse = await Supabase.instance.client.from('hardwareservice').select().eq('status', 'Completed');
    final softwareServiceResponse = await Supabase.instance.client.from('softwareservice').select().eq('status', 'Completed');

    List<String> hardwareNotifications = [];
    for (var record in hardwareServiceResponse) {
      hardwareNotifications.add("Hardware Service ID: hw${record['id']}, Rupees 100 credited");
    }

    List<String> softwareNotifications = [];
    for (var record in softwareServiceResponse) {
      softwareNotifications.add("Software Service ID: sw${record['id']}, Rupees 100 credited");
    }

    setState(() {
      notifications = [...hardwareNotifications, ...softwareNotifications];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: notifications.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              notifications[index],
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            leading: Icon(
              Icons.payment,
              color: Colors.brown,
            ),
            tileColor: Colors.grey[200],
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          );
        },
      ),
    );
  }
}