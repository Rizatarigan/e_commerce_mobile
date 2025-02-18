import 'package:flutter/material.dart';  
import 'package:shared_preferences/shared_preferences.dart';  
import 'package:gorestan/alamat.dart';  
import 'package:gorestan/editprofil.dart';  
import 'package:gorestan/pembayaran.dart';  
import 'package:gorestan/voucher.dart';  
import 'package:gorestan/pengaturan.dart';  
import 'package:gorestan/login.dart';  
  
class ProfileScreen extends StatefulWidget {  
  const ProfileScreen({super.key, required int currentIndex});  
  
  @override  
  State<ProfileScreen> createState() => _ProfileScreenState();  
}  
  
class _ProfileScreenState extends State<ProfileScreen> {  
  String _userName = '';  
  String _userEmail = '';  
  String _userPhone = '';
  String _userAlamat = '';
  
  @override  
  void initState() {  
    super.initState();  
    _loadUserData();  
  }  
  
  // Fungsi untuk mengambil data pengguna dari SharedPreferences  
  Future<void> _loadUserData() async {  
    SharedPreferences prefs = await SharedPreferences.getInstance();  
    setState(() {  
      _userName = prefs.getString('username') ?? 'Nama Tidak Ditemukan';  
      _userEmail = prefs.getString('email') ?? 'Email Tidak Ditemukan';  
      _userPhone = prefs.getString('phone') ?? 'Telepon Tidak Ditemukan';
      _userAlamat = prefs.getString('alamat') ?? 'Alamat Tidak Ditemukan';
    });  
  }  
  
  // Fungsi logout untuk menghapus data dari SharedPreferences  
 void _logout() async {  
    SharedPreferences prefs = await SharedPreferences.getInstance();  
    await prefs.setBool('isLoggedIn', false); // Set status login ke false  
    await prefs.remove('username'); // Menghapus username  
    await prefs.remove('email'); // Menghapus email  
    await prefs.remove('phone'); // Menghapus telepon   // Menghapus semua data yang disimpan  
    await prefs.remove('alamat'); // Menghapus alamat
    Navigator.pushReplacement(  
      context,  
      MaterialPageRoute(builder: (context) => const LoginPage()),  
    );  

  }  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        title: const Text('Profil'),  
        actions: [  
          IconButton(  
            icon: const Icon(Icons.edit),  
            onPressed: () {  
              Navigator.push(  
                context,  
                MaterialPageRoute(  
                  builder: (context) => const EditProfilPage(),  
                ),  
              );  
            },  
          ),  
        ],  
      ),  
      body: Padding(  
        padding: const EdgeInsets.all(16.0),  
        child: Column(  
          crossAxisAlignment: CrossAxisAlignment.start,  
          children: [  
            Row(  
              mainAxisAlignment: MainAxisAlignment.spaceBetween,  
              children: [  
                Row(  
                  children: [  
                    const CircleAvatar(  
                      radius: 30,  
                      child: Icon(Icons.person, size: 30),  
                    ),  
                    const SizedBox(width: 16),  
                    Column(  
                      crossAxisAlignment: CrossAxisAlignment.start,  
                      children: [  
                        Text(  
                          _userName,  
                          style: const TextStyle(  
                            fontSize: 20,  
                            fontWeight: FontWeight.bold,  
                          ),  
                        ),  
                        const SizedBox(height: 4),  
                        Text(  
                          _userEmail,  
                          style: const TextStyle(fontSize: 14),  
                        ),  
                        const SizedBox(height: 4),  
                        Text(  
                          _userPhone,  
                          style: const TextStyle(fontSize: 14),  
                        ),  
                        const SizedBox(height: 4),
                        Text(
                          _userAlamat,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),

                ElevatedButton(  
                  onPressed: _logout,  
                  child: const Text('Logout'),  
                ),  
              ],  
            ),  
            const SizedBox(height: 32),  
            Expanded(  
              child: ListView(  
                children: [  
                  _buildListTile(  
                    title: 'Voucher',  
                    trailingIcon: Icons.arrow_forward_ios,  
                    onPressed: () {  
                      Navigator.push(  
                        context,  
                        MaterialPageRoute(  
                          builder: (context) => const VoucherScreen(vouchers: []),  
                        ),  
                      );  
                    },  
                  ),  
                  _buildListTile(  
                    title: 'Metode Pembayaran',  
                    trailingIcon: Icons.arrow_forward_ios,  
                    onPressed: () {  
                      Navigator.push(  
                        context,  
                        MaterialPageRoute(  
                          builder: (context) => const PaymentPage(),  
                        ),  
                      );  
                    },  
                  ),  
                  _buildListTile(  
                    title: 'Alamat Favorit',  
                    trailingIcon: Icons.arrow_forward_ios,  
                    onPressed: () {  
                      Navigator.push(  
                        context,  
                        MaterialPageRoute(  
                          builder: (context) => const AlamatPage(),  
                        ),  
                      );  
                    },  
                  ),  
                  _buildListTile(  
                    title: 'Pengaturan',  
                    trailingIcon: Icons.arrow_forward_ios,  
                    onPressed: () {  
                      Navigator.push(  
                        context,  
                        MaterialPageRoute(  
                          builder: (context) => const PengaturanPage(),  
                        ),  
                      );  
                    },  
                  ),  
                ],  
              ),  
            ),  
          ],  
        ),  
      ),  
    );  
  }  
  
  Widget _buildListTile({  
    required String title,  
    required IconData trailingIcon,  
    required VoidCallback onPressed,  
  }) {  
    return ListTile(  
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),  
      title: Text(  
        title,  
        style: const TextStyle(fontSize: 16),  
      ),  
      trailing: Icon(trailingIcon, size: 20),  
      onTap: onPressed,  
    );  
  }  
}  
