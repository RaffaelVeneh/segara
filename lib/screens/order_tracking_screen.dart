import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import 'main_screen.dart';
import 'order_detail_screen.dart';

class OrderTrackingScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final trackingAsync = ref.watch(orderTrackingProvider(orderId));
    final topSpacer = MediaQuery.of(context).padding.top + 72;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: topSpacer),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 128),
                  child: trackingAsync.when(
                    data: (tracking) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildEstimatedArrivalBanner(),
                        const SizedBox(height: 24),
                        _buildOrderIdSection(context),
                        const SizedBox(height: 24),
                        _buildProgressTimeline(tracking.status),
                        const SizedBox(height: 40),
                        _buildDetailItems(),
                      ],
                    ),
                    loading: () => const Padding(
                      padding: EdgeInsets.only(top: 48),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF2D6A4F),
                        ),
                      ),
                    ),
                    error: (error, _) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gagal memuat tracking pesanan',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            error.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Montserrat',
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          _buildHeader(context),
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
          color: Colors.white.withValues(alpha: 0.8),
          border: const Border(
            bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(role: 'buyer'),
                    ),
                    (route) => false,
                  );
                },
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
                onTap: () {},
                borderRadius: BorderRadius.circular(9999),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
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
          image: const NetworkImage(
            'https://placehold.co/390x224/F0F9FF/E0F2FE?text=Map',
          ),
          fit: BoxFit.cover,
          opacity: 0.6,
          colorFilter: ColorFilter.mode(
            Colors.white.withValues(alpha: 0.6),
            BlendMode.multiply,
          ),
        ),
      ),
      child: Stack(
        children: [
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
                    Colors.white.withValues(alpha: 0),
                    Colors.white.withValues(alpha: 0),
                    Colors.white,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 110,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D1E3A8A),
                    blurRadius: 10,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'ESTIMASI TIBA',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Menyesuaikan status pengiriman',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.access_time,
                    size: 28,
                    color: Color(0xFF0284C7),
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
              child: const Text(
                'Salin',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0369A1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTimeline(String currentStatus) {
    const statuses = [
      'PENDING',
      'WAITING_PAYMENT',
      'ALLOCATING',
      'HARVESTING',
      'SHIPPING',
      'COMPLETED',
    ];

    const labels = {
      'PENDING': 'Order Dibuat',
      'WAITING_PAYMENT': 'Menunggu Pembayaran',
      'ALLOCATING': 'Alokasi Kolam',
      'HARVESTING': 'Proses Panen',
      'SHIPPING': 'Dalam Pengiriman',
      'COMPLETED': 'Selesai',
    };

    final activeIndex = statuses.indexOf(currentStatus.toUpperCase());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transparansi Proses',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: List.generate(statuses.length, (index) {
              final status = statuses[index];
              final reached = activeIndex >= index && activeIndex >= 0;
              final isCurrent = activeIndex == index;

              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == statuses.length - 1 ? 0 : 16,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: reached ? const Color(0xFF2D6A4F) : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: reached
                              ? const Color(0xFF2D6A4F)
                              : const Color(0xFFCBD5E1),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        reached ? Icons.check : Icons.circle,
                        size: reached ? 16 : 8,
                        color: reached ? Colors.white : const Color(0xFFCBD5E1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          labels[status] ?? status,
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Montserrat',
                            fontWeight: isCurrent
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: reached
                                ? const Color(0xFF1E293B)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItems() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detail Pesanan',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            ...orderItems.map((item) {
              final itemTotal =
                  ((item['price'] ?? 0) as num).toInt() *
                  ((item['quantity'] ?? 0) as num).toInt();
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item['name'] ?? 'Produk'} x${item['quantity'] ?? 0}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Montserrat',
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                    Text(
                      'Rp ${_formatPrice(itemTotal)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: const Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0077B8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Lihat Detail Pesanan',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
