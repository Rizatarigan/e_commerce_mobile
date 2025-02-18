import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metode Pembayaran'),
        backgroundColor: const Color(0xFF00C2E0),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'Metode Pembayaran',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            PaymentMethodCard(
              title: 'Stan Pay',
              subtitle: 'Saldo kamu: Rp100.000',
              icon: Icons.account_balance_wallet,
              trailing: ElevatedButton(
                onPressed: () {
                  // Tambahkan fungsi top up di sini
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  textStyle: const TextStyle(fontSize: 14),
                ),
                child: const Text('Top Up'),
              ),
            ),
            PaymentMethodCard(
              title: 'OVO',
              subtitle: 'Saldo kamu: Rp100.000',
              icon: Icons.account_balance_wallet,
            ),
            PaymentMethodCard(
              title: 'GOPAY',
              subtitle: 'Saldo kamu: Rp100.000',
              icon: Icons.account_balance_wallet,
            ),
            PaymentMethodCard(
              title: 'SHOPEEPAY',
              subtitle: 'Saldo kamu: Rp100.000',
              icon: Icons.account_balance_wallet,
            ),
            PaymentMethodCard(
              title: 'TRANSFER BANK',
              subtitle: 'Gunakan metode ini untuk transfer manual',
              icon: Icons.account_balance,
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? trailing;

  const PaymentMethodCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4.0,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Icon(icon, color: Colors.blue),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          trailing: trailing ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}
