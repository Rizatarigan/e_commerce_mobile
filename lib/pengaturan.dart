import 'package:flutter/material.dart';

class PengaturanPage extends StatelessWidget {
  const PengaturanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: const Color(0xFF00C2E0),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Pengaturan Umum',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          _SettingsTile(
            icon: Icons.notifications,
            title: 'Notifikasi',
            subtitle: 'Atur preferensi notifikasi kamu',
            onTap: () {
              // Tambahkan navigasi atau aksi di sini
            },
          ),
          _SettingsTile(
            icon: Icons.palette,
            title: 'Tema Aplikasi',
            subtitle: 'Ubah tampilan aplikasi',
            onTap: () {
              // Tambahkan navigasi atau aksi di sini
            },
          ),
          _SettingsTile(
            icon: Icons.lock,
            title: 'Privasi',
            subtitle: 'Kelola pengaturan privasi',
            onTap: () {
              // Tambahkan navigasi atau aksi di sini
            },
          ),
          _SettingsTile(
            icon: Icons.language,
            title: 'Bahasa',
            subtitle: 'Pilih bahasa aplikasi',
            onTap: () {
              // Tambahkan navigasi atau aksi di sini
            },
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Lainnya',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          _SettingsTile(
            icon: Icons.info,
            title: 'Tentang Aplikasi',
            subtitle: 'Informasi tentang aplikasi',
            onTap: () {
              // Tambahkan navigasi atau aksi di sini
            },
          ),
          _SettingsTile(
            icon: Icons.logout,
            title: 'Keluar',
            subtitle: 'Keluar dari akun',
            onTap: () {
              // Tambahkan aksi logout di sini
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
