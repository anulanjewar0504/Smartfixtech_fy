import 'package:flutter/material.dart';
import 'package:service_admin/dashboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Technician {
  final String id;
  final String name;
  final String email;
  final String aadharUrl;
  final String imageUrl;
  final String resumeUrl;
  final String isVerified;

  Technician({
    required this.id,
    required this.name,
    required this.email,
    required this.aadharUrl,
    required this.imageUrl,
    required this.resumeUrl,
    required this.isVerified,
  });
}

class ViewTechnicianRequestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Technician Requests'),
      ),
      body: FutureBuilder<List<Technician>>(
        future: _fetchUnverifiedTechnicians(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Technician>? unverifiedTechnicians = snapshot.data;
            if (unverifiedTechnicians != null && unverifiedTechnicians.isNotEmpty) {
              return ListView.builder(
                itemCount: unverifiedTechnicians.length,
                itemBuilder: (context, index) {
                  Technician technician = unverifiedTechnicians[index];
                  return ListTile(
                    leading: Icon(Icons.hardware),
                    title: Text(technician.name,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.brown),),
                    subtitle: Text(technician.email,style: TextStyle(color: Colors.brown),),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TechnicianDetailsPage(
                            technician: technician,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return Text('No unverified technicians found.');
            }
          }
        },
      ),
    );
  }

  Future<List<Technician>> _fetchUnverifiedTechnicians() async {
    final response = await Supabase.instance.client
        .from('technician')
        .select()
        .eq('isVerified', 'false');

    List<dynamic> data = response as List<dynamic>;
    List<Technician> unverifiedTechnicians = data
        .map((json) => Technician(
      id: json['id'].toString(),
      name: json['name'].toString(),
      email: json['email'].toString(),
      aadharUrl: json['adhar_url'].toString(),
      imageUrl: json['image_url'].toString(),
      resumeUrl: json['resume_url'].toString(),
      isVerified: json['isVerified'] as String,
    ))
        .toList();
    return unverifiedTechnicians;
  }
}
class TechnicianDetailsPage extends StatelessWidget {
  final Technician technician;

  TechnicianDetailsPage({required this.technician});

  Future<void> _updateTechnicianStatus(BuildContext context) async {
    final response = await Supabase.instance.client.from('technician').update({
      'isVerified': 'true',
    }).eq('id', technician.id);
   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Dashboard()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Technician Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Adhar Card',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Image.network(
                        '${technician.aadharUrl}',
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: 200,
                      ),
                    ],
                  ),
                  SizedBox(width: 40,),
                  Column(
                    children: [
                      Text(
                        'Face Photo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Image.network(
                        '${technician.imageUrl}',
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: 200,
                      ),
                    ],
                  ),
                  SizedBox(width: 40,),

                  Column(
                    children: [
                      Text(
                        'Resume',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Image.network(
                        '${technician.resumeUrl}',
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: 200,
                      ),
                    ],
                  ),

                ],
              ),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.7,
                child: ElevatedButton(
                  onPressed: () {
                    _updateTechnicianStatus(context);
                  },
                  child: Text('Verify Technician',style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}