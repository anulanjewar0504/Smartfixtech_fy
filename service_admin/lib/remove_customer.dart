import 'package:flutter/material.dart';
import 'package:service_admin/dashboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class User {
  final int id;
  final String? name;
  final String? email;

  User({
    required this.id,
    this.name,
    this.email,
  });
}

class RemoveCustomerPage extends StatefulWidget {
  @override
  _RemoveCustomerPageState createState() => _RemoveCustomerPageState();
}

class _RemoveCustomerPageState extends State<RemoveCustomerPage> {
  late Future<List<User>> _fetchCustomers;

  @override
  void initState() {
    super.initState();
    _fetchCustomers = _fetchCustomersData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remove Customers'),
      ),
      body: FutureBuilder<List<User>>(
        future: _fetchCustomers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final customers = snapshot.data!;
            return ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return Card(
                  color: Colors.brown.shade100,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      customer.name ?? 'N/A',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(customer.email ?? 'N/A'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeCustomer(customer.id),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No customers found.'));
          }
        },
      ),
    );
  }

  Future<List<User>> _fetchCustomersData() async {
    final response = await Supabase.instance.client.from('users').select();


    final List<dynamic> data = response;
    return data.map((e) {
      return User(
        id: e['id'] as int,
        name: e['name'] as String?,
        email: e['email'] as String?,
      );
    }).toList();
  }

  Future<void> _removeCustomer(int customerId) async {
    final response = await Supabase.instance.client.from('users').delete().eq('id', customerId);


    // Refresh UI by fetching customers again
    setState(() {
      _fetchCustomers = _fetchCustomersData();
    });
  }
}
