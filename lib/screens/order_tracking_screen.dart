import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'order_detail_screen.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  final List<Map<String, dynamic>> orderItems;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
    required this.orderItems,
  });

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order ID berhasil disalin'),
        backgroundColor: Color(0xFF0284C7),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              const SizedBox(height: 80),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 128),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Estimated arrival banner
                      _buildEstimatedArrivalBanner(),

                      const SizedBox(height: 24),

                      // Order ID
                      _buildOrderIdSection(context),

                      const SizedBox(height: 24),

                      // Progress timeline
                      _buildProgressTimeline(),

                      const SizedBox(height: 40),

                      // Detail items
                      _buildDetailItems(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Header
          _buildHeader(context),

          // Bottom button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          border: const Border(
            bottom: BorderSide(
              color: Color(0xFFF1F5F9),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(9999),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: Color(0xFF334155),
                  ),
                ),
              ),
              const Text(
                'Lacak Pesanan',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              InkWell(
                onTap: () {
                  // TODO: Open help
                },
                borderRadius: BorderRadius.circular(9999),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    'Bantuan',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEstimatedArrivalBanner() {
    return Container(
      height: 224,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        image: DecorationImage(
          image: NetworkImage('https://placehold.co/390x224/F0F9FF/E0F2FE?text=Map'),
          fit: BoxFit.cover,
          opacity: 0.6,
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.6),
            BlendMode.multiply,
          ),
        ),
      ),
      child: Stack(
        children: [
          // Gradient overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 224,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0),
                    Colors.white.withOpacity(0),
                    Colors.white,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Wave pattern
          Positioned(
            left: 0,
            bottom: 48,
            child: Opacity(
              opacity: 0.6,
              child: Container(
                width: 100,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0x260EA5E9),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // Estimated arrival card
          Positioned(
            left: 16,
            right: 16,
            bottom: 110,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D1E3A8A),
                    blurRadius: 10,
                    offset: Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Color(0x0D1E3A8A),
                    blurRadius: 25,
                    offset: Offset(0, 20),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.local_shipping_outlined,
                            size: 12,
                            color: Color(0xFF0284C7),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'ESTIMASI TIBA',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0284C7),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Besok, 14:00 WIB',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFE0F2FE), Color(0xFFF0F9FF)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                          spreadRadius: 0,
                          blurStyle: BlurStyle.inner,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.access_time,
                      size: 28,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderIdSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ORDER ID',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF94A3B8),
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                orderId,
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () => _copyToClipboard(context, orderId),
            borderRadius: BorderRadius.circular(9999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.copy,
                    size: 12,
                    color: Color(0xFF0369A1),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Salin',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0369A1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTimeline() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(
                Icons.timeline,
                size: 22,
                color: Color(0xFF0284C7),
              ),
              SizedBox(width: 8),
              Text(
                'Transparansi Proses (Daya)',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Timeline
          Stack(
            children: [
              // Vertical line
              Positioned(
                left: 28,
                top: 40,
                bottom: 0,
                child: Container(
                  width: 2,
                  color: const Color(0xFFE2E8F0),
                ),
              ),

              Column(
                children: [
                  // Step 1: Diterima (not completed)
                  _buildTimelineStep(
                    icon: Icons.home_outlined,
                    title: 'Diterima',
                    description: 'Pesanan sampai di lokasi tujuan',
                    isCompleted: false,
                    isActive: false,
                  ),
                  const SizedBox(height: 32),

                  // Step 2: Sedang Dikirim (not completed)
                  _buildTimelineStep(
                    icon: Icons.local_shipping_outlined,
                    title: 'Sedang Dikirim',
                    description: 'Kurir membawa pesanan Anda',
                    isCompleted: false,
                    isActive: false,
                  ),
                  const SizedBox(height: 32),

                  // Step 3: Proses Panen (current - in progress)
                  _buildTimelineStepInProgress(),
                  const SizedBox(height: 32),

                  // Step 4: Pembayaran Diverifikasi (completed)
                  _buildTimelineStep(
                    icon: Icons.check_circle_outline,
                    title: 'Pembayaran Diverifikasi',
                    description: 'Dikonfirmasi oleh Admin',
                    time: '09:15 WIB',
                    isCompleted: true,
                    isActive: false,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required IconData icon,
    required String title,
    required String description,
    String? time,
    required bool isCompleted,
    required bool isActive,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isCompleted ? const Color(0xFF10B981) : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted ? Colors.white : const Color(0xFFF1F5F9),
              width: 4,
            ),
            boxShadow: isCompleted
                ? const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Icon(
            icon,
            size: isCompleted ? 20 : 16,
            color: isCompleted ? Colors.white : const Color(0xFFCBD5E1),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Opacity(
            opacity: isCompleted ? 1.0 : 0.5,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      color: isCompleted ? const Color(0xFF1E293B) : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      color: isCompleted ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                    ),
                  ),
                  if (time != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 10,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineStepInProgress() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon with glow
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 56,
              height: 265,
              decoration: BoxDecoration(
                color: const Color(0xC00EA5E9),
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF0EA5E9),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x4D0EA5E9),
                    blurRadius: 10,
                    offset: Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Color(0x4D0EA5E9),
                    blurRadius: 25,
                    offset: Offset(0, 20),
                  ),
                ],
              ),
              child: const Icon(
                Icons.water_drop_outlined,
                size: 19,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),

        // Content card
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFE0F2FE),
                ),
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
                  // Decorative circle
                  Positioned(
                    right: -15,
                    top: -15,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0x80D1FAE5),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(9999),
                        ),
                      ),
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Text(
                              'Proses Panen di\nKolam',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0369A1),
                                height: 1.43,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFFD1FAE5),
                              ),
                            ),
                            child: const Text(
                              'Sedang\nBerlangsung',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF10B981),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Description
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF475569),
                            height: 1.625,
                          ),
                          children: [
                            TextSpan(text: 'Ikan Anda sedang dipanen oleh '),
                            TextSpan(
                              text: 'Bapak\nHartono',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            TextSpan(text: ' (Ketua Kelompok).'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Photo
                      Container(
                        height: 132,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: NetworkImage('https://placehold.co/236x128/0EA5E9/FFFFFF?text=Panen'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0),
                                Colors.black.withOpacity(0.4),
                              ],
                            ),
                          ),
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            children: const [
                              Icon(
                                Icons.camera_alt,
                                size: 10,
                                color: Colors.white,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Update Terkini: 10:30 WIB',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItems() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xFFF1F5F9),
            ),
          ),
        ),
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detail Item',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 16),
            ...orderItems.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildOrderItem(item),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                item['image'] ?? 'assets/images/nilaMerah.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFF1F5F9),
                    child: const Icon(
                      Icons.image,
                      size: 32,
                      color: Color(0xFF94A3B8),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'TAMBAK SEGARA',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0369A1),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['name'] ?? 'Produk',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    height: 1.43,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item['quantity']}kg • Box Styrofoam',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${_formatPrice(item['price'] * item['quantity'])}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0284C7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFF1F5F9),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetailScreen(
                  orderId: orderId,
                  orderItems: orderItems,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Detail Pesanan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                color: Color(0xFF475569),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
