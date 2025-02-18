import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'trackingpage.dart'; // Halaman TrackingPage

class PesananPage extends StatefulWidget {
  final String userId;

  const PesananPage({Key? key, required this.userId}) : super(key: key);

  @override
  _PesananPageState createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  bool isLoading = true;
  String errorMessage = '';
  List<dynamic> pesananList = [];

  @override
  void initState() {
    super.initState();
    _fetchPesanan();
  }

  Future<void> _fetchPesanan() async {
    final url = Uri.parse(
      "https://akademik-smp.xyz/api_produk/get_pesanan.php?user_id=${widget.userId}"
    );

    debugPrint("[Dart] GET Pesanan URL: $url");

    try {
      final response = await http.get(url);

      debugPrint("[Dart] Response code: ${response.statusCode}");
      debugPrint("[Dart] Response body: ${response.body}");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        debugPrint("[Dart] Result: $result");

        // Pastikan data yang diterima adalah sebuah list
        if (result["status"] == "success") {
          setState(() {
            pesananList = List.from(result["data"]); // Data yang diambil adalah List
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = result["message"] ?? "Unknown error";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "HTTP Error: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("[Dart] Exception: $e");
      setState(() {
        errorMessage = "Exception: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00C2E0),
        title: const Text(
          'Pesanan',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : pesananList.isEmpty
                  ? _buildEmptyPesanan() // Jika kosong
                  : _buildListPesanan()  // Jika ada data
              ),
    );
  }

  // Widget jika daftar pesanan masih kosong
  Widget _buildEmptyPesanan() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo_gorestan.png',
            width: 300,
            height: 300,
          ),
          const SizedBox(height: 20),
          const Text(
            'Pesanan kosong, pesan sekarang!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // Widget jika ada data pesanan
  Widget _buildListPesanan() {
    return ListView.builder(
      itemCount: pesananList.length,
      itemBuilder: (context, index) {
        final item = pesananList[index]; // Akses item dalam list
        final idOrder = item["id_order"];
        final orderNumber = item["order_number"]; // order_number harus String
        final nama = item["nama_user"];
        final email = item["email"];
        final telepon = item["telepon"];
        final total = item["total_pesanan"];
        final status = item["payment_status"];
        final created = item["created_at"];

        debugPrint("[Dart] Pesanan Item: $item");

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text("Order #$orderNumber - $nama"),
            subtitle: Text(
              "Email: $email\n"
              "Telepon: $telepon\n"
              "Total Pesanan: $total\n"
              "Status Transaksi: $status\n"
              "Tanggal: $created",
            ),
            onTap: () {
              // Navigasi ke halaman tracking saat pesanan diklik
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrackingPage(
                    orderId: orderNumber, // Pass orderNumber (String)
                    paymentStatus: status, // Pass payment status untuk menentukan tampilan
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
