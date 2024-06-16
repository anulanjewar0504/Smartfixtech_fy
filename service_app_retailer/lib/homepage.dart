import 'package:flutter/material.dart';
import 'package:service_app_retailer/authentication/auth_page.dart';
import 'package:service_app_retailer/bookings.dart';
import 'package:service_app_retailer/delete_products.dart';
import 'package:service_app_retailer/general/pp.dart';
import 'package:service_app_retailer/general/tnc.dart';
import 'package:service_app_retailer/session_manager/session.dart';
import 'package:service_app_retailer/upload_products.dart';
import 'package:service_app_retailer/verification.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Retailer Home',style: TextStyle(color: Colors.white),),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchRetailerData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final Map<String, dynamic> retailerData = snapshot.data!;
            final String imageUrl = retailerData['image_url'] ?? '';
            final String isVerified = retailerData['isVerified'] ?? 'false';
            final String shopName = retailerData['company_name'] ?? 'false';

            if (isVerified == 'false') {
              return VerifyingPage();
            }

            return Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(shopName.toString() , style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.08,
                
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> UploadProductPage()));
                        },
                        child: Text('Upload Product',style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // make square
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.08,
                
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> DeleteProductPage()));
                        },
                        child: Text('View Products',style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // make square
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.08,
                
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PrivacyPolicyPage()));
                        },
                        child: Text('Privacy Policy',style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // make square
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.08,
                
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TermsAndConditionsPage()));
                        },
                        child: Text('Terms and Condition',style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2), // make square
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.08,
                
                      child: ElevatedButton(
                        onPressed: () {
                          SessionManager.logout();
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>AuthPage()), (route) => false);
                        },
                        child: Text('Logout',style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // make square
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> fetchRetailerData() async {
    final response = await Supabase.instance.client
        .from('retailer')
        .select()
        .eq('email', SessionManager.userId.toString())
        .single();

    return response;
  }
}
