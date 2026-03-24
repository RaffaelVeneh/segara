import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';

import '../providers/app_providers.dart';
import 'my_orders_screen.dart';

class PaymentConfirmationScreen extends ConsumerStatefulWidget {
  final String orderId;
  final String orderNumber;
  final int totalAmount;
  final DateTime expiredAt;
  final List<Map<String, dynamic>> cartItems;

  const PaymentConfirmationScreen({
    super.key,
    required this.orderId,
    required this.orderNumber,
    required this.totalAmount,
    required this.expiredAt,
    required this.cartItems,
  });

  @override
  ConsumerState<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState
    extends ConsumerState<PaymentConfirmationScreen> {
  bool _isOrderDetailsExpanded = false;
  Timer? _countdownTimer;
  int _remainingSeconds = 0;
  final ImagePicker _imagePicker = ImagePicker();
  File? _paymentProofFile;
  static const int _shippingFee = 15000;
  static const int _serviceFee = 2000;

  int get _subtotal {
    return widget.cartItems.fold<int>(0, (sum, item) {
      final price = (item['price'] as num?)?.toInt() ?? 0;
      final quantity = (item['quantity'] as num?)?.toInt() ?? 0;
      return sum + (price * quantity);
    });
  }

  int get _dummyTotal => _subtotal + _shippingFee + _serviceFee;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.expiredAt.difference(DateTime.now()).inSeconds;
    if (_remainingSeconds < 0) {
      _remainingSeconds = 0;
    }
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String _formatCountdown() {
    int hours = _remainingSeconds ~/ 3600;
    int minutes = (_remainingSeconds % 3600) ~/ 60;
    int seconds = _remainingSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _pickProofImage() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _paymentProofFile = File(pickedFile.path);
    });
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label berhasil disalin'),
        backgroundColor: const Color(0xFF0077B8),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flowState = ref.watch(orderFlowProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              _buildHeader(),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 24,
                    bottom: 180,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Warning banner
                      _buildWarningBanner(),
                      const SizedBox(height: 24),

                      // Total amount
                      _buildTotalAmountCard(),
                      const SizedBox(height: 24),

                      // Bank account
                      _buildBankAccountCard(),
                      const SizedBox(height: 24),

                      // Order details
                      _buildOrderDetailsCard(),
                      const SizedBox(height: 24),

                      // Payment proof upload
                      _buildPaymentProofSection(flowState),
                      const SizedBox(height: 16),

                      // Security text
                      _buildSecurityText(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomBar(flowState),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFF0077B8).withValues(alpha: 0.05),
              width: 25,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(9999),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            const Text(
              'Instruksi Pembayaran',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(width: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFEDD5)),
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
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFFFEDD5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.timer_outlined,
              size: 21,
              color: Color(0xFFEA580C),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selesaikan Pembayaran',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF64748B),
                    ),
                    children: [
                      const TextSpan(text: 'Stok dikunci selama '),
                      TextSpan(
                        text: _formatCountdown(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFEA580C),
                        ),
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

  Widget _buildTotalAmountCard() {
    final priceString = _formatPrice(widget.totalAmount);
    final splitIndex = priceString.length > 3 ? priceString.length - 3 : 0;
    final beforeLastThree = priceString.substring(0, splitIndex);
    final lastThreeDigits = priceString.substring(splitIndex);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [
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
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Total Tagihan',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 30,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
              children: [
                TextSpan(
                  text: splitIndex == 0 ? 'Rp ' : 'Rp $beforeLastThree',
                  style: const TextStyle(color: Color(0xFF0F172A)),
                ),
                TextSpan(
                  text: lastThreeDigits,
                  style: const TextStyle(color: Color(0xFFF97316)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF475569),
                  height: 1.625,
                ),
                children: [
                  TextSpan(text: 'Mohon transfer tepat sampai '),
                  TextSpan(
                    text: '3 digit terakhir',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFEA580C),
                    ),
                  ),
                  TextSpan(text: '\nuntuk verifikasi otomatis.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankAccountCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [
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
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Rekening Tujuan',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF334155),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2F1),
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(color: const Color(0xFFCCFBF1)),
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.shield_outlined,
                        size: 12,
                        color: Color(0xFF00695C),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'ESCROW SECURED',
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF00695C),
                          letterSpacing: 0.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bank logo and name
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D000000),
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Image.network(
                        'https://placehold.co/38x38/0077B8/FFFFFF?text=BRI',
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFF0077B8),
                            child: const Center(
                              child: Text(
                                'BRI',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Bank BRI',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Dicek otomatis dalam 5 menit',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Account number
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'NOMOR REKENING',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF94A3B8),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              '123-456-7890',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Liberation Mono',
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                                letterSpacing: 0.45,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => _copyToClipboard(
                              '1234567890',
                              'Nomor rekening',
                            ),
                            borderRadius: BorderRadius.circular(9999),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.copy,
                                size: 17,
                                color: Color(0xFF0077B8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Recipient name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'NAMA PENERIMA',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF94A3B8),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Sentra Ikan Sidoagung',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
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

  Widget _buildOrderDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _isOrderDetailsExpanded = !_isOrderDetailsExpanded;
          });
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEFF6FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.receipt_long_outlined,
                          size: 15,
                          color: Color(0xFF0077B8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Rincian Pesanan',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    _isOrderDetailsExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
              if (_isOrderDetailsExpanded) ...[
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 12),
                Text(
                  'Order: ${widget.orderNumber}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 10),
                ...widget.cartItems.map((item) {
                  final quantity = (item['quantity'] as num?)?.toInt() ?? 0;
                  final price = (item['price'] as num?)?.toInt() ?? 0;
                  final itemTotal = quantity * price;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item['name'] ?? 'Produk'} x$quantity',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
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
                const SizedBox(height: 8),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 10),
                _buildSummaryRow('Subtotal', _subtotal),
                const SizedBox(height: 6),
                _buildSummaryRow('Ongkir', _shippingFee),
                const SizedBox(height: 6),
                _buildSummaryRow('Biaya Layanan', _serviceFee),
                const SizedBox(height: 8),
                _buildSummaryRow('Total', _dummyTotal, isTotal: true),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, int amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Montserrat',
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: const Color(0xFF475569),
          ),
        ),
        Text(
          'Rp ${_formatPrice(amount)}',
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Montserrat',
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color: isTotal ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentProofSection(OrderFlowState flowState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bukti Pembayaran',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFCBD5E1), width: 2),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: flowState.isUploadingProof ? null : _pickProofImage,
              borderRadius: BorderRadius.circular(20),
              child: Center(
                child: _paymentProofFile == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0x1A0077B8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.upload_outlined,
                              size: 14,
                              color: Color(0xFF0077B8),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Upload Foto Struk',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Format: JPG, PNG (Max 5MB)',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(_paymentProofFile!, fit: BoxFit.cover),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                color: Colors.black45,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: const Text(
                                  'Tap untuk ganti gambar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityText() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.shield_outlined, size: 12, color: Color(0xFF64748B)),
            SizedBox(width: 8),
            Text(
              'SECURE TRANSACTION BY SEGARA',
              style: TextStyle(
                fontSize: 10,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
                letterSpacing: 0.25,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(OrderFlowState flowState) {
    final priceString = _formatPrice(widget.totalAmount);
    final splitIndex = priceString.length > 3 ? priceString.length - 3 : 0;
    final lastThreeDigits = priceString.substring(splitIndex);
    final beforeLastThree = priceString.substring(0, splitIndex);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: const Border(top: BorderSide(color: Color(0xFFF1F5F9))),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 40,
            offset: Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Pembayaran',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text: splitIndex == 0 ? 'Rp ' : 'Rp $beforeLastThree',
                          style: const TextStyle(color: Color(0xFF0F172A)),
                        ),
                        TextSpan(
                          text: lastThreeDigits,
                          style: const TextStyle(color: Color(0xFFF97316)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Confirm button
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF0077B8),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x400077B8),
                    blurRadius: 10,
                    offset: Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Color(0x400077B8),
                    blurRadius: 25,
                    offset: Offset(0, 20),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: flowState.isUploadingProof
                      ? null
                      : () async {
                          if (_paymentProofFile == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Silakan pilih foto bukti transfer terlebih dahulu.',
                                ),
                                backgroundColor: Color(0xFFB91C1C),
                              ),
                            );
                            return;
                          }

                          final uploadResult = await ref
                              .read(orderFlowProvider.notifier)
                              .uploadProof(
                                orderId: widget.orderId,
                                imageFile: _paymentProofFile!,
                              );

                          if (!mounted) {
                            return;
                          }

                          if (uploadResult == null) {
                            final errorMessage =
                                ref.read(orderFlowProvider).errorMessage ??
                                'Gagal mengunggah bukti pembayaran.';
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorMessage),
                                backgroundColor: const Color(0xFFB91C1C),
                              ),
                            );
                            return;
                          }

                          OrdersStorage.addOrder({
                            'orderId': widget.orderNumber,
                            'items': List<Map<String, dynamic>>.from(
                              widget.cartItems.map(
                                (item) => Map<String, dynamic>.from(item),
                              ),
                            ),
                            'totalPrice': widget.totalAmount,
                            'status': 'Menunggu Verifikasi',
                            'createdAt': DateTime.now(),
                          });

                          CartStorage.clear();

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyOrdersScreen(),
                            ),
                            (route) => false,
                          );
                        },
                  borderRadius: BorderRadius.circular(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        flowState.isUploadingProof
                            ? 'Mengunggah Bukti...'
                            : 'Konfirmasi Pembayaran',
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      flowState.isUploadingProof
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: Colors.white,
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
}
