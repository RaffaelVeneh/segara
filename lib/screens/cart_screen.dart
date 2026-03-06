import 'package:flutter/material.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartScreen({
    super.key,
    required this.cartItems,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Map<String, dynamic>> _items;
  late List<bool> _selectedItems;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.cartItems);
    // Initialize all items as selected
    _selectedItems = List.filled(_items.length, true);
  }

  bool get _allSelected => _selectedItems.every((selected) => selected);
  
  int get _selectedCount {
    return _selectedItems.where((selected) => selected).length;
  }

  void _toggleSelectAll() {
    setState(() {
      final newValue = !_allSelected;
      _selectedItems = List.filled(_items.length, newValue);
    });
  }

  void _toggleItemSelection(int index) {
    setState(() {
      _selectedItems[index] = !_selectedItems[index];
    });
  }

  int get _totalItems {
    int total = 0;
    for (int i = 0; i < _items.length; i++) {
      if (_selectedItems[i]) {
        total += _items[i]['quantity'] as int;
      }
    }
    return total;
  }

  int get _totalPrice {
    int total = 0;
    for (int i = 0; i < _items.length; i++) {
      if (_selectedItems[i]) {
        total += (_items[i]['price'] as int) * (_items[i]['quantity'] as int);
      }
    }
    return total;
  }

  List<Map<String, dynamic>> get _selectedCartItems {
    List<Map<String, dynamic>> selected = [];
    for (int i = 0; i < _items.length; i++) {
      if (_selectedItems[i]) {
        selected.add(_items[i]);
      }
    }
    return selected;
  }

  double get _totalWeight {
    // Assuming 1kg per item for simplicity
    return _totalItems * 0.5; // 0.5kg per item
  }

  void _updateQuantity(int index, int delta) {
    setState(() {
      final newQuantity = _items[index]['quantity'] + delta;
      if (newQuantity > 0) {
        _items[index]['quantity'] = newQuantity;
      } else {
        // Remove item if quantity becomes 0
        _items.removeAt(index);
        _selectedItems.removeAt(index);
      }
    });
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
              // Header
              _buildHeader(),

              // Cart items
              Expanded(
                child: _items.isEmpty
                    ? _buildEmptyCart()
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 224),
                        child: Column(
                          children: [
                            // Select All checkbox
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFF1F5F9),
                                ),
                              ),
                              child: InkWell(
                                onTap: _toggleSelectAll,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: _allSelected
                                            ? const Color(0xFF0F83BD)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: _allSelected
                                              ? const Color(0xFF0F83BD)
                                              : const Color(0xFFCBD5E1),
                                          width: 2,
                                        ),
                                      ),
                                      child: _allSelected
                                          ? const Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      _allSelected ? 'Batalkan Pilih Semua' : 'Pilih Semua',
                                      style: const TextStyle(
                                        color: Color(0xFF1E293B),
                                        fontSize: 14,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '$_selectedCount/${_items.length} dipilih',
                                      style: const TextStyle(
                                        color: Color(0xFF64748B),
                                        fontSize: 12,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Shipping info
                            _buildShippingInfo(),
                            const SizedBox(height: 24),

                            // Cart items
                            ..._items.asMap().entries.map((entry) {
                              final index = entry.key;
                              final item = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: _buildCartItem(item, index),
                              );
                            }),

                            // Total weight info
                            _buildWeightInfo(),
                          ],
                        ),
                      ),
              ),
            ],
          ),

          // Bottom checkout bar
          if (_items.isNotEmpty) _buildCheckoutBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 128,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC).withOpacity(0.8),
      ),
      child: Stack(
        children: [
          // Background decoration
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 103,
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE).withOpacity(0.5),
              ),
            ),
          ),

          // Header content
          Positioned(
            left: 24,
            right: 24,
            top: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                InkWell(
                  onTap: () => Navigator.pop(context, _items),
                  borderRadius: BorderRadius.circular(9999),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      size: 11,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),

                // Title
                const Text(
                  'KERANJANG',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 18,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.45,
                  ),
                ),

                // Notification icon with badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(9999),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ),
                    if (_items.isNotEmpty)
                      Positioned(
                        right: 8,
                        top: 8,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0, -1),
          end: Alignment(0, 1),
          colors: [
            Color(0xFFECFDF5),
            Colors.white,
            Color(0x80ECFDF5),
          ],
          stops: [0, 0.5, 1],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0x99D1FAE5),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 40,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xCCD1FAE5),
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              size: 22,
              color: Color(0xFF059669),
            ),
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: const Text(
                        'Segara Express',
                        style: TextStyle(
                          color: Color(0xFF064E3B),
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          height: 1.43,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x80A7F3D0),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: const Text(
                        'FREE',
                        style: TextStyle(
                          color: Color(0xFF065F46),
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Pengiriman prioritas dengan suhu terjaga\nuntuk kesegaran maksimal.',
                  style: TextStyle(
                    color: Color(0xCC047857),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.625,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Container(
      height: 147,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _selectedItems[index] 
              ? const Color(0xFF0F83BD)
              : const Color(0x80F1F5F9),
          width: _selectedItems[index] ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _selectedItems[index]
                ? const Color(0xFF0F83BD).withOpacity(0.15)
                : const Color(0x0D000000),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Checkbox
          Positioned(
            left: 17,
            top: 17,
            child: InkWell(
              onTap: () => _toggleItemSelection(index),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _selectedItems[index]
                      ? const Color(0xFF0F83BD)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _selectedItems[index]
                        ? const Color(0xFF0F83BD)
                        : const Color(0xFFCBD5E1),
                    width: 2,
                  ),
                ),
                child: _selectedItems[index]
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ),
          
          // Product image
          Positioned(
            left: 53,
            top: 17,
            child: Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Container(
                      color: const Color(0xFFF1F5F9),
                      child: Image.asset(
                        item['image'] ?? 'assets/images/nilaMerah.png',
                        width: 112,
                        height: 112,
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
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0),
                            Colors.black.withOpacity(0.2),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Product info
          Positioned(
            left: 181,
            top: 17,
            right: 16,
            child: SizedBox(
              height: 113,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Name and variant
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'] ?? 'Produk',
                        style: const TextStyle(
                          color: Color(0xFF1E293B),
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5.5),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0x990F83BD),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item['variant'] ?? 'Utuh (Bersih)',
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.33,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Price and quantity controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Price
                      Flexible(
                        child: Text(
                          'Rp\n${_formatPrice(item['price'])}',
                          style: const TextStyle(
                            color: Color(0xFF0F83BD),
                            fontSize: 17,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Quantity controls
                      Container(
                        height: 36,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(
                            color: const Color(0xFFF1F5F9),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Minus button
                            InkWell(
                              onTap: () => _updateQuantity(index, -1),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: 32,
                                height: 28,
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.remove,
                                  size: 14,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ),

                            // Quantity
                            SizedBox(
                              width: 24,
                              child: Text(
                                '${item['quantity']}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF334155),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  height: 1.43,
                                ),
                              ),
                            ),

                            // Plus button
                            InkWell(
                              onTap: () => _updateQuantity(index, 1),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: 32,
                                height: 28,
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.add,
                                  size: 14,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x80EFF6FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFDBEAFE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.scale_outlined,
                  size: 16,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Total Berat',
                    style: TextStyle(
                      color: Color(0xFF334155),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.43,
                    ),
                  ),
                  Text(
                    'Estimasi biaya kirim berdasarkan berat',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 10,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            '${_totalWeight.toStringAsFixed(1)} kg',
            style: const TextStyle(
              color: Color(0xFF2563EB),
              fontSize: 18,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 1.56,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(32),
          ),
          border: const Border(
            top: BorderSide(
              color: Color(0x80F1F5F9),
            ),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 40,
              offset: Offset(0, -10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total payment
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL PEMBAYARAN',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                      height: 1.33,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const Text(
                        'Rp',
                        style: TextStyle(
                          color: Color(0xFF1E293B),
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          height: 1.56,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          _formatPrice(_totalPrice),
                          style: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 30,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Checkout button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: _selectedCount > 0
                    ? const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF0F83BD), Color(0xFF054F7A)],
                      )
                    : const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF94A3B8), Color(0xFF64748B)],
                      ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 15,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _selectedCount > 0 ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutScreen(
                          cartItems: _selectedCartItems,
                          totalPrice: _totalPrice,
                        ),
                      ),
                    );
                  } : null,
                  borderRadius: BorderRadius.circular(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: Text(
                            _selectedCount > 0
                                ? 'Checkout ($_selectedCount dipilih)'
                                : 'Pilih item untuk checkout',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Row(
                          children: [
                            const Text(
                              'Lanjut Bayar',
                              style: TextStyle(
                                color: Color(0xE6FFFFFF),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.43,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                size: 10,
                                color: Colors.white,
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
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Color(0xFF94A3B8),
          ),
          SizedBox(height: 16),
          Text(
            'Keranjang Kosong',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 18,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tambahkan produk ke keranjang',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
