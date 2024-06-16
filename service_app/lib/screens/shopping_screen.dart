import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:service_app/screens/authentication/login_page.dart';
import 'package:service_app/screens/orders.dart';
import 'package:service_app/screens/checkout_page.dart';
import 'package:service_app/screens/profile_screen.dart';
import 'package:service_app/session_manager/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShoppingPage extends StatefulWidget {
  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  late Future<List<Product>> _productsFuture;
  final supabase = Supabase.instance.client;
  List<String> categories = ['All', 'Mouse', 'Keyboard', 'Charger', 'Laptop', 'HeadSet', 'Hardware']; // Add your categories here
  String selectedCategory = 'All';
  ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController(); // Add controller for the search field

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    final response = await supabase.from('products').select();
    final List<Product> products = [];

    for (var row in response) {
      products.add(Product(
        phone: row['phone'],
        address:  row['address'] as String,
        rid:  row['rid'] as String,
        name: row['name'] as String,
        description: row['description'] as String,
        price: row['price'] as String,
        imageUrl: row['image_url'] as String,
        category: row['category'] as String,  // Add category field
      ));
    }

    return products;
  }

  void filterProducts(String query) {
    setState(() {
      _productsFuture = fetchFilteredProducts(query);
    });
  }

  Future<List<Product>> fetchFilteredProducts(String query) async {
    final response = await supabase.from('products').select().ilike('name', '%$query%');
    final List<Product> filteredProducts = [];

    for (var row in response) {
      filteredProducts.add(Product(
        phone: row['phone'],
        address:  row['address'] as String,
        rid:  row['rid'] as String,
        name: row['name'] as String,
        description: row['description'] as String,
        price: row['price'] as String,
        imageUrl: row['image_url'] as String,
        category: row['category'] as String, // Add category field
      ));
    }

    return filteredProducts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown,
      ),
      backgroundColor: Colors.brown.shade50,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              controller: _searchController,
              onChanged: filterProducts, // Call filter function on text change
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories
                    .map((category) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (isSelected) {
                      setState(() {
                        selectedCategory = category;
                      });
                      _scrollController.jumpTo(0); // Reset scroll position
                    },
                  ),
                ))
                    .toList(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final products = snapshot.data!;
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      if (selectedCategory == 'All' || product.category == selectedCategory) {
                        return ProductItem(product: product);
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      drawer: NavigationDrawer(),
    );
  }
}

class Product {
  final String name;
  final String description;
  final String price;
  final String imageUrl;
  final String category;
  final String rid;
  final String address;
  final String phone;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.rid,
    required this.address,
    required this.phone
  });
}class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: product.imageUrl.isNotEmpty
                        ? Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    )
                        : Placeholder(),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CheckoutPage(product: product)));
                },
                child: Container(

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: AutoSizeText(
                                product.name,
                                maxLines: 4,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        AutoSizeText(
                          '${product.price}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),

                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Navigation Drawer widget
class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.brown,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Easy Shop',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Explore a world of services',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer first
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text("Active Bookings"),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer first
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BookingsPage(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.auto_fix_high_rounded),
            title: Text("Products"),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer first
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ShoppingPage(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer first
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LoginPage(),
              ));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text("Privacy Policy"),
            onTap: () {
              // Navigate to Privacy Policy page
            },
          ),
          ListTile(
            leading: Icon(Icons.article_outlined),
            title: Text("Terms and Conditions"),
            onTap: () {
              // Navigate to Terms and Conditions page
            },
          ),
        ],
      ),
    );
  }
}
