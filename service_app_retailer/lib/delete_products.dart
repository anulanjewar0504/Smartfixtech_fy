import 'package:flutter/material.dart';
import 'package:service_app_retailer/session_manager/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeleteProductPage extends StatefulWidget {
  @override
  _DeleteProductPageState createState() => _DeleteProductPageState();
}

class _DeleteProductPageState extends State<DeleteProductPage> {
  late List<Map<String, dynamic>> products;
  late List<Map<String, dynamic>> filteredProducts;
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await Supabase.instance.client
        .from('products')
        .select()
        .eq('rid', SessionManager.userId.toString());

    setState(() {
      isLoading = false;
      products = response as List<Map<String, dynamic>>;
      filteredProducts = products;
    });
  }

  Future<void> deleteProduct(String productId) async {
    final response = await Supabase.instance.client
        .from('products')
        .delete()
        .eq('id', productId);

    if (response.error == null) {
      // Product deleted successfully, update UI
      fetchProducts();
    } else {
      // Handle error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to delete product. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void filterProducts(String query) {
    setState(() {
      filteredProducts = products.where((product) {
        return product['name'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        backgroundColor: Colors.brown,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : filteredProducts.isEmpty
          ? Center(
        child: Text('No products found.'),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filterProducts(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search for a product',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  color: Colors.brown.shade200,
                  elevation: 4.0,
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: product['image_url'].isNotEmpty
                                ? Image.network(
                              product['image_url'],
                              fit: BoxFit.cover,
                            )
                                : Placeholder(),
                          ),
                        ),
                      ),
                    ),
                    title: Text(product['name']),
                    subtitle: Text(product['description']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Confirm Deletion'),
                          content: Text(
                              'Are you sure you want to delete this product?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                      Navigator.pop(context);


                      },
                              child: Text('CANCEL'),
                            ),
                            TextButton(
                              onPressed: () {
                                deleteProduct(
                                    product['id'].toString());
                                fetchProducts();
                                Navigator.pop(context);
                              },
                              child: Text('DELETE'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
