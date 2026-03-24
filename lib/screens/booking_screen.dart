import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const BookingScreen({super.key, required this.product});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedDay = 12;
  bool _reminderEnabled = true;
  int _quantity = 1;

  int get _pricePerKg => widget.product['price'] ?? 65000;
  int get _totalPrice => _pricePerKg * _quantity;

  void _updateQuantity(int delta) {
    setState(() {
      final newQuantity = _quantity + delta;
      if (newQuantity >= 1 && newQuantity <= 999) {
        _quantity = newQuantity;
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
          SingleChildScrollView(
            child: Column(
              children: [
                // Header
                _buildHeader(),

                // Content
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 200),
                  child: Column(
                    children: [
                      // Hero Image Card
                      _buildHeroCard(),
                      const SizedBox(height: 24),

                      // Calendar Card
                      _buildCalendarCard(),
                      const SizedBox(height: 24),

                      // Detail Slot Panen
                      _buildDetailSlotCard(),
                      const SizedBox(height: 24),

                      // Reminder Toggle
                      _buildReminderCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom bar
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 64),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.8, 0),
          radius: 1.4,
          colors: [
            const Color(0xFFD0EDFB),
            const Color(0xFFD0EDFB).withValues(alpha: 0),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Radial gradient overlay (left side)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, 0.5),
                  radius: 0.7,
                  colors: [
                    const Color(0xFFE2F8EB),
                    const Color(0xFFE2F8EB).withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 30,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(22),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
              ),

              // Title
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Jadwal Panen Organik',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 18,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.45,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Info button
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 30,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.info_outline,
                  size: 17,
                  color: Color(0xFF0077B8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14004B78),
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Container(
                  width: double.infinity,
                  height: 256,
                  color: const Color(0xFFF1F5F9),
                  child: Image.asset(
                    widget.product['image'] ?? 'assets/images/nilaMerah.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image,
                        size: 64,
                        color: Color(0xFF94A3B8),
                      );
                    },
                  ),
                ),
              ),
              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0x000F4C75),
                        const Color(0x4D0F4C75),
                        const Color(0xE60F4C75),
                      ],
                    ),
                  ),
                ),
              ),
              // Product info
              Positioned(
                left: 24,
                bottom: 57,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Nila Merah\n',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w800,
                              height: 1.25,
                            ),
                          ),
                          TextSpan(
                            text: 'Premium',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5DA465),
                        borderRadius: BorderRadius.circular(9999),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
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
                      child: const Text(
                        'SIAP PANEN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          height: 1.5,
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
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14004B78),
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        children: [
          // Month header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 16),
                onPressed: () {},
                color: const Color(0xFF64748B),
              ),
              const Text(
                'Oktober 2023',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 18,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  height: 1.56,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 16),
                onPressed: () {},
                color: const Color(0xFF1E293B),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Calendar grid
          _buildCalendarGrid(),

          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE5E7EB)),
          const SizedBox(height: 16),

          // Legend
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    const weekDays = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
    final dates = [
      [26, 27, 28, 29, 30, 1, 2], // Week 1
      [3, 4, 5, 6, 7, 8, 9], // Week 2
      [10, 11, 12, 13, 14, 15, 16], // Week 3
      [17, 18, 19, 20, 21, 22, 23], // Week 4
    ];

    final dotColors = {
      5: Color(0xFF5DA465), // Green - optimal
      6: Color(0xFF5DA465),
      7: Color(0xFFEAB308), // Yellow - limited
      12: null, // Selected - no dot
      13: Color(0xFF5DA465),
      14: Color(0xFFEAB308),
    };

    return Column(
      children: [
        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekDays.map((day) {
            return SizedBox(
              width: 40,
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 10,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  height: 1.5,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // Date grid
        ...dates.map((week) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: week.map((date) {
                final isSelected = date == _selectedDay;
                final isPreviousMonth = date < 10 && week == dates[0];
                final isNextMonth = date < 10 && week != dates[0];
                final hasDot = dotColors.containsKey(date);
                final dotColor = dotColors[date];
                final isDisabled = date > 16 || isPreviousMonth;

                return _buildDateCell(
                  date,
                  isSelected: isSelected,
                  isDisabled: isDisabled,
                  hasDot: hasDot,
                  dotColor: dotColor,
                  isPreviousMonth: isPreviousMonth,
                  isNextMonth: isNextMonth,
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDateCell(
    int date, {
    bool isSelected = false,
    bool isDisabled = false,
    bool hasDot = false,
    Color? dotColor,
    bool isPreviousMonth = false,
    bool isNextMonth = false,
  }) {
    Color textColor;
    if (isSelected) {
      textColor = Colors.white;
    } else if (isDisabled) {
      textColor = const Color(0xFFD1D5DB);
    } else if (isPreviousMonth || isNextMonth) {
      textColor = const Color(0xFF9CA3AF);
    } else {
      textColor = const Color(0xFF1E293B);
    }

    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              setState(() {
                _selectedDay = date;
              });
            },
      child: SizedBox(
        width: 40,
        height: 52,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected)
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0F4C75), Color(0xFF3282B8)],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(9999),
                    bottomRight: Radius.circular(9999),
                    bottomLeft: Radius.circular(20),
                  ),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: const [
                    BoxShadow(color: Color(0x663282B8), blurRadius: 20),
                  ],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        '$date',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0D000000),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Container(
                          width: 16.5,
                          height: 16.5,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3282B8),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                width: 36,
                height: 36,
                decoration: hasDot && !isDisabled
                    ? BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFF3F4F6)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D000000),
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      )
                    : null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$date',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                        fontWeight: hasDot ? FontWeight.w500 : FontWeight.w400,
                        height: 1.43,
                      ),
                    ),
                    if (hasDot && dotColor != null)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        width: dotColor == Color(0xFF5DA465) ? 9.91 : 6,
                        height: dotColor == Color(0xFF5DA465) ? 9.91 : 6,
                        decoration: BoxDecoration(
                          color: dotColor,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0D000000),
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
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

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildLegendItem(
          'Pilihan Anda',
          const Color(0xFF3282B8),
          isPrimary: true,
        ),
        _buildLegendItem(
          'Panen Optimal',
          const Color(0xFF5DA465),
          isGreen: true,
        ),
        _buildLegendItem('Stok Terbatas', const Color(0xFFEAB308)),
        _buildLegendItem('Belum Siap', const Color(0xFFD1D5DB)),
      ],
    );
  }

  Widget _buildLegendItem(
    String label,
    Color color, {
    bool isPrimary = false,
    bool isGreen = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isPrimary
            ? const Color(0xFFF8FAFC)
            : isGreen
            ? const Color(0x80E8F5E9)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: isPrimary
                  ? const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ]
                  : null,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: isGreen ? color : const Color(0xFF64748B),
              fontSize: 12,
              fontFamily: 'Montserrat',
              fontWeight: isPrimary || isGreen
                  ? FontWeight.w600
                  : FontWeight.w500,
              height: 1.33,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSlotCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x66E2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14004B78),
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: const [
              Icon(Icons.calendar_today, size: 15, color: Color(0xFF0077B8)),
              SizedBox(width: 8),
              Text(
                'DETAIL SLOT PANEN',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.35,
                  height: 1.43,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Date & time card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0x80EFF6FF),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFDBEAFE)),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.access_time,
                    size: 20,
                    color: Color(0xFF3282B8),
                  ),
                ),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Kamis, 12 Okt 2023',
                        style: TextStyle(
                          color: Color(0xFF1E293B),
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          height: 1.43,
                        ),
                      ),
                      SizedBox(height: 3.5),
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 10,
                            color: Color(0xFF64748B),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Estimasi Siang (10:00 - 14:00)',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                              height: 1.33,
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
          const SizedBox(height: 16),

          // Capacity
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF3F4F6)),
            ),
            child: Column(
              children: const [
                Text(
                  'KAPASITAS',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '500kg - 1.2 T',
                  style: TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    height: 1.43,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3F4F6)),
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
          // Icon
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFE0F2FE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_outlined,
              size: 18,
              color: Color(0xFF0077B8),
            ),
          ),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Ingatkan Panen',
                  style: TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    height: 1.43,
                  ),
                ),
                Text(
                  'Notifikasi H-1',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                  ),
                ),
              ],
            ),
          ),

          // Toggle
          GestureDetector(
            onTap: () {
              setState(() {
                _reminderEnabled = !_reminderEnabled;
              });
            },
            child: Container(
              width: 44,
              height: 24,
              decoration: BoxDecoration(
                color: _reminderEnabled
                    ? const Color(0xFF5DA465)
                    : const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(9999),
                boxShadow: _reminderEnabled
                    ? const [
                        BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: _reminderEnabled
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white),
                  ),
                ),
              ),
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
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: const Border(top: BorderSide(color: Color(0x80FFFFFF))),
          boxShadow: const [
            BoxShadow(
              color: Color(0x330077B8),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quantity controls and total
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Quantity controls
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Jumlah Kilogram',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            height: 1.33,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF3282B8),
                                width: 1.5,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0D000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _updateQuantity(-1),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(14),
                                      bottomLeft: Radius.circular(14),
                                    ),
                                    child: Container(
                                      width: 44,
                                      height: 44,
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.remove,
                                        color: Color(0xFF3282B8),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    '$_quantity kg',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _updateQuantity(1),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(14),
                                      bottomRight: Radius.circular(14),
                                    ),
                                    child: Container(
                                      width: 44,
                                      height: 44,
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.add,
                                        color: Color(0xFF3282B8),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Total price
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Total Harga',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            height: 1.33,
                          ),
                        ),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Rp ${_formatPrice(_totalPrice)}',
                            style: const TextStyle(
                              color: Color(0xFF1E293B),
                              fontSize: 24,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              height: 1.33,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Payment button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF0F4C75),
                    Color(0xFF1E6091),
                    Color(0xFF3282B8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x4D1E3A8A),
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Color(0x4D1E3A8A),
                    blurRadius: 15,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Create booking item for cart
                    final bookingItem = {
                      'name': widget.product['name'],
                      'price': _pricePerKg,
                      'quantity': _quantity,
                      'image': widget.product['image'],
                      'type': 'booking',
                      'bookingDate': DateTime(2026, 3, _selectedDay),
                      'reminderEnabled': _reminderEnabled,
                    };

                    // Return to previous screen with booking data
                    Navigator.pop(context, bookingItem);

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${widget.product['name']} berhasil ditambahkan ke keranjang',
                        ),
                        backgroundColor: const Color(0xFF10B981),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.shopping_cart,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Tambah ke Keranjang',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            height: 1.5,
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
      ),
    );
  }
}
