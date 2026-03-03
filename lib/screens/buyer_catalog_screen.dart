import 'package:flutter/material.dart';
import 'product_detail_screen.dart';

class BuyerCatalogScreen extends StatefulWidget {
  final String userName;
  
  const BuyerCatalogScreen({super.key, required this.userName});

  @override
  State<BuyerCatalogScreen> createState() => _BuyerCatalogScreenState();
}

class _BuyerCatalogScreenState extends State<BuyerCatalogScreen> {
  int _selectedTabIndex = 0; // 0: Ikan Segar, 1: Produk Olahan
  int _selectedNavIndex = 0; // Bottom navigation index

  // Sample fish data
  final List<Map<String, dynamic>> _fishProducts = [
    {
      'name': 'Ikan Nila Merah',
      'category': 'Budidaya Air Deras',
      'price': 35000,
      'stock': '45 kg',
      'isBestSeller': true,
      'isPreOrder': false,
      'imageUrl': 'https://via.placeholder.com/342x224/0077B6/FFFFFF?text=Ikan+Nila',
    },
    {
      'name': 'Ikan Bawal Bintang',
      'category': 'Premium Quality',
      'price': 65000,
      'stock': 'Besok Pagi',
      'isBestSeller': false,
      'isPreOrder': true,
      'imageUrl': 'https://via.placeholder.com/342x224/023E8A/FFFFFF?text=Ikan+Bawal',
    },
    {
      'name': 'Ikan Lele Sangkuriang',
      'category': 'Farm Fresh Hygiene',
      'price': 24000,
      'stock': '80 kg',
      'isBestSeller': false,
      'isPreOrder': false,
      'imageUrl': 'https://via.placeholder.com/342x224/0096C7/FFFFFF?text=Ikan+Lele',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Main Content
          Column(
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: Column(
                      children: [
                        // Top Bar with greeting and icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MARKETPLACE SEGARA',
                                  style: TextStyle(
                                    color: const Color(0xFF0077B6),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Selamat Datang,\n',
                                        style: TextStyle(
                                          color: const Color(0xFF0F172A),
                                          fontSize: 24,
                                          fontWeight: FontWeight.w800,
                                          height: 1.25,
                                        ),
                                      ),
                                      TextSpan(
                                        text: widget.userName,
                                        style: TextStyle(
                                          color: const Color(0xFF0077B6),
                                          fontSize: 24,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                // Notification icon
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFF1F5F9),
                                      width: 1,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.05),
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Icon(
                                          Icons.notifications_outlined,
                                          size: 18,
                                          color: const Color(0xFF475569),
                                        ),
                                      ),
                                      Positioned(
                                        right: 9,
                                        top: 9,
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEF4444),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Profile picture
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE2E8F0),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.10),
                                        blurRadius: 6,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Icon(
                                      Icons.person,
                                      size: 24,
                                      color: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Search Bar
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: const Color(0xFFF1F5F9),
                              width: 1,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.05),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Cari ikan segar atau olahan...',
                              hintStyle: TextStyle(
                                color: const Color(0xFF94A3B8),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 16, right: 12),
                                child: Icon(
                                  Icons.search,
                                  size: 18,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Category Tabs
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.05),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedTabIndex = 0;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _selectedTabIndex == 0 
                                          ? Colors.white 
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: _selectedTabIndex == 0 ? const [
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.05),
                                          blurRadius: 2,
                                          offset: Offset(0, 1),
                                        ),
                                      ] : null,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.waves,
                                          size: 16,
                                          color: _selectedTabIndex == 0 
                                              ? const Color(0xFF0077B6) 
                                              : const Color(0xFF64748B),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Ikan Segar',
                                          style: TextStyle(
                                            color: _selectedTabIndex == 0 
                                                ? const Color(0xFF0077B6) 
                                                : const Color(0xFF64748B),
                                            fontSize: 14,
                                            fontWeight: _selectedTabIndex == 0 
                                                ? FontWeight.w700 
                                                : FontWeight.w600,
                                            height: 1.43,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedTabIndex = 1;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _selectedTabIndex == 1 
                                          ? Colors.white 
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: _selectedTabIndex == 1 ? const [
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.05),
                                          blurRadius: 2,
                                          offset: Offset(0, 1),
                                        ),
                                      ] : null,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.restaurant,
                                          size: 16,
                                          color: _selectedTabIndex == 1 
                                              ? const Color(0xFF0077B6) 
                                              : const Color(0xFF64748B),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Produk Olahan',
                                          style: TextStyle(
                                            color: _selectedTabIndex == 1 
                                                ? const Color(0xFF0077B6) 
                                                : const Color(0xFF64748B),
                                            fontSize: 14,
                                            fontWeight: _selectedTabIndex == 1 
                                                ? FontWeight.w700 
                                                : FontWeight.w600,
                                            height: 1.43,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Product List
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Panen Hari Ini',
                            style: TextStyle(
                              color: const Color(0xFF1E293B),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              height: 1.4,
                            ),
                          ),
                          Text(
                            'Update: 08:00 WIB',
                            style: TextStyle(
                              color: const Color(0xFF94A3B8),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1.33,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Product Cards
                      ...List.generate(
                        _fishProducts.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: _buildProductCard(_fishProducts[index]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Bottom Navigation Bar
          Positioned(
            left: 24,
            right: 24,
            bottom: 20,
            child: _buildBottomNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.06),
              blurRadius: 30,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: Container(
                  height: 224,
                  width: double.infinity,
                  color: const Color(0xFFE2E8F0),
                  child: Image.network(
                    product['imageUrl'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFE2E8F0),
                        child: Center(
                          child: Icon(
                            Icons.image,
                            size: 48,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Badge (Best Seller or Pre-Order)
              if (product['isBestSeller'])
                Positioned(
                  left: 16,
                  top: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.90),
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.05),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      'BEST SELLER',
                      style: TextStyle(
                        color: const Color(0xFF0077B6),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              
              if (product['isPreOrder'])
                Positioned(
                  left: 16,
                  top: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7).withOpacity(0.90),
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.05),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 10,
                          color: const Color(0xFFB45309),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'PRE-ORDER',
                          style: TextStyle(
                            color: const Color(0xFFB45309),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              // Price Badge
              Positioned(
                left: 16,
                bottom: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.60),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HARGA PER KG',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.80),
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Rp ${product['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          height: 1.55,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Product Info
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'],
                            style: TextStyle(
                              color: const Color(0xFF1E293B),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              height: 1.55,
                            ),
                          ),
                          Text(
                            product['category'],
                            style: TextStyle(
                              color: const Color(0xFF64748B),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1.33,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          product['isPreOrder'] ? 'ESTIMASI PANEN' : 'STOK HARI INI',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: const Color(0xFF94A3B8),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                        Text(
                          product['stock'],
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: product['isPreOrder'] 
                                ? const Color(0xFFD97706) 
                                : const Color(0xFF2D6A4F),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            height: 1.43,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Action Button
                Container(
                  padding: const EdgeInsets.only(top: 16),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFFF8FAFC),
                        width: 1,
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            product['isPreOrder'] 
                                ? 'Booking ${product['name']}' 
                                : 'Menambahkan ${product['name']} ke keranjang',
                          ),
                          backgroundColor: const Color(0xFF0077B6),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: product['isPreOrder'] 
                            ? const Color(0xFF0F172A) 
                            : const Color(0xFF0077B6),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: product['isPreOrder'] 
                                ? const Color.fromRGBO(0, 0, 0, 0.10) 
                                : const Color(0xFFBFDBFE),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            product['isPreOrder'] 
                                ? Icons.bookmark_outline 
                                : Icons.shopping_cart_outlined,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            product['isPreOrder'] 
                                ? 'Booking Sekarang' 
                                : 'Tambah ke Keranjang',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 1.43,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 74,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.40),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurRadius: 50,
            offset: Offset(0, 25),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Nav Items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 0),
              _buildNavItem(Icons.local_offer_outlined, 1),
              const SizedBox(width: 56), // Space for center button
              _buildNavItem(Icons.receipt_long_outlined, 3),
              _buildNavItem(Icons.person_outline, 4),
            ],
          ),
          
          // Center Floating Button
          Positioned(
            left: 0,
            right: 0,
            top: -15,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedNavIndex = 2;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Keranjang'),
                      backgroundColor: Color(0xFF0077B6),
                    ),
                  );
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0077B6), Color(0xFF0096C7)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF60A5FA).withOpacity(0.50),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.50),
                        blurRadius: 0,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _selectedNavIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: isSelected 
              ? const Color(0xFF0077B6) 
              : const Color(0xFF94A3B8),
          size: index == 0 ? 18 : 20,
        ),
      ),
    );
  }
}
