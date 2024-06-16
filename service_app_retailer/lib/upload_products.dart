import 'dart:io';
import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_app_retailer/homepage.dart';
import 'package:service_app_retailer/session_manager/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadProductPage extends StatefulWidget {
  @override
  _UploadProductPageState createState() => _UploadProductPageState();
}

class _UploadProductPageState extends State<UploadProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  File? _imageFile;
  Future<String> _fetchAddress() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      String address =
          "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
      return address;
    } catch (e) {
      print('Error fetching address: $e');
      return ''; // Return an empty string in case of error
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchAddress().then((address) {
      _addressController.text = address;
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Upload Product',style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildImageButton(),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Retailer Address'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                onPressed: _uploadProduct,
                child: Text('Upload Product',style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2), // make square
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageButton() {
    return Column(
      children: [
        _imageFile != null
            ? Image.file(
          _imageFile!,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        )
            : Placeholder(
          fallbackHeight: 200,
          fallbackWidth: double.infinity,
        ),
        SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: ElevatedButton(
            onPressed: _pickImage,
            child: Text('Choose Image', style: TextStyle(color: Colors.white),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown
            ),
          ),
        ),
      ],
    );
  }
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadProduct() async {
    if (_imageFile == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please select an image.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final imageUrl = await _uploadImageToSupabase();

    final response = await Supabase.instance.client.from('products').insert({
      'name': _nameController.text,
      'description': _descriptionController.text,
      'price': _priceController.text,
      'address': _addressController.text,
      'category': _categoryController.text,
      'phone': _phoneController.text,
      'rid': SessionManager.userId.toString(),
      'status':'inTransist',
      'image_url': imageUrl,
    });
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>HomePage()), (route) => false);

    if (response.error != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(response.error!.message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>HomePage()), (route) => false);
      _resetFields();
    }
  }

  Future<String?> _uploadImageToSupabase() async {

    final storageResponse = await Supabase.instance.client.storage
        .from('prod')
        .upload('product_${SessionManager.userId}${_nameController.text}.jpg', _imageFile!);

    String url = await Supabase.instance.client.storage.from('prod').getPublicUrl('product_${SessionManager.userId}${_nameController.text}.jpg'.toString());
return url;
  }

  void _resetFields() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _addressController.clear();
    _categoryController.clear();
    _phoneController.clear();
    setState(() {
      _imageFile = null;
    });
  }
}
