import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service_admin/notification.dart';
import 'package:service_admin/remove_customer.dart';
import 'package:service_admin/remove_retailer.dart';
import 'package:service_admin/remove_technician.dart';
import 'package:service_admin/retailer_request.dart';
import 'package:service_admin/technician_details.dart';
import 'package:service_admin/technician_request.dart';
import 'package:service_admin/view_customers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int totalUsers = 0;
  int totalTechnicians = 0;
  int totalRetailers = 0;

  @override
  void initState() {
    super.initState();
    fetchCounts();
  }

  Future<void> fetchCounts() async {
    final userCountResponse = await Supabase.instance.client
        .from('users')
        .select().count();
    final technicianCountResponse = await Supabase.instance.client
        .from('technician')
        .select().eq('isVerified', 'true').count();
    final retailerCountResponse = await Supabase.instance.client
        .from('retailer')
        .select().eq('isVerified', 'true').count();

    setState(() {
      totalUsers = userCountResponse.count ?? 0;
      totalTechnicians = technicianCountResponse.count ?? 0;
      totalRetailers = retailerCountResponse.count ?? 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 18,),
              Text(
                'SmartFixTech',
                style: TextStyle(color: Colors.white, fontSize: 20.0,fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4,),
              Text(
                'Fastest and Reliable PC Support',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              SizedBox(height: 15,),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NotificationPage()));
            },
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Icon(Icons.notifications, color: Colors.white,size: 25,),
            ),
          ),
        ],
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(50, 0, 50, 10),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: [
            _buildCountContainer('Total Users', totalUsers),
            _buildCountContainer('Total Technicians', totalTechnicians),
            _buildCountContainer('Total Retailers', totalRetailers),
            DashboardOption(
              icon: Icons.people,
              title: 'View Technician Requests',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ViewTechnicianRequestsPage()));
              },
            ),
            DashboardOption(
              icon: Icons.person,
              title: 'View Technician Details',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RemoveTechnicianPage()));
              },
            ),
            DashboardOption(
              icon: Icons.group,
              title: 'View Customers',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ViewCustomerPage()));
              },
            ),
            DashboardOption(
              icon: Icons.remove_red_eye,
              title: 'View Retailer',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RemoveRetailerPage()));
              },
            ),
            DashboardOption(
              icon: Icons.shopping_cart,
              title: 'View Retailers Request',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ViewRetailerRequestsPage()));
              },
            ),
            DashboardOption(
              icon: Icons.delete,
              title: 'Delete Customer',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RemoveCustomerPage()));
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCountContainer(String title, int count) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 40,),
          Text(
            title,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.0),
          Text(
            count.toString(),
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          Divider(
            height: 80,
          )
        ],
      ),
    );
  }
}

class DashboardOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  DashboardOption({
    required this.icon,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 60.0),
              SizedBox(height: 10.0),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
