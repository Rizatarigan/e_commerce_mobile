import 'package:flutter/material.dart';

class TrackingPage extends StatelessWidget {
  final String orderId;
  final String paymentStatus;  // Tambahkan parameter paymentStatus

  const TrackingPage({
    Key? key,
    required this.orderId, // Pass orderId (String)
    required this.paymentStatus, // Pass paymentStatus (String)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Menentukan tampilan berdasarkan status pembayaran
    Widget content;
    String statusMessage;

    // Menentukan tampilan berdasarkan status pembayaran
    switch (paymentStatus) {
      case 'diproses':
        statusMessage = "Pesanan anda sedang di proses";
        content = Center(  // Gunakan Center untuk memposisikan ke tengah
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Vertikal center
            crossAxisAlignment: CrossAxisAlignment.center,  // Horizontal center
            children: [
              Icon(Icons.hourglass_empty, size: 100, color: Colors.orange),
              SizedBox(height: 20),
              Text(statusMessage, style: TextStyle(fontSize: 18)),
            ],
          ),
        );
        break;

      case 'dikirim':
        statusMessage = "Pesanan anda sedang dikirim";
        content = Center(  // Gunakan Center untuk memposisikan ke tengah
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Vertikal center
            crossAxisAlignment: CrossAxisAlignment.center,  // Horizontal center
            children: [
              Icon(Icons.local_shipping, size: 100, color: Colors.blue),
              SizedBox(height: 20),
              Text(statusMessage, style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              // Gambar Maps Dummy
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/maps_dummy.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        );
        break;

      case 'success':
        statusMessage = "Pesanan berhasil di antar";
        content = Center(  // Gunakan Center untuk memposisikan ke tengah
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Vertikal center
            crossAxisAlignment: CrossAxisAlignment.center,  // Horizontal center
            children: [
              Icon(Icons.check_circle, size: 100, color: Colors.green),
              SizedBox(height: 20),
              Text(statusMessage, style: TextStyle(fontSize: 18)),
            ],
          ),
        );
        break;

      case 'pending': // Status baru 'pending' untuk pesanan yang sedang dikemas
        statusMessage = "Pesanan anda sedang dikemas";
        content = Center(  // Gunakan Center untuk memposisikan ke tengah
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Vertikal center
            crossAxisAlignment: CrossAxisAlignment.center,  // Horizontal center
            children: [
              Icon(Icons.access_time, size: 100, color: Colors.yellow),
              SizedBox(height: 20),
              Text(statusMessage, style: TextStyle(fontSize: 18)),
            ],
          ),
        );
        break;

      default:
        statusMessage = "Status pesanan tidak diketahui";
        content = Center(
          child: Text(statusMessage, style: TextStyle(fontSize: 18)),
        );
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking Pesanan'),
        backgroundColor: const Color(0xFF00C2E0),
      ),
      body: content,
    );
  }
}
