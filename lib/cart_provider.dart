import 'package:flutter/material.dart';
import 'login_service.dart'; // Pastikan Anda mengimpor LoginService

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _items = [];
  final LoginService _loginService =
      LoginService(); // Inisialisasi LoginService

  List<Map<String, dynamic>> get items => _items;

  // Method untuk mengupdate quantity produk
  void updateQuantity(int index, int newQuantity) {
    if (index >= 0 && index < _items.length) {
      _items[index]['quantity'] = newQuantity;
      notifyListeners();
    }
  }

  // Method untuk menambahkan produk ke keranjang
  Future<void> addToCart(Map<String, dynamic> product) async {
    // Cek apakah pengguna sudah login
    bool isLoggedIn = await _loginService.isLoggedIn();

    if (!isLoggedIn) {
      // Jika belum login, tampilkan pesan atau lakukan tindakan lain
      throw Exception('User not logged in');
    }

    // Cek apakah produk sudah ada di keranjang
    int index = _items.indexWhere((item) => item['id'] == product['id']);
    if (index >= 0) {
      updateQuantity(index, _items[index]['quantity'] + 1);
    } else {
      // Jika tidak ada, tambahkan produk baru dengan kuantitas 1
      _items.add({...product, 'quantity': 1});
      notifyListeners(); // Notifikasi perubahan state
    }
  }

  // Method untuk menghapus produk dari keranjang
  void removeFromCart(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners(); // Notifikasi perubahan state
    }
  }

  // Method untuk menghapus semua produk dari keranjang
  void clearCart() {
    _items.clear();
    notifyListeners(); // Notifikasi perubahan state
  }
}
