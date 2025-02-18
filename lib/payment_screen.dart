import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;
  final String orderId;
  final String userId;
  final String userEmail;
  final String userPhone;

  const PaymentScreen({
    Key? key,
    required this.totalAmount,
    required this.orderId,
    required this.userId,
    required this.userEmail,
    required this.userPhone,
    
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? paymentUrl;
  bool isLoading = true;
  late WebViewController _webViewController;

 @override
void initState() {
  super.initState();
  _initializeWebView();
  _startPayment();
}

void _initializeWebView() {
  _webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(NavigationDelegate(
      onNavigationRequest: (navigation) {
        final url = navigation.url;

        // LOGIC: Jika URL mengarah ke "myapp://payment_success",
        // kita tangkap, lalu pindahkan user ke SuccessScreen
        if (url.startsWith('myapp://payment_success')) {
          // Ambil order_id dari URL
          // misal: myapp://payment_success?order_id=12345
          Uri uri = Uri.parse(url);
          String? orderId = uri.queryParameters['order_id'];

          // Navigasi ke SuccessScreen
          if (orderId != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SuccessScreen(
                  orderId: orderId,
                  userId: widget.userId, // <-- Berikan nilai userId
                ),
              ),
            );
          }
          // Return "NavigationDecision.prevent" 
          // agar WebView tidak mencoba membuka link ini
          return NavigationDecision.prevent;
        }

        // Jika URL biasa, lanjutkan saja
        return NavigationDecision.navigate;
      },
      onPageFinished: (url) {
        setState(() {
          isLoading = false;
        });
      },
    ));
}

  Future<void> _startPayment() async {
    const String apiUrl =
        "https://akademik-smp.xyz/api_produk/process_payment.php";

    final Map<String, dynamic> requestBody = {
      "user_id": widget.userId,
      "amount": widget.totalAmount,
      "order_id": widget.orderId,
      "email": widget.userEmail,
      "phone": widget.userPhone,
      "payment_type": "gopay" // Bisa diubah sesuai metode pembayaran
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody["status"] == "success") {
          setState(() {
            paymentUrl = responseBody["redirect_url"] ?? "";
            _webViewController.loadRequest(Uri.parse(paymentUrl!));
            isLoading = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseBody["message"])),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal memproses pembayaran")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pembayaran")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: _webViewController),
    );
  }
}
