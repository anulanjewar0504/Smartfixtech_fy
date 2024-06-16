import 'package:flutter/material.dart';
import 'package:service_app/screens/home_screen.dart';
import 'package:service_app/session_manager/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late Future<List<WishlistItem>> _wishlistFuture;

  @override
  void initState() {
    super.initState();
    _wishlistFuture = fetchWishlistItems();
  }

  Future<List<WishlistItem>> fetchWishlistItems() async {
    final response = await Supabase.instance.client.from('wishlist').select().eq('user_id', SessionManager.userId.toString());
    final List<WishlistItem> wishlistItems = [];

    for (var row in response) {
      wishlistItems.add(WishlistItem(
        productName: row['name'] as String,
        price: row['price'] as String,
        description: row['description'] as String,
        category: row['category'] as String,
      ));
    }

    return wishlistItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Wishlist'),
      ),
      body: FutureBuilder<List<WishlistItem>>(
        future: _wishlistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final wishlistItems = snapshot.data!;
            return ListView.builder(
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                return WishlistItemCard(
                  wishlistItem: wishlistItems[index],
                  onBuyPressed: () {
                    buyItem(wishlistItems[index]);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> buyItem(WishlistItem item) async {

    String contactNumber = SessionManager.userId.toString();
    if (contactNumber.isNotEmpty) {
      String userId = SessionManager.userId.toString();
      String productName = item.productName;
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
          'phone': contactNumber,
        }
      ]);
      if (response == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false);
      } else {
        // Handle error
      }
    } else {
      // Show error message that address and contact number are required
    }
  }
}

class WishlistItem {
  final String productName;
  final String price;
  final String description;
  final String category;

  WishlistItem({
    required this.productName,
    required this.price,
    required this.description,
    required this.category,
  });
}class WishlistItemCard extends StatelessWidget {
  final WishlistItem wishlistItem;
  final VoidCallback? onBuyPressed;

  WishlistItemCard({required this.wishlistItem, this.onBuyPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      color: Colors.brown.shade100,
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              wishlistItem.productName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Price: ${wishlistItem.price}',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'Category: ${wishlistItem.category}',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: onBuyPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          ),
          child: Text(
            'Buy',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ),
    );
  }
}