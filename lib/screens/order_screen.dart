import 'package:flutter/material.dart';
import 'my_orders_screen.dart';
import 'order_tracking_screen.dart';

class OrderScreen extends StatefulWidget {
  final String role;

  const OrderScreen({
    super.key,
    required this.role,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    // Rebuild when tab changes to refresh data
    _tabController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Pesanan',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: const Color(0xFF0077B6),
          unselectedLabelColor: const Color(0xFF94A3B8),
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          indicatorColor: const Color(0xFF0077B6),
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Proses'),
            Tab(text: 'Dikirim'),
            Tab(text: 'Selesai'),
            Tab(text: 'Dibatalkan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList('Semua'),
          _buildOrderList('Proses'),
          _buildOrderList('Dikirim'),
          _buildOrderList('Selesai'),
          _buildOrderList('Dibatalkan'),
        ],
      ),
    );
  }

  Widget _buildOrderList(String status) {
    final allOrders = OrdersStorage.getAllOrders();
    
    final filteredOrders = status == 'Semua' 
        ? allOrders 
        : allOrders.where((order) {
            final orderStatus = order['status'];
            if (orderStatus == null) return false;
            
            if (status == 'Proses') {
              return orderStatus == 'Sedang Diproses';
            } else if (status == 'Dikirim') {
              return orderStatus == 'Dalam Pengiriman';
            } else if (status == 'Selesai') {
              return orderStatus == 'Selesai';
            } else if (status == 'Dibatalkan') {
              return orderStatus == 'Dibatalkan';
            }
            return false;
          }).toList();

    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: const Color(0xFFCBD5E1),
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada pesanan $status',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.role == 'buyer' 
                  ? 'Yuk mulai belanja ikan segar!' 
                  : 'Belum ada pesanan masuk',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        try {
          final order = filteredOrders[filteredOrders.length - 1 - index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildOrderCard(order),
          );
        } catch (e) {
          return const SizedBox.shrink();
        }
      },
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Sedang Diproses':
        return const Color(0xFF0EA5E9);
      case 'Dalam Pengiriman':
        return const Color(0xFFF97316);
      case 'Selesai':
        return const Color(0xFF10B981);
      case 'Dibatalkan':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF64748B);
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'Sedang Diproses':
        return const Color(0xFFE0F2FE);
      case 'Dalam Pengiriman':
        return const Color(0xFFFFEDD5);
      case 'Selesai':
        return const Color(0xFFECFDF5);
      case 'Dibatalkan':
        return const Color(0xFFFEE2E2);
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    // Safe casting with null checks
    final itemsData = order['items'];
    
    if (itemsData == null || itemsData is! List) {
      return const SizedBox.shrink();
    }
    
    // Safely convert to List<Map<String, dynamic>>, filtering out null/invalid entries
    final items = <Map<String, dynamic>>[];
    try {
      for (var item in itemsData) {
        if (item != null && item is Map) {
          items.add(Map<String, dynamic>.from(item));
        }
      }
    } catch (e) {
      return const SizedBox.shrink();
    }
    
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    
    final totalItems = items.fold<int>(
      0, 
      (sum, item) {
        final quantity = item['quantity'];
        if (quantity is int) return sum + quantity;
        if (quantity is double) return sum + quantity.toInt();
        return sum;
      },
    );
    
    final orderId = order['orderId']?.toString() ?? 'Unknown';
    final status = order['status']?.toString() ?? 'Unknown';
    
    final totalPriceData = order['totalPrice'];
    final totalPrice = (totalPriceData is int) 
        ? totalPriceData 
        : (totalPriceData is double) 
            ? totalPriceData.toInt() 
            : 0;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderTrackingScreen(
              orderId: orderId,
              orderItems: items,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFF1F5F9),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ORDER ID',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF94A3B8),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      orderId,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusBgColor(status),
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(
                      color: _getStatusColor(status).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      color: _getStatusColor(status),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 16),

            // Items preview
            Row(
              children: [
                // Item images
                SizedBox(
                  height: 48,
                  width: items.length > 3 ? 156 : (items.length > 1 ? items.length * 48.0 + (items.length - 1) * 12 : 48),
                  child: Stack(
                    children: () {
                      // Filter valid items and build positioned widgets
                      final List<Widget> widgets = [];
                      final displayCount = items.length > 3 ? 3 : items.length;
                      
                      for (int i = 0; i < displayCount; i++) {
                        final item = items[i];
                        
                        final imagePath = item['image'];
                        if (imagePath == null || imagePath.toString().isEmpty) continue;
                        
                        widgets.add(
                          Positioned(
                            left: i * 36.0,
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x0D000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  imagePath.toString(),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: const Color(0xFFF1F5F9),
                                      child: const Icon(
                                        Icons.image,
                                        size: 20,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      
                      // If no valid images, show placeholder
                      if (widgets.isEmpty) {
                        widgets.add(
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFFF1F5F9),
                            ),
                            child: const Icon(
                              Icons.shopping_bag_outlined,
                              size: 24,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        );
                      }
                      
                      return widgets;
                    }(),
                  ),
                ),
                SizedBox(width: items.length > 1 ? (items.length > 3 ? 108 : items.length * 36.0 + 12) : 60),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$totalItems Item',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp ${_formatPrice(totalPrice)}',
                        style: const TextStyle(
                          fontSize: 16,
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

            const SizedBox(height: 16),

            // Action button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF0284C7),
                  width: 1.5,
                ),
              ),
              child: const Text(
                'Lacak Pesanan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0284C7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
