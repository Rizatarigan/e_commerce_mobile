import 'package:flutter/material.dart';
import 'package:gorestan/keranjang.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Map<String, dynamic> selectedProduct;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedProduct = widget.product;
    fetchProductDetails(selectedProduct['id']);
  }

  Future<void> fetchProductDetails(int productId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://akademik-smp.xyz/api_produk/get_mrbox.php?id=$productId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true && data['product'] != null) {
          setState(() {
            selectedProduct = {
              'id': data['product']['id'],
              'name': data['product']['name'] ?? 'Produk tidak diketahui',
              'price': data['product']['price']?.toString() ?? '0',
              'gambar':
                  data['product']['gambar'] ?? 'https://placehold.co/300x300',
              'rating': data['product']['rating']?.toString() ?? '0',
              'stock': data['product']['stock']?.toString() ?? '0',
              'category':
                  data['product']['category'] ?? 'Kategori tidak tersedia',
              'sold': data['product']['sold']?.toString() ?? '0',
            };
            isLoading = false;
          });
        } else {
          throw Exception(data['message'] ?? 'Failed to load product details');
        }
      } else {
        throw Exception(
            'Failed to load product details (HTTP ${response.statusCode})');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addToCart(int productId) async {
    const userId = 1; // Ganti dengan ID user yang sedang login
    const quantity = 1; // Default jumlah produk

    try {
      final response = await http.post(
        Uri.parse('https://akademik-smp.xyz/api_produk/add_to_cart.php'),
        body: {
          'user_id': userId.toString(),
          'product_id': productId.toString(),
          'quantity': quantity.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception(
            'Failed to add product to cart (HTTP ${response.statusCode})');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLoading ? 'Loading...' : selectedProduct['name']),
        backgroundColor: const Color(0xFF00C2E0),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KeranjangScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              selectedProduct['gambar'],
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image_not_supported,
                                  size: 200,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            selectedProduct['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Rp ${selectedProduct['price']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  size: 18, color: Colors.amber),
                              const SizedBox(width: 5),
                              Text(
                                selectedProduct['rating'],
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${selectedProduct['sold']} terjual',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Informasi Produk',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Stok: ${selectedProduct['stock']} \nKategori: ${selectedProduct['category']}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${selectedProduct['name']} ditambahkan ke keranjang!',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Masukkan Keranjang',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Anda memilih beli langsung ${selectedProduct['name']}!',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Beli Langsung',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
