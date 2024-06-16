import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_app_retailer/homepage.dart';
import 'package:service_app_retailer/session_manager/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DocumentVerificationScreen extends StatefulWidget {
  @override
  _DocumentVerificationScreenState createState() =>
      _DocumentVerificationScreenState();
}

class _DocumentVerificationScreenState
    extends State<DocumentVerificationScreen> {
  File? _aadharCardImage;
  File? _faceSelfieImage;
  File? _resume;

  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage(ImageSource source, Function(File?) setImage) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setImage(File(pickedFile.path));
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Verification',style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSection(
              title: 'Upload Aadhar Card Image:',
              image: _aadharCardImage,
              setImage: (image) => setState(() => _aadharCardImage = image),
            ),
            SizedBox(height: 20),
            _buildSection(
              title: 'Upload Face Selfie Image:',
              image: _faceSelfieImage,
              setImage: (image) => setState(() => _faceSelfieImage = image),
            ),
            SizedBox(height: 20),
            _buildSection(
              title: 'Upload Shop License:',
              image: _resume,
              setImage: (image) => setState(() => _resume = image),
            ),
            SizedBox(height: 22),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                onPressed: _uploadDocuments,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2), // make square
                  ),
                ),
                child: Text('Upload Documents',style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required File? image,
    required Function(File?) setImage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        if (image != null) ...[
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Image.file(image, height: 200),
              IconButton(
                onPressed: () => setImage(null),
                icon: Icon(Icons.close, color: Colors.red),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
            height:  MediaQuery.of(context).size.width * 0.4,
            width:  MediaQuery.of(context).size.width * 0.4,
              child: ElevatedButton(
                onPressed: () => _getImage(ImageSource.camera, setImage),
                child: Text('Camera',style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // make square
                  ),
                ),
              ),
            ),

            SizedBox(width: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              height:  MediaQuery.of(context).size.width * 0.4,
              child: ElevatedButton(
                onPressed: () => _getImage(ImageSource.gallery, setImage),
                child: Text('Gallery',style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // make square
                  ),
                ),
              ),
            ),

          ],
        ),
      ],
    );
  }

  Future<void> _uploadDocuments() async {
    if (_aadharCardImage != null &&
        _faceSelfieImage != null &&
        _resume != null) {
      final userId = SessionManager.userId;
      final aadharCardFileName = '$userId-aadhar-card.jpg';
      final faceSelfieFileName = '$userId-face-selfie.jpg';
      final resumeFileName = '$userId-resume.jpg';

      final aadharCardUrl = await (_uploadFile(_aadharCardImage!, aadharCardFileName));
      final faceSelfieUrl = await _uploadFile(_faceSelfieImage!, faceSelfieFileName);
      final resumeUrl = await _uploadFile(_resume!, resumeFileName);

      await Supabase.instance.client
          .from('retailer')
          .update({
        'image_url': faceSelfieUrl,
        'adhar_url': aadharCardUrl,
        'resume_url': resumeUrl,
      })
          .eq('email',SessionManager.userId.toString() );
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>HomePage()), (route) => false);

    }
  }

  Future<String> _uploadFile(File file, String fileName) async {
    final fileBytes = await file.readAsBytes();
    final response = await Supabase.instance.client.storage
        .from('retail')
        .uploadBinary(fileName, fileBytes);
      String url = await Supabase.instance.client.storage.from('retail').getPublicUrl(fileName.toString());
    log(url);
    return url;
  }
}
