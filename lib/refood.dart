import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RefoodPage extends StatefulWidget {
  const RefoodPage({super.key});

  @override
  _RefoodPageState createState() => _RefoodPageState();
}

class _RefoodPageState extends State<RefoodPage> {
  List<dynamic> refoodItems = [];

  @override
  void initState() {
    super.initState();
    fetchRefoodData();
  }

  Future<void> fetchRefoodData() async {
    final url = Uri.parse("https://akademik-smp.xyz/get_refood.php");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          refoodItems = json.decode(response.body);
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[400],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Daftar Produk'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: refoodItems.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 16.0,
                        ),
                        itemCount: refoodItems.length,
                        itemBuilder: (context, index) {
                          final item = refoodItems[index];
                          return CategoryCard(
                            iconUrl: item['image_url'] ??
                                'https://placehold.co/150x150',
                            title: item['name'] ?? 'Nama tidak tersedia',
                            category:
                                item['category'] ?? 'Kategori tidak tersedia',
                            price: item['price'] ?? '0',
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String iconUrl;
  final String title;
  final String category;
  final dynamic price;

  const CategoryCard({
    super.key,
    required this.iconUrl,
    required this.title,
    required this.category,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.cyan[50],
          ),
          child: Image.network(
            iconUrl,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          title,
          style: const TextStyle(fontSize: 14.0),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4.0),
        Text(
          category,
          style: const TextStyle(fontSize: 12.0, color: Colors.grey),
        ),
        const SizedBox(height: 4.0),
        Text(
          'Rp $price',
          style: const TextStyle(fontSize: 14.0, color: Colors.black),
        ),
      ],
    );
  }
}
