import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TambahAlamatPage extends StatefulWidget {
  const TambahAlamatPage({super.key});

  @override
  _TambahAlamatPageState createState() => _TambahAlamatPageState();
}

class _TambahAlamatPageState extends State<TambahAlamatPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _kotaController = TextEditingController();
  final TextEditingController _provinsiController = TextEditingController();
  final TextEditingController _kodePosController = TextEditingController();
  bool _isPrimary = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
  }

  Future<void> tambahAlamat() async {
    const String apiUrl = 'https://akademik-smp.xyz/api_produk/add_address.php';

    // Validasi input
    if (_namaController.text.isEmpty ||
        _teleponController.text.isEmpty ||
        _alamatController.text.isEmpty ||
        _kotaController.text.isEmpty ||
        _provinsiController.text.isEmpty ||
        _kodePosController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi.')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Tampilkan indikator loading
    });

    // Ambil user_id dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId =
        prefs.getInt('user_id') ?? 1; // Ganti dengan ID pengguna yang sesuai

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'nama_penerima': _namaController.text
            .trim(), // Sesuaikan dengan nama field di backend
        'telepon': _teleponController.text
            .trim(), // Sesuaikan dengan nama field di backend
        'alamat': _alamatController.text.trim(),
        'kota': _kotaController.text.trim(), // Tambahkan kota

        'provinsi': _provinsiController.text.trim(), // Tambahkan provinsi
        'kode_pos': _kodePosController.text.trim(), // Tambahkan kode pos
        'is_primary': _isPrimary,
      }),
    );

    setState(() {
      _isLoading = false; // Sembunyikan indikator loading
    });

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
        const SnackBar(content: Text('Gagal menambahkan alamat.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Alamat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama Penerima'),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _teleponController,
              decoration: const InputDecoration(labelText: 'Nomor Telepon'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _alamatController,
              decoration: const InputDecoration(labelText: 'Alamat'),
              maxLines: 3,
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _kotaController,
              decoration: const InputDecoration(labelText: 'Kota'),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _provinsiController,
              decoration: const InputDecoration(labelText: 'Provinsi'),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _kodePosController,
              decoration: const InputDecoration(labelText: 'Kode Pos'),
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
              onPressed: _isLoading ? null : tambahAlamat,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Simpan Alamat'),
            ),
          ],
        ),
      ),
    );
  }
}
