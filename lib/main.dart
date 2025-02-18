import 'package:flutter/material.dart';  
import 'package:provider/provider.dart';  
import 'cart_provider.dart'; // Tambahkan import file provider Anda  
import 'home.dart'; // Pastikan ini adalah file yang berisi HomePage  
  
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());  
}  
  
class MyApp extends StatelessWidget {  
  const MyApp({super.key});  
  
  @override  
  Widget build(BuildContext context) {  
    return ChangeNotifierProvider(  
      create: (context) => CartProvider(),  
      child: MaterialApp(  
        debugShowCheckedModeBanner: false,  
        home: const HomePage(), // Tetap menggunakan HomePage sebagai halaman utama  
      ),  
    );  
  }  
}  
