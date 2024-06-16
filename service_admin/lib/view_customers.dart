import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class User {
  final String? name;
  final String? email;

  User({
    this.name,
    this.email,
  });
}

class ViewCustomerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Customers'),
      ),
      body: FutureBuilder<List<User>>(
        future: _fetchCustomers(),
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

  Future<List<User>> _fetchCustomers() async {
    final response = await Supabase.instance.client.from('users').select();

    final List<dynamic> data = response;
    return data.map((e) {
      return User(
        name: e['name'] as String?,
        email: e['email'] as String?,
      );
    }).toList();
  }
}
