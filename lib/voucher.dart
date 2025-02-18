import 'package:flutter/material.dart';

class VoucherScreen extends StatelessWidget {
  final List<Map<String, String>> vouchers;

  const VoucherScreen({super.key, required this.vouchers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voucher Saya'),
        backgroundColor: const Color(0xFF00C2E0),
      ),
      body: vouchers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.card_giftcard, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada voucher yang tersedia',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: vouchers.length,
              itemBuilder: (context, index) {
                final voucher = vouchers[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.card_giftcard, color: Color(0xFF00C2E0)),
                    title: Text(
                      voucher['title']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(voucher['description']!),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Logika untuk menggunakan voucher
                        debugPrint('Voucher digunakan: ${voucher['title']}');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C2E0),
                      ),
                      child: const Text('Gunakan'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
