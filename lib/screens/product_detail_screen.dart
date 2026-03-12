import 'package:flutter/material.dart';
import 'checkout_screen.dart';
import 'cart_screen.dart';
import 'my_orders_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with SingleTickerProviderStateMixin {
  double _quantity = 1.0;
  late TextEditingController _quantityController;
  late FocusNode _quantityFocusNode;
  late ScrollController _scrollController;
  final GlobalKey _quantityKey = GlobalKey();
  late AnimationController _cartIconController; // animation for add-to-cart icon

  bool get _isFreshFish {
    final type = widget.product['type'];
    print('Product type raw: $type, Type: ${type.runtimeType}');
    return type == 'fresh';
  }
  
  double get _minQuantity {
    final min = _isFreshFish ? 1.0 : 0.1;
    print('Min quantity: $min (Fresh: $_isFreshFish)');
    return min;
  }
  
  // step calculation unused, quantity increments now handled inline
  // double get _stepQuantity {
  //   final step = _isFreshFish ? 1.0 : 0.1;
  //   print('Step quantity: $step (Fresh: $_isFreshFish)');
  //   return step;
  // }

  @override
  void initState() {
    super.initState();
    // Load quantity from cart if product already exists
    final cartQty = CartStorage.getItemQuantity(widget.product['name']);
    _quantity = cartQty > 0 ? cartQty.toDouble() : _minQuantity;
    _quantityController = TextEditingController(
      text: _quantity.toInt() == _quantity ? '${_quantity.toInt()}' : _quantity.toStringAsFixed(1),
    );
    _quantityFocusNode = FocusNode();
    _scrollController = ScrollController();
    _cartIconController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200), lowerBound: 0.8, upperBound: 1.2);
    
    // Add listener to scroll when keyboard appears
    _quantityFocusNode.addListener(() {
      if (_quantityFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_quantityKey.currentContext != null && mounted) {
            Scrollable.ensureVisible(
              _quantityKey.currentContext!,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: 0.3, // Position in visible area (30% from top)
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _quantityFocusNode.dispose();
    _scrollController.dispose();
    _cartIconController.dispose();
    super.dispose();
  }

  void _updateQuantity(double newQuantity) {
    setState(() {
      _quantity = newQuantity;
      _quantityController.text = _quantity.toInt() == _quantity ? '${_quantity.toInt()}' : _quantity.toStringAsFixed(1);
      // Sync to cart if product already exists in cart
      final existingQty = CartStorage.getItemQuantity(widget.product['name']);
      if (existingQty > 0) {
        CartStorage.setItemQuantity(widget.product['name'], _quantity.toInt());
      }
    });
  }

  void _incrementQuantity() {
    print('=== INCREMENT START ===');
    print('Product data: ${widget.product}');
    print('Type: ${widget.product['type']} (${widget.product['type'].runtimeType})');
    print('Is Fresh Fish: $_isFreshFish');
    
    final isFresh = widget.product['type'] == 'fresh';
    final step = isFresh ? 1.0 : 0.1;
    
    print('Calculated step: $step');
    
    double newQuantity = _quantity + step;
    // Prevent floating point precision issues
    newQuantity = double.parse(newQuantity.toStringAsFixed(1));
    print('New quantity: $newQuantity');
    print('=== INCREMENT END ===');
    _updateQuantity(newQuantity);
  }

  void _decrementQuantity() {
    print('=== DECREMENT START ===');
    print('Product data: ${widget.product}');
    print('Type: ${widget.product['type']} (${widget.product['type'].runtimeType})');
    print('Is Fresh Fish: $_isFreshFish');
    
    final isFresh = widget.product['type'] == 'fresh';
    final step = isFresh ? 1.0 : 0.1;
    final minQty = isFresh ? 1.0 : 0.1;
    
    print('Calculated step: $step');
    print('Min quantity: $minQty');
    
    if (_quantity > minQty) {
      double newQuantity = _quantity - step;
      // Prevent floating point precision issues
      newQuantity = double.parse(newQuantity.toStringAsFixed(1));
      print('New quantity: $newQuantity');
      if (newQuantity >= minQty) {
        _updateQuantity(newQuantity);
      } else {
        _updateQuantity(minQty);
      }
    }
    print('=== DECREMENT END ===');
  }

  void _onQuantityChanged(String value) {
    if (value.isEmpty) return;
    
    final double? parsedValue = double.tryParse(value);
    if (parsedValue != null) {
      // Validate against minimum quantity
      if (parsedValue < _minQuantity) {
        _updateQuantity(_minQuantity);
        return;
      }
      
      // Round to 1 decimal place
      final roundedValue = double.parse(parsedValue.toStringAsFixed(1));
      
      // For fresh fish, only allow whole numbers
      if (_isFreshFish) {
        _updateQuantity(roundedValue.roundToDouble());
      } else {
        _updateQuantity(roundedValue);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Main Content
          SingleChildScrollView(
            controller: _scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                // Hero Image Section
                _buildHeroImage(),

                // Content Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Title
                      _buildProductTitle(),
                      const SizedBox(height: 24),

                      // Price Section
                      _buildPriceSection(),
                      const SizedBox(height: 24),

                      // Product Quality
                      _buildProductQuality(),
                      const SizedBox(height: 32),

                      // Quantity Selector
                      _buildQuantitySelector(),
                      const SizedBox(height: 24),

                      // Shipping Info
                      _buildShippingInfo(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Top Bar (Back, Share, Cart)
          _buildTopBar(),

          // Bottom Bar
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return Stack(
      children: [
        // Image with gradient overlay
        Container(
          width: double.infinity,
          height: 440,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F4C75).withOpacity(0.1),
                blurRadius: 40,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                child: Image.asset(
                  widget.product['image'] ?? 'assets/images/nilaMerah.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
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
              // Gradient Overlay
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Color(0x4D000000),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Location Badge
        Positioned(
          left: 138,
          top: 330,
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 16, 10),
            decoration: BoxDecoration(
              color: const Color(0xF2FFFFFF),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0x99FFFFFF),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEBF8FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Color(0xFF0F4C75),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'LOKASI KOLAM',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Padukuhan Kramen',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Pagination Dots
        Positioned(
          left: 171,
          top: 410,
          child: Row(
            children: [
              Container(
                width: 24,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xB3FFFFFF),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0x80FFFFFF),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF334155),
                    size: 20,
                  ),
                ),
              ),

                  // (removed share and cart icons - they are redundant)
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product['name'] ?? 'Ikan Nila Merah\nSegar',
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
            height: 1.25,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Red Tilapia - Whole Fresh',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Color(0xFF94A3B8),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(color: const Color(0xFFF1F5F9)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.star,
                color: Color(0xFFFBBF24),
                size: 16,
              ),
              SizedBox(width: 6),
              Text(
                '520 kg terjual',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F4C75).withOpacity(0.1),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Retail Price and Mitra Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Harga Retail',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Rp 42.000 /kg',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF94A3B8),
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0x1A40916C),
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
                  children: const [
                    Icon(
                      Icons.verified,
                      color: Color(0xFF40916C),
                      size: 14,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Mitra Verified',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF40916C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Current Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rp ${_formatPrice(widget.product['price'] ?? 35500)}',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF40916C),
                  height: 1.11,
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  '/ kg',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
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

          // Savings Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.check_circle,
                  color: Color(0xFF40916C),
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF475569),
                      height: 1.625,
                    ),
                    children: [
                      TextSpan(text: 'Hemat '),
                      TextSpan(
                        text: '15%',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF40916C),
                        ),
                      ),
                      TextSpan(
                        text: ' dengan status Mitra. Minimal\npemesanan 10kg untuk harga grosir.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductQuality() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(
              Icons.insights,
              color: Color(0xFF0F4C75),
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Kualitas Produk',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF475569),
              height: 2,
            ),
            children: [
              TextSpan(
                text: 'Ikan Nila Merah yang dibudidayakan langsung\ndi kolam air deras ',
              ),
              TextSpan(
                text: 'Sidoagung',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              TextSpan(
                text: '. Dikenal dengan\ndaging yang tebal, tekstur padat, rasa manis\nalami, dan bebas bau tanah karena sistem\nsirkulasi air yang baik. Sangat cocok untuk\nmenu restoran seafood premium.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Jumlah Pesanan ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  TextSpan(
                    text: '(Kg)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(
                  color: const Color(0x3340916C),
                ),
              ),
              child: const Text(
                'Stok Tersedia: 500+ kg',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF40916C),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Quantity Control
        Container(
          key: _quantityKey,
          padding: const EdgeInsets.all(10),
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
          child: Row(
            children: [
              // Minus Button
              GestureDetector(
                onTap: _decrementQuantity,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: const Icon(
                    Icons.remove,
                    color: Color(0xFF94A3B8),
                    size: 20,
                  ),
                ),
              ),
              // Quantity Display
              Expanded(
                child: Column(
                  children: [
                    IntrinsicWidth(
                      child: TextField(
                        controller: _quantityController,
                        focusNode: _quantityFocusNode,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        onSubmitted: (value) {
                          _onQuantityChanged(value);
                          _quantityFocusNode.unfocus();
                        },
                        onTapOutside: (event) {
                          _onQuantityChanged(_quantityController.text);
                          _quantityFocusNode.unfocus();
                        },
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'KILOGRAMS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF94A3B8),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              // Plus Button
              GestureDetector(
                onTap: _incrementQuantity,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShippingInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xCCFFFBEB),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFEF3C7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.local_shipping,
              color: Color(0xFFD97706),
              size: 40,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pengiriman Segar H+1',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF78350F),
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xCCB45309),
                      height: 1.625,
                    ),
                    children: [
                      TextSpan(
                        text: 'Pesanan diatas 100kg akan diproses\nmenggunakan ',
                      ),
                      TextSpan(
                        text: 'Armada Khusus',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: ' untuk\nmenjaga suhu tetap 0-4°C.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        decoration: BoxDecoration(
          color: const Color(0xE6FFFFFF),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          border: const Border(
            top: BorderSide(color: Color(0xFFF1F5F9)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 30,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              // Favorite Button
              GestureDetector(
                onTap: () {
                  final existingQty = CartStorage.getItemQuantity(widget.product['name']);
                  if (existingQty > 0) {
                    // already in cart, go to cart screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScreen(),
                      ),
                    );
                    return;
                  }
                  // Otherwise add new item
                  final int qtyInt = _quantity.toInt() == _quantity ? _quantity.toInt() : 0;
                  final double qtyDouble = _quantity.toInt() == _quantity ? _quantity.toDouble() : _quantity;
                  final dynamic finalQty = qtyInt > 0 ? qtyInt : qtyDouble;
                  final item = <String, dynamic>{
                    'name': widget.product['name'],
                    'price': widget.product['price'],
                    'image': widget.product['image'],
                    'variant': widget.product['description'],
                    'quantity': finalQty,
                    'type': widget.product['type'],
                  };
                  CartStorage.addItemWithQuantity(item, (finalQty is int ? finalQty : (finalQty as double).toInt()));
                  _cartIconController.forward().then((_) => _cartIconController.reverse());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ditambahkan ke keranjang'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  setState(() {}); // refresh badge
                },

                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D000000),
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ScaleTransition(
                        scale: _cartIconController,
                        child: const Icon(
                          Icons.shopping_cart,
                          color: Color(0xFF475569),
                          size: 24,
                        ),
                      ),
                    ),
                    // badge with quantity for this product
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Builder(builder: (ctx) {
                        final qty = CartStorage.getItemQuantity(widget.product['name']);
                        if (qty <= 0) return const SizedBox.shrink();
                        return Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                          child: Text(
                            '$qty',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Order Button
              Expanded(
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F4C75), Color(0xFF3282B8)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F4C75).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                                // same logic repurposed
                        final int qtyInt = _quantity.toInt() == _quantity ? _quantity.toInt() : 0;
                        final double qtyDouble = _quantity.toInt() == _quantity ? _quantity.toDouble() : _quantity;
                        final dynamic finalQty = qtyInt > 0 ? qtyInt : qtyDouble;
                        final item = <String, dynamic>{
                          'name': widget.product['name'],
                          'price': widget.product['price'],
                          'image': widget.product['image'],
                          'variant': widget.product['description'],
                          'quantity': finalQty,
                          'type': widget.product['type'],
                        };
                        // add to global cart and animate icon
                        CartStorage.addItemWithQuantity(item, (finalQty is int ? finalQty : (finalQty as double).toInt()));
                        _cartIconController.forward().then((_) => _cartIconController.reverse());
                        // navigate to checkout with just this item
                        final totalPrice = (widget.product['price'] as num).toInt() *
                            (finalQty is int ? finalQty : (finalQty as double).toInt());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutScreen(
                              cartItems: [item],
                              totalPrice: totalPrice,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Pesan Sekarang',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
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

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
