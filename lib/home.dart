import 'package:flutter/material.dart';
import 'package:gorestan/cart_provider.dart';
import 'package:gorestan/mrbox.dart'; // Pastikan sudah ada file mrbox.dart
import 'package:gorestan/shop.dart'; // Pastikan sudah ada file shop.dart
import 'package:gorestan/pesanan.dart'; // Pastikan sudah ada file pesanan.dart
import 'package:gorestan/akun.dart'; // Pastikan sudah ada file akun.dart
import 'package:gorestan/keranjang.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {  
  String _username = 'Username Tidak Ditemukan';  
  String _email = 'Email Tidak Ditemukan';  
  String _phone = 'Telepon Tidak Ditemukan';
  String _myUserId = '';
  int _currentIndex = 0;
  bool _isLoading = true;

  // Daftar halaman untuk navigasi
  List<Widget> get _pages => [
    const FoodHomePageContent(),
    const MrBoxPage(),
    ShopPage(),
    PesananPage(userId: _myUserId), // <-- Mengambil dari state
    const ProfileScreen(currentIndex: 4),
  ];

  @override  
  void initState() {  
    super.initState();  
    _loadUserData();  
  }  
  
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _myUserId = prefs.getString('user_id') ?? '';
      _isLoading = false;
    });
  }

  void _addToCart(Map<String, dynamic> product) async {  
    // Memeriksa apakah pengguna sudah login  
    SharedPreferences prefs = await SharedPreferences.getInstance();  
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;  
  
    if (!isLoggedIn) {  
      // Tampilkan dialog jika pengguna belum login  
      showDialog(  
        context: context,  
        builder: (context) => AlertDialog(  
          title: const Text('Login Diperlukan'),  
          content: const Text('Silakan login terlebih dahulu untuk menambahkan produk ke keranjang.'),  
          actions: [  
            TextButton(  
              onPressed: () {  
                Navigator.pop(context);  
              },  
              child: const Text('OK'),  
            ),  
          ],  
        ),  
      );  
    } else {  
      // Jika sudah login, tambahkan produk ke keranjang  
      Provider.of<CartProvider>(context, listen: false).addToCart(product);  
      ScaffoldMessenger.of(context).showSnackBar(  
        SnackBar(  
          content: Text('${product['name']} berhasil ditambahkan ke keranjang!'),  
        ),  
      );  
    }  
  }
    @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Daftar halaman untuk navigasi (menggunakan _myUserId)
    final List<Widget> _pages = [
      const FoodHomePageContent(),
      const MrBoxPage(),
      ShopPage(),
      PesananPage(userId: _myUserId), // <-- Sediakan userId di sini
      const ProfileScreen(currentIndex: 4),
    ];
    
    return Scaffold(
      body: _pages[_currentIndex], // Menampilkan halaman sesuai dengan indeks saat ini
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Perbarui indeks saat item dipilih
          });
        },
        selectedItemColor: Colors.blue, // Warna item aktif
        unselectedItemColor: Colors.black, // Warna item tidak aktif
        backgroundColor: Colors.white, // Latar belakang BottomNavigationBar
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Mr. Box',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Re-Food',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}

class FoodHomePageContent extends StatelessWidget {
  const FoodHomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari produk...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Color(0xFF00C2E0)),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: Stack(
                    children: [
                      const Icon(Icons.shopping_cart,
                          color: Color(0xFF00C2E0)), // Ikon keranjang
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '3', // Jumlah produk
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => KeranjangScreen(),
  ),
);

                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Main Image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 5)
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                    'assets/images/poster.png',
                  width: double.infinity,
                ),

              ),
            ),
            const SizedBox(height: 20),

            // Info Section
            Column(
              children: [
                // Bar di atas Info Bar
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 5),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Teks dan logo Mr-Box
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MrBoxPage(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory, // Ikon untuk Mr-Box
                                size: 20,
                                color: Colors.black54,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Mr-Box',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Garis pembatas
                      Container(
                        height: 20,
                        width: 1,
                        color: Colors.black12,
                      ),
                      // Teks dan logo Re-food
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShopPage(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.fastfood, // Ikon untuk Re-Food
                                size: 20,
                                color: Colors.black54,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Re-Food',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Info Bar
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 5),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      infoIcon(Icons.person, 'Silver'),
                      infoIcon(Icons.attach_money, '100.000'),
                      infoIcon(Icons.card_giftcard, '1 Voucher'),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Categories Section
            buildCategorySection(),
            const SizedBox(height: 20),

            // Produk Section
            buildProductSection(context),
          ],
        ),
      ),
    );
  }

  Widget infoIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.grey[700]),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget buildCategorySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kategori',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            children: [
              categoryIcon(Icons.fastfood, 'Makanan Berat'),
              categoryIcon(Icons.cookie, 'Camilan'),
              categoryIcon(Icons.cake, 'Roti dan Kue'),
              categoryIcon(Icons.local_drink, 'Minuman'),
              categoryIcon(Icons.apple, 'Buah'),
              categoryIcon(Icons.set_meal, 'Bahan'),
              categoryIcon(Icons.eco, 'Vegan'),
              categoryIcon(Icons.more_horiz, 'Lainnya'),
            ],
          ),
        ],
      ),
    );
  }

  Widget categoryIcon(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: const Color(0xFFE0F7FA),
          child: Icon(icon, color: const Color(0xFF00C2E0)),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget buildProductSection(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Produk Terbaru',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return buildContentBox(
              context,
              'Produk $index',
              'https://placehold.co/150x150',
              '\$${(index + 1) * 10}',
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShopPage(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildContentBox(
    BuildContext context,
    String title,
    String imageUrl,
    String price,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(imageUrl, height: 100, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title, style: const TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(price, style: const TextStyle(fontSize: 14, color: Colors.green)),
            ),
          ],
        ),
      ),
    );
  }
}
