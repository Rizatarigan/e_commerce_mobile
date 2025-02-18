import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final List<dynamic> cartItems;

  const CheckoutScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _userName = '';
  String _userEmail = '';
  String _userPhone = '';
  String _alamatPengiriman = '';
  double _totalPrice = 0.0;
  String _userId = '';
  double _ongkir = 2500.0;  // Ongkir tetap Rp. 2500

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _calculateTotalPrice();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('username') ?? 'Nama Tidak Ditemukan';
      _userEmail = prefs.getString('email') ?? 'Email Tidak Ditemukan';
      _userPhone = prefs.getString('phone') ?? 'Telepon Tidak Ditemukan';
      _alamatPengiriman = prefs.getString('alamat') ?? 'Alamat Tidak Ditemukan';
      _userId = prefs.getString('user_id') ?? '0';
    });
  }

  void _calculateTotalPrice() {
    setState(() {
      _totalPrice = widget.cartItems.fold(0, (sum, item) {
        double price = double.parse(item['price'].toString());
        int quantity = item['quantity'] as int;
        return sum + (price * quantity);
      });
      _totalPrice += _ongkir;  // Menambahkan ongkir ke total harga
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan'),
        backgroundColor: const Color(0xFF00C2E0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // Produk yang Dipesan
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 4,
                          offset: Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Produk yang Dipesan:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...widget.cartItems.map((item) {
                        return ListTile(
                          leading: Image.network(
                            'https://akademik-smp.xyz/api_produk/images/${item['gambar']}',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 24,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                          title: Text(item['name']),
                          subtitle: Text(
                              'Harga: Rp. ${item['price']} x ${item['quantity']}'),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Informasi Pengguna
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 4,
                          offset: Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Informasi Pengguna:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Nama: $_userName'),
                      Text('Email: $_userEmail'),
                      Text('Telepon: $_userPhone'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Alamat Pengiriman Input
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 4,
                          offset: Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Alamat Pengiriman',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: TextEditingController(text: _alamatPengiriman),
                        decoration: const InputDecoration(
                          hintText: "Masukkan alamat pengiriman",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _alamatPengiriman = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Total Harga dan Ongkir, serta Tombol Bayar Sekarang
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Produk: Rp. ${_totalPrice - _ongkir}',  // Total tanpa ongkir
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ongkir: Rp. $_ongkir', // Ongkir tetap
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: Rp. ${_totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00C2E0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      String orderId = "ORDER-${DateTime.now().millisecondsSinceEpoch}";

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                            totalAmount: _totalPrice,
                            orderId: orderId,
                            userId: _userId, // Sesuaikan dengan ID user yang sedang login
                            userEmail: _userEmail,
                            userPhone: _userPhone,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C2E0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Bayar Sekarang',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
