import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'keranjang.dart';
import 'cart_provider.dart';

class MrBoxPage extends StatefulWidget {
  const MrBoxPage({Key? key}) : super(key: key);

  @override
  _MrBoxPageState createState() => _MrBoxPageState();
}

class _MrBoxPageState extends State<MrBoxPage> {
  List<dynamic> _products = [];
  bool _isLoading = true;

  // Variabel untuk menyimpan data pengguna
  String _username = 'Username Tidak Ditemukan';
  String _email = 'Email Tidak Ditemukan';
  String _phone = 'Telepon Tidak Ditemukan';

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _loadUserData(); // Memanggil fungsi untuk memuat data pengguna
  }

  Future<void> fetchProducts() async {
    try {
      const url = 'https://akademik-smp.xyz/api_produk/get_mrbox.php';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            _products = data['products'];
            _isLoading = false;
          });
        } else {
          throw Exception('Data produk tidak valid');
        }
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat produk: $e')),
      );
    }
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'Username Tidak Ditemukan';
    });
  }

  void _addToCart(Map<String, dynamic> product) async {
    // Memeriksa apakah pengguna sudah login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!isLoggedIn) {
      // Tampilkan dialog jika pengguna belum login
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Diperlukan'),
          content: const Text(
              'Silakan login terlebih dahulu untuk menambahkan produk ke keranjang.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Jika sudah login, tambahkan produk ke keranjang
      Provider.of<CartProvider>(context, listen: false).addToCart(product);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('${product['name']} berhasil ditambahkan ke keranjang!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mr. Box'),
        backgroundColor: const Color(0xFF00C2E0),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? const Center(child: Text('Tidak ada produk tersedia'))
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return ProductCard(
                        name: product['name'],
                        price: product['price'].toString(),
                        gambar: product['gambar'],
                        description: product['description'].toString(),
                        stock: product['stock'].toString(),
                        onAddToCart: () => _addToCart(product),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const KeranjangScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF00C2E0),
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String stock;
  final String description;
  final String gambar;
  final VoidCallback onAddToCart;

  const ProductCard({
    Key? key,
    required this.name,
    required this.price,
    required this.stock,
    required this.description,
    required this.gambar,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Membuat URL gambar
    final imageUrl = 'https://akademik-smp.xyz/api_produk/images/$gambar';

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported,
                      size: 80, color: Colors.grey);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$name',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Stok: $stock',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp$price',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color.fromARGB(221, 222, 5, 5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: onAddToCart,
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Tambah ke Keranjang'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
