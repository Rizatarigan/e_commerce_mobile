import 'package:flutter/material.dart';
import 'package:gorestan/detail_produk.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Map<String, dynamic>> _categories = []; // Menyimpan data kategori
  List<Map<String, dynamic>> _listdata = []; // Menyimpan data produk
  bool _loadingCategories = true;
  bool _loadingProducts = false;

  final Color primaryColor = const Color(0xFF00C2E0);
  final Color secondaryColor = Colors.blue[50]!;

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  // Fungsi untuk mengambil data kategori
  Future<void> _getCategories() async {
    try {
      final response = await http.get(
          Uri.parse('https://akademik-smp.xyz/api_produk/read_kategori.php'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          setState(() {
            _categories = List<Map<String, dynamic>>.from(data['data']);
            _loadingCategories = false;
          });
        } else {
          throw Exception("Data kategori kosong.");
        }
      } else {
        throw Exception("Gagal memuat kategori: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        _loadingCategories = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat kategori: $e")),
      );
    }
  }

  // Fungsi untuk mengambil data produk berdasarkan kategori
  Future<void> _getDataByCategory(String idKategori) async {
    setState(() {
      _loadingProducts = true;
      _listdata = []; // Reset produk sebelumnya
    });
    try {
      final response = await http.get(
        Uri.parse(
          'https://akademik-smp.xyz/api_produk/read_by_category.php?id_kategori=$idKategori',
        ),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          setState(() {
            _listdata = List<Map<String, dynamic>>.from(data['data']);
            _loadingProducts = false;
          });
        } else {
          throw Exception(data['message'] ?? "Data produk kosong.");
        }
      } else {
        throw Exception("Gagal memuat produk: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        _loadingProducts = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat produk: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop (${_categories.length} kategori)'),
        backgroundColor: primaryColor,
      ),
      body: Row(
        children: [
          // Sidebar Menu
          Container(
            width: 100,
            color: secondaryColor,
            child: _loadingCategories
                ? const Center(child: CircularProgressIndicator())
                : _categories.isEmpty
                    ? const Center(
                        child: Text(
                          "Kategori kosong",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          return buildMenuItem(
                            Icons.category,
                            category['nama_kategori'] ?? "Tanpa Nama",
                            onTap: () {
                              _getDataByCategory(
                                  category['id_kategori'].toString());
                            },
                          );
                        },
                      ),
          ),
          // Konten Utama
          Expanded(
            child: _loadingProducts
                ? const Center(child: CircularProgressIndicator())
                : _listdata.isEmpty
                    ? const Center(
                        child: Text(
                          "Tidak ada produk",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: _listdata.length,
                        itemBuilder: (context, index) {
                          final product = _listdata[index];
                          return buildProductItem(product);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem(IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: primaryColor, size: 32),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductItem(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              product: product,
              productId:
                  product['id_produk']?.toString(), // Konversi int ke String
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                product['gambar'] ?? 'https://via.placeholder.com/150',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product['nama_produk'] ?? "Nama Produk",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            product['harga_produk'] != null
                ? "Rp ${product['harga_produk']}"
                : "Rp 0",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.red,
            ),
          ),
          Text(
            product['jumlah_terjual'] != null
                ? "${product['jumlah_terjual']} Terjual"
                : "0 Terjual",
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
