import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditAlamatPage extends StatefulWidget {
  final int id; // ID alamat yang akan diedit
  final String nama;
  final String nomorTelepon;
  final String alamat;
  final bool isPrimary;

  const EditAlamatPage({
    Key? key,
    required this.id,
    required this.nama,
    required this.nomorTelepon,
    required this.alamat,
    required this.isPrimary,
  }) : super(key: key);

  @override
  _EditAlamatPageState createState() => _EditAlamatPageState();
}

class _EditAlamatPageState extends State<EditAlamatPage> {
  late TextEditingController _namaController;
  late TextEditingController _teleponController;
  late TextEditingController _alamatController;
  late bool _isPrimary;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.nama);
    _teleponController = TextEditingController(text: widget.nomorTelepon);
    _alamatController = TextEditingController(text: widget.alamat);
    _isPrimary = widget.isPrimary;
  }

  Future<void> updateAlamat() async {
    const String apiUrl = 'https://akademik-smp.xyz/api/alamat/update.php';

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': widget.id,
        'nama': _namaController.text.trim(),
        'nomor_telepon': _teleponController.text.trim(),
        'alamat': _alamatController.text.trim(),
        'is_primary': _isPrimary,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );
      if (responseData['status'] == 'success') {
        Navigator.pop(context); // Kembali ke halaman sebelumnya
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui alamat.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Alamat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _teleponController,
              decoration: const InputDecoration(labelText: 'Nomor Telepon'),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _alamatController,
              decoration: const InputDecoration(labelText: 'Alamat'),
              maxLines: 3,
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Checkbox(
                  value: _isPrimary,
                  onChanged: (value) {
                    setState(() {
                      _isPrimary = value!;
                    });
                  },
                ),
                const Text('Jadikan sebagai alamat utama'),
              ],
            ),
            ElevatedButton(
              onPressed: updateAlamat,
              child: const Text('Perbarui Alamat'),
            ),
          ],
        ),
      ),
    );
  }
}
