import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// Import KeranjangScreen
import 'pesanan.dart';

class SuccessScreen extends StatefulWidget {
  final String orderId;
  final String userId;

  const SuccessScreen({Key? key, required this.orderId, required this.userId}) : super(key: key);

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  String statusMessage = 'Memuat...';
  bool isSuccess = false; // Menampilkan ikon ceklis

  @override
  void initState() {
    super.initState();
    _getTransactionStatus(widget.orderId);
  }

  Future<void> _getTransactionStatus(String orderId) async {
    final url = Uri.parse(
      "https://akademik-smp.xyz/api_produk/payment_success.php?order_id=$orderId&json=1",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Contoh data:
        // { "status": "success", "message": "Transaksi berhasil!" }

        setState(() {
          if (data["status"] == "success") {
            isSuccess = true;
          }
          statusMessage = data["message"] ?? "Tidak ada pesan.";
        });
      } else {
        setState(() {
          statusMessage = "Gagal memanggil API. Code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        statusMessage = "Terjadi kesalahan: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Status Transaksi"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSuccess)
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 100,
                )
              else
                const Icon(
                  Icons.info_outline,
                  color: Colors.orange,
                  size: 100,
                ),
              const SizedBox(height: 16),
              Text(
                statusMessage,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Tombol ke Halaman Keranjang
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PesananPage(
                        userId: widget.userId, // misal userId di successScreen
                      ),
                    ),
                  );
                },
                child: const Text("Lihat Pesanan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
