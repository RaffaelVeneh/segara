import 'package:flutter/material.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final String role;

  const HomeScreen({
    super.key,
    required this.role,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0; // 0 = Ikan Segar, 1 = Produk Olahan

  // Produk Ikan Segar
  final List<Map<String, dynamic>> _freshFishProducts = [
    {
      'type': 'fresh',
      'name': 'Ikan Nila Merah',
      'description': 'Budidaya Air Deras',
      'price': 35000,
      'stock': '45 kg',
      'image': 'assets/images/nilaMerah.png',
      'badge': 'Best Seller',
      'badgeColor': Color(0xFF0077B6),
      'badgeBg': Color(0xFFFFFFFF),
      'buttonColor': Color(0xFF0077B6),
      'buttonText': 'Tambah ke Keranjang',
      'stockLabel': 'Stok Hari Ini',
      'stockColor': Color(0xFF2D6A4F),
    },
    {
      'type': 'fresh',
      'name': 'Ikan Bawal Bintang',
      'description': 'Premium Quality',
      'price': 65000,
      'stock': 'Besok Pagi',
      'image': 'assets/images/bawalBintang.png',
      'badge': 'Pre-Order',
      'badgeColor': Color(0xFFB45309),
      'badgeBg': Color(0xFFFEF3C7),
      'buttonColor': Color(0xFF0F172A),
      'buttonText': 'Booking Sekarang',
      'stockLabel': 'Estimasi Panen',
      'stockColor': Color(0xFFD97706),
    },
    {
      'type': 'fresh',
      'name': 'Ikan Lele Sangkuriang',
      'description': 'Farm Fresh Hygiene',
      'price': 24000,
      'stock': '80 kg',
      'image': 'assets/images/leleSangkuriang.png',
      'badge': null,
      'buttonColor': Color(0xFF0077B6),
      'buttonText': 'Tambah ke Keranjang',
      'stockLabel': 'Stok Hari Ini',
      'stockColor': Color(0xFF2D6A4F),
    },
  ];

  // Produk Olahan
  final List<Map<String, dynamic>> _processedProducts = [
    {
      'type': 'processed',
      'name': 'Fillet Nila Premium',
      'description': 'Tanpa Tulang & Duri',
      'price': 45000,
      'stock': '20 kg',
      'image': 'assets/images/nilaMerah.png',
      'badge': 'Best Seller',
      'badgeColor': Color(0xFF2563EB),
      'badgeBg': Color(0xFFDBEAFE),
      'buttonColor': Color(0xFF0077B6),
      'buttonText': 'Tambah ke Keranjang',
      'stockLabel': 'Stok Hari Ini',
      'stockColor': Color(0xFF2D6A4F),
    },
    {
      'type': 'processed',
      'name': 'Nugget Ikan Nila',
      'description': 'Siap Goreng - 500g',
      'price': 35000,
      'stock': '50 pack',
      'image': 'assets/images/nilaMerah.png',
      'badge': 'Praktis',
      'badgeColor': Color(0xFFEA580C),
      'badgeBg': Color(0xFFFFEDD5),
      'buttonColor': Color(0xFF0077B6),
      'buttonText': 'Tambah ke Keranjang',
      'stockLabel': 'Stok Tersedia',
      'stockColor': Color(0xFF2D6A4F),
    },
    {
      'type': 'processed',
      'name': 'Bakso Ikan Lele',
      'description': 'Kemasan 500g',
      'price': 28000,
      'stock': '35 pack',
      'image': 'assets/images/leleSangkuriang.png',
      'badge': null,
      'buttonColor': Color(0xFF0077B6),
      'buttonText': 'Tambah ke Keranjang',
      'stockLabel': 'Stok Tersedia',
      'stockColor': Color(0xFF2D6A4F),
    },
  ];

  // Produk Olahan untuk Grid (2 kolom)
  final List<Map<String, dynamic>> _processedGridProducts = [
    {
      'type': 'processed',
      'name': 'Nugget Ikan',
      'description': 'Original - 500g',
      'price': 35000,
      'image': 'assets/images/nilaMerah.png',
      'badge': 'Siap Masak',
      'badgeColor': Color(0xFF2563EB),
      'badgeBg': Color(0xFFDBEAFE),
    },
    {
      'type': 'processed',
      'name': 'Bakso Ikan',
      'description': 'Per Pack 500g',
      'price': 28000,
      'image': 'assets/images/leleSangkuriang.png',
      'badge': 'Praktis',
      'badgeColor': Color(0xFFEA580C),
      'badgeBg': Color(0xFFFFEDD5),
    },
    {
      'type': 'processed',
      'name': 'Sosis Ikan Premium',
      'description': 'Bumbu Spesial 500g',
      'price': 42000,
      'image': 'assets/images/bawalBintang.png',
      'badge': 'Best Seller',
      'badgeColor': Color(0xFF0077B6),
      'badgeBg': Color(0xFFFFFFFF),
    },
    {
      'type': 'processed',
      'name': 'Otak-otak Ikan',
      'description': 'Tradisional 400g',
      'price': 32000,
      'image': 'assets/images/nilaMerah.png',
      'badge': 'Terlaris',
      'badgeColor': Color(0xFFEA580C),
      'badgeBg': Color(0xFFFFEDD5),
      'discount': '-10%',
    },
  ];

  // Getter untuk produk yang aktif
  List<Map<String, dynamic>> get _activeProducts {
    return _selectedTab == 0 ? _freshFishProducts : _processedProducts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            _buildHeader(),

            // Products Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Panen Hari Ini',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const Text(
                        'Update: 08:00 WIB',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Conditional: Large cards for Ikan Segar, Grid for Produk Olahan
                  if (_selectedTab == 0)
                    // Ikan Segar - Large Product Cards
                    ..._activeProducts.map((product) => Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: _buildLargeProductCard(product),
                        ))
                  else
                    // Produk Olahan - 2 Column Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 15,
                        childAspectRatio: 0.52, // Reduced to give more height and fix overflow
                      ),
                      itemCount: _processedGridProducts.length,
                      itemBuilder: (context, index) {
                        return _buildGridProductCard(_processedGridProducts[index]);
                      },
                    ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Welcome & Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MARKETPLACE SEGARA',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0077B6),
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Selamat Datang,\n',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                                height: 1.25,
                              ),
                            ),
                            TextSpan(
                              text: 'Marsidi',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0077B6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Notification Icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0D000000),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            const Center(
                              child: Icon(
                                Icons.notifications_outlined,
                                size: 20,
                                color: Color(0xFF475569),
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
                                  border: Border.all(color: Colors.white, width: 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Avatar
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1A000000),
                              blurRadius: 6,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            'https://placehold.co/40x40',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                size: 24,
                                color: Color(0xFF94A3B8),
                              );
                            },
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
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x0D000000).withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                      spreadRadius: 0,
                      blurStyle: BlurStyle.inner,
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari ikan segar atau olahan...',
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF94A3B8),
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF94A3B8),
                      size: 18,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 17,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Toggle Tab
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x0D000000).withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                      spreadRadius: 0,
                      blurStyle: BlurStyle.inner,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTabButton(
                        'Ikan Segar',
                        Icons.water_drop,
                        0,
                      ),
                    ),
                    Expanded(
                      child: _buildTabButton(
                        'Produk Olahan',
                        Icons.restaurant_menu,
                        1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, IconData icon, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  const BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? const Color(0xFF0077B6) : const Color(0xFF64748B),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? const Color(0xFF0077B6) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeProductCard(Map<String, dynamic> product) {
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 30,
              offset: const Offset(0, 8),
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Image.asset(
                    product['image'] ?? 'assets/images/nilaMerah.png',
                    width: double.infinity,
                    height: 224,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 224,
                        color: const Color(0xFFF1F5F9),
                        child: const Icon(
                          Icons.image,
                          size: 64,
                          color: Color(0xFF94A3B8),
                        ),
                      );
                    },
                  ),
                ),
                // Badge
                if (product['badge'] != null)
                  Positioned(
                    left: 16,
                    top: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: product['badgeBg'] ?? const Color(0xE6FFFFFF),
                        borderRadius: BorderRadius.circular(9999),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D000000),
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        product['badge'] ?? '',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: product['badgeColor'] ?? const Color(0xFF0077B6),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                // Price Tag
                Positioned(
                  left: 16,
                  top: 151,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0x99000000),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HARGA PER KG',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Rp ${_formatPrice(product['price'])}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            product['description'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            product['stockLabel'],
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          Text(
                            product['stock'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: product['stockColor'],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Divider
                  Container(
                    height: 1,
                    color: const Color(0xFFF8FAFC),
                  ),
                  const SizedBox(height: 16),

                  // Add to Cart Button
                  GestureDetector(
                    onTap: () {
                      // TODO: Add to cart logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product['name']} ditambahkan ke keranjang'),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 44,
                      decoration: BoxDecoration(
                        color: product['buttonColor'],
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFBFDBFE).withOpacity(0.5),
                            blurRadius: 15,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            product['buttonText'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
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

  Widget _buildGridProductCard(Map<String, dynamic> product) {
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
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 2,
              offset: Offset(0, 1),
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Container(
                    width: double.infinity,
                    height: 169,
                    color: const Color(0xFFF1F5F9),
                    child: Image.asset(
                      product['image'] ?? 'assets/images/nilaMerah.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image,
                          size: 48,
                          color: Color(0xFF94A3B8),
                        );
                      },
                    ),
                  ),
                ),
                // IKANURA Badge
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xE6FFFFFF),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0x330077B6),
                      ),
                    ),
                    child: const Text(
                      'IKANURA',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0077B6),
                      ),
                    ),
                  ),
                ),
                // Discount Badge
                if (product['discount'] != null)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D000000),
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        product['discount'],
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: product['badgeBg'] ?? const Color(0xFFD8F3DC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: (product['badgeColor'] ?? const Color(0xFF40916C)).withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      product['badge'] ?? '',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: product['badgeColor'] ?? const Color(0xFF40916C),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Product Name
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                      height: 1.25,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Description
                  Text(
                    product['description'],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price & Add Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['unit'] != null ? 'Per ${product['unit']}' : 'Per Pack',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          Text(
                            'Rp ${_formatPrice(product['price'])}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0077B6),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF40916C),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF40916C).withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              // TODO: Add to cart logic
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${product['name']} ditambahkan ke keranjang'),
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
