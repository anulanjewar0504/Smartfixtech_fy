import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:service_app/screens/orders.dart';
import 'package:service_app/screens/software_bookings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:service_app/session_manager/session.dart';

class SoftwareServicesPage extends StatefulWidget {
  @override
  _SoftwareServicesPageState createState() => _SoftwareServicesPageState();
}

class _SoftwareServicesPageState extends State<SoftwareServicesPage> {
  late TextEditingController _addressController;
  late TextEditingController _contactController;
  late TextEditingController _desController;
  late String _selectedTimeSlot;
  late DateTime _selectedDate;
  late String _currentAddress;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _contactController = TextEditingController();
    _desController = TextEditingController();
    _selectedTimeSlot = '9am - 12pm';
    _selectedDate = DateTime.now().add(Duration(days: 1)); // Default to tomorrow's date
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Request permission to access location
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied.');
    }

    // Fetch the current position
    Position position = await Geolocator.getCurrentPosition();
    // Fetch the address using the current position
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks.first;
    // Update the address controller
    setState(() {
      _currentAddress =
      '${placemark.street}, ${placemark.locality}, ${placemark.postalCode}';
      _addressController.text = _currentAddress;
    });
  }

  Future<void> _submitForm() async {
    // Retrieve the values from the text controllers and variables
    String userId = SessionManager.userId.toString(); // Assuming SessionManager.userId is a static variable holding the user ID
    String phone = _contactController.text;
    String address = _addressController.text;
    String timeSlot = _selectedTimeSlot;
    String date = '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}'; // Format the date as YYYY-MM-DD

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tech Pay'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pay ₹999 for booking your service.',style: TextStyle(color: Colors.brown.shade800),),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Call the function to log to the Supabase request table
                await logToSupabaseswTable(userId, phone, address, timeSlot, date);
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>ViewServiceBookingsPage()), (route) => false);

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown
              ),
              child: Text('Pay ₹999',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  logToSupabaseswTable(
      String userId, String phone, String address, String timeSlot, String date) async {
    final response = await Supabase.instance.client.from('softwareservice').insert([
      {'userid': userId, 'phone': phone, 'address': address, 'time_slot': timeSlot, 'date': date}
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Software Services'),
        backgroundColor: Colors.brown, // Change color to differentiate from hardware services page
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Your Current Address:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Enter Issue:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _desController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Enter Your Contact Number',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Select Time Slot:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedTimeSlot,
                onChanged: (value) {
                  setState(() {
                    _selectedTimeSlot = value!;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: '9am - 12pm',
                    child: Text('9am - 12pm'),
                  ),
                  DropdownMenuItem(
                    value: '12pm - 3pm',
                    child: Text('12pm - 3pm'),
                  ),
                  DropdownMenuItem(
                    value: '3pm - 6pm',
                    child: Text('3pm - 6pm'),
                  ),
                  DropdownMenuItem(
                    value: '6pm - 9pm',
                    child: Text('6pm - 9pm'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Select Date:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 30)),
                  );
                  if (picked != null && picked != _selectedDate) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
                child: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown, // Change color to differentiate from hardware services page
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), // button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // button border radius
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 18, color: Colors.white), // text style
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
