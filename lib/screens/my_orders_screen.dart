import 'package:flutter/material.dart';
import 'order_tracking_screen.dart';

// Static storage for cart items (global/persistent)
class CartStorage {
  static final List<Map<String, dynamic>> _items = [];

  static void addItem(Map<String, dynamic> product) {
    final existingIndex = _items.indexWhere(
      (item) => item['name'] == product['name'],
    );
    if (existingIndex >= 0) {
      _items[existingIndex]['quantity'] =
          (_items[existingIndex]['quantity'] as int) + 1;
    } else {
      _items.add(Map<String, dynamic>.from(product));
    }
  }

  static void addItemWithQuantity(Map<String, dynamic> product, int quantity) {
    final existingIndex = _items.indexWhere(
      (item) => item['name'] == product['name'],
    );
    if (existingIndex >= 0) {
      _items[existingIndex]['quantity'] =
          (_items[existingIndex]['quantity'] as int) + quantity;
    } else {
      final newItem = Map<String, dynamic>.from(product);
      newItem['quantity'] = quantity;
      _items.add(newItem);
    }
  }

  static List<Map<String, dynamic>> getAllItems() {
    return List<Map<String, dynamic>>.from(_items);
  }

  static void updateItems(List<Map<String, dynamic>> items) {
    _items.clear();
    _items.addAll(items.map((item) => Map<String, dynamic>.from(item)));
  }

  static void updateQuantity(int index, int delta) {
    if (index >= 0 && index < _items.length) {
      final newQty = (_items[index]['quantity'] as int) + delta;
      if (newQty > 0) {
        _items[index]['quantity'] = newQty;
      } else {
        _items.removeAt(index);
      }
    }
  }

  static void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
    }
  }

  static void removeCheckedOutItems(
    List<Map<String, dynamic>> checkedOutItems,
  ) {
    for (var checkedOut in checkedOutItems) {
      final name = checkedOut['name'];
      final qty = (checkedOut['quantity'] as int?) ?? 0;
      final idx = _items.indexWhere((item) => item['name'] == name);
      if (idx >= 0) {
        final current = (_items[idx]['quantity'] as int?) ?? 0;
        final remaining = current - qty;
        if (remaining > 0) {
          _items[idx]['quantity'] = remaining;
        } else {
          _items.removeAt(idx);
        }
      }
    }
  }

  static void clear() {
    _items.clear();
  }

  static int getItemCount() {
    return _items.fold(
      0,
      (sum, item) => sum + ((item['quantity'] as int?) ?? 0),
    );
  }

  static int getItemQuantity(String productName) {
    final item = _items.firstWhere(
      (item) => item['name'] == productName,
      orElse: () => <String, dynamic>{},
    );
    return (item['quantity'] as int?) ?? 0;
  }

  static void setItemQuantity(String productName, int quantity) {
    final idx = _items.indexWhere((item) => item['name'] == productName);
    if (idx >= 0) {
      if (quantity <= 0) {
        _items.removeAt(idx);
      } else {
        _items[idx]['quantity'] = quantity;
      }
    }
  }
}

// Static storage for orders
class OrdersStorage {
  static final List<Map<String, dynamic>> _orders = [];

  static void addOrder(Map<String, dynamic> order) {
    if (order.isNotEmpty) {
      _orders.add(order);
    }
  }

  static List<Map<String, dynamic>> getAllOrders() {
    return List.from(_orders);
  }

  static int getOrderCount() {
    return _orders.length;
  }
}

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  String _getDisplayOrderNumber(Map<String, dynamic> order) {
    final rawOrderNumber = order['orderNumber']?.toString();
    if (rawOrderNumber != null && rawOrderNumber.startsWith('ORD-')) {
      return rawOrderNumber;
    }

    final fallback = order['orderId']?.toString() ?? '';
    if (fallback.startsWith('ORD-')) {
      return fallback;
    }

    if (fallback.isEmpty) {
      return 'ORD-UNKNOWN';
    }

    final compact = fallback.replaceAll('-', '').toUpperCase();
    final suffix = compact.length >= 6 ? compact.substring(0, 6) : compact;
    return 'ORD-$suffix';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Sedang Diproses':
        return const Color(0xFF0EA5E9);
      case 'Dalam Pengiriman':
        return const Color(0xFFF97316);
      case 'Selesai':
        return const Color(0xFF10B981);
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
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = OrdersStorage.getAllOrders();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Header
          _buildHeader(),

          // Orders list
          Expanded(
            child: orders.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildOrderCard(
                          orders[orders.length - 1 - index],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(9999),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: Color(0xFF334155),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Pesanan Saya',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 56,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Belum Ada Pesanan',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pesanan Anda akan muncul di sini',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final items = order['items'] as List<Map<String, dynamic>>;
    final displayOrderNumber = _getDisplayOrderNumber(order);
    final totalItems = items.fold<int>(
      0,
      (sum, item) => sum + (item['quantity'] as int),
    );

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderTrackingScreen(
              orderId: order['orderId'],
              orderNumber: displayOrderNumber,
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
          border: Border.all(color: const Color(0xFFF1F5F9)),
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
                      displayOrderNumber,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusBgColor(order['status']),
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(
                      color: _getStatusColor(
                        order['status'],
                      ).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    order['status'],
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      color: _getStatusColor(order['status']),
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
                  child: Stack(
                    children: List.generate(
                      items.length > 3 ? 3 : items.length,
                      (index) => Positioned(
                        left: index * 36.0,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 2),
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
                              items[index]['image'] ??
                                  'assets/images/nilaMerah.png',
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
                    ),
                  ),
                ),
                SizedBox(
                  width: items.length > 1
                      ? (items.length > 3 ? 108 : items.length * 36.0 + 12)
                      : 60,
                ),
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
                        'Rp ${_formatPrice(order['totalPrice'])}',
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
                border: Border.all(color: const Color(0xFF0284C7), width: 1.5),
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
