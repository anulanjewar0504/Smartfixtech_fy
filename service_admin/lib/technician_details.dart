import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Technician {
  final String name;
  final String email;
  final String aadharUrl;
  final String imageUrl;
  final String resumeUrl;
  final String isVerified;

  Technician({
    required this.name,
    required this.email,
    required this.aadharUrl,
    required this.imageUrl,
    required this.resumeUrl,
    required this.isVerified,
  });
}

class TechnicianListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Technician List'),
      ),
      body: FutureBuilder<List<Technician>>(
        future: _fetchTechnicians(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final technicians = snapshot.data!;
            return ListView.builder(
              itemCount: technicians.length,
              itemBuilder: (context, index) {
                final technician = technicians[index];
                return Card(
                  color: Colors.brown.shade100,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(technician.imageUrl),
                    ),
                    title: Text('Name:'+
                      technician.name,
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Email:' + technician.email + '\n' +'Verification Status:'+ technician.isVerified ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No technicians found.'));
          }
        },
      ),
    );
  }

  Future<List<Technician>> _fetchTechnicians() async {
    final response = await Supabase.instance.client.from('technician').select();
    final List<dynamic> data = response;
    return data.map((e) {
      return Technician(
        name: e['name'] as String,
        email: e['email'] as String,
        aadharUrl: e['adhar_url'] as String,
        imageUrl: e['image_url'] as String,
        resumeUrl: e['resume_url'] as String,
        isVerified: e['isVerified'] as String,
      );
    }).toList();
  }
}
