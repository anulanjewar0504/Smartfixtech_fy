import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:service_app/screens/home_screen.dart';
import 'package:service_app/screens/shopping_screen.dart';
import 'package:service_app/session_manager/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';


class CheckoutPage extends StatefulWidget {
  final Product product;

  CheckoutPage({required this.product});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  TextEditingController _addressController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  String _retailerName = '';


  @override
  void initState() {
    super.initState();
    _fetchAddress();
    _fetchRetailerName(); // Fetch retailer name when page loads

  }

  Future<void> _fetchAddress() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      String address =
          "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
      _addressController.text = address;
    } catch (e) {
      log('Error fetching address: $e');
    }
  }
  Future<void> _fetchRetailerName() async {
    // Fetch retailer name using widget.product.rid
    final retailerResponse = await Supabase.instance.client
        .from('retailer')
        .select('company_name')
        .eq('email', widget.product.rid)
        .single();
    if (retailerResponse  != null) {
      setState(() {
        _retailerName = retailerResponse['company_name'] as String;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network('${widget.product.imageUrl}'),
              Text(
                'Product Name: ${widget.product.name}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Price:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    '${widget.product.price}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                ],
              ),
              SizedBox(height: 8),
              Text(
                'Description: ${widget.product.description}',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Text(
                'Shop Name: $_retailerName',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text('Address :${widget.product.address}',style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String address = _addressController.text;
                    String contactNumber = _contactNumberController.text;
                    if (address.isNotEmpty && contactNumber.isNotEmpty) {
                      String userId = SessionManager.userId.toString();
                      String productName = widget.product.name;
                      String purchaseDate = DateTime.now().toString();
                      String deliveryDate =
                      DateTime.now().add(Duration(days: 3)).toString();
                      final response =
                      await Supabase.instance.client.from('bookings').insert([
                        {
                          'userid': userId,
                          'product': productName,
                          'purchase': purchaseDate,
                          'delivery': deliveryDate,
                          'rid':widget.product.rid,
                        }
                      ]);
                      _launchPhoneCall(widget.product.phone);
                      if (response == null) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => HomePage()),
                                (route) => false);
                      } else {
                        // Handle error
                      }
                    } else {

                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Call Us Now',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _launchPhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
