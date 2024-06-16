import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Technician {
  final int id;
  final String? name;
  final String? email;

  Technician({
    required this.id,
    this.name,
    this.email,
  });
}

class RemoveTechnicianPage extends StatefulWidget {
  @override
  _RemoveTechnicianPageState createState() => _RemoveTechnicianPageState();
}

class _RemoveTechnicianPageState extends State<RemoveTechnicianPage> {
  late Future<List<Technician>> _fetchTechnicians;

  @override
  void initState() {
    super.initState();
    _fetchTechnicians = _fetchTechniciansData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remove Technicians'),
      ),
      body: FutureBuilder<List<Technician>>(
        future: _fetchTechnicians,
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
                    title: Text(
                      technician.name ?? 'N/A',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(technician.email ?? 'N/A'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeTechnician(technician.id),
                    ),
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

  Future<List<Technician>> _fetchTechniciansData() async {
    final response = await Supabase.instance.client.from('technician').select();



    final List<dynamic> data = response;
    return data.map((e) {
      return Technician(
        id: e['id'] as int,
        name: e['name'] as String?,
        email: e['email'] as String?,
      );
    }).toList();
  }

  Future<void> _removeTechnician(int technicianId) async {
    final response = await Supabase.instance.client.from('technician').delete().eq('id', technicianId);

    setState(() {
      _fetchTechnicians = _fetchTechniciansData();
    });
  }
}
