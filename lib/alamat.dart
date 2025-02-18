import 'package:flutter/material.dart';
import 'package:gorestan/tambah_alamat.dart';
import 'edit_alamat.dart'; // Import halaman EditAlamatPage

class AlamatPage extends StatelessWidget {
  const AlamatPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Contoh data alamat, seharusnya diambil dari API atau database
    final List<Address> addresses = [
      Address(
        id: 1,
        name: 'Renaga',
        phoneNumber: '+6282217809999',
        address:
            'Jl. Sari Asih No.54, Sarijadi, Kec. Sukasari, Kota Bandung, Jawa Barat 40151',
        isPrimary: true,
      ),
      Address(
        id: 2,
        name: 'Nurul Faujiah',
        phoneNumber: '+6283148573007',
        address:
            'Jl. Sari Asih No.54, Sarijadi, Kec. Sukasari, Kota Bandung, Jawa Barat 40151',
        isPrimary: false,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alamat Saya'),
        backgroundColor: const Color(0xFF00C2E0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigasi kembali ke halaman sebelumnya
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var address in addresses)
              AddressCard(
                id: address.id,
                name: address.name,
                phoneNumber: address.phoneNumber,
                address: address.address,
                isPrimary: address.isPrimary,
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditAlamatPage(
                        id: address.id,
                        nama: address.name,
                        nomorTelepon: address.phoneNumber,
                        alamat: address.address,
                        isPrimary: address.isPrimary,
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 32.0),
            Center(
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TambahAlamatPage(), // Navigasi ke TambahAlamatPage
                    ),
                  );
                },
                tooltip: 'Tambah Alamat',
                child: const Icon(Icons.add),
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Address {
  final int id;
  final String name;
  final String phoneNumber;
  final String address;
  final bool isPrimary;

  Address({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.isPrimary,
  });
}

class AddressCard extends StatelessWidget {
  final int id; // ID untuk setiap alamat
  final String name;
  final String phoneNumber;
  final String address;
  final bool isPrimary;
  final VoidCallback onEdit; // Callback untuk tombol edit

  const AddressCard({
    Key? key,
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.isPrimary,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isPrimary ? Colors.blue : Colors.black,
                    ),
                  ),
                ),
                if (isPrimary)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Utama',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              phoneNumber,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              address,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
