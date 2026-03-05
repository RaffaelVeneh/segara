import 'package:flutter/material.dart';

class SellerOrderScreen extends StatefulWidget {
  const SellerOrderScreen({super.key});

  @override
  State<SellerOrderScreen> createState() => _SellerOrderScreenState();
}

class _SellerOrderScreenState extends State<SellerOrderScreen> {
  String _selectedFilter = 'Semua';

  final List<Map<String, dynamic>> _orderList = [
    {
      'id': '#IKN-8821-1',
      'name': 'Lele Sangkuri...',
      'image': 'https://placehold.co/80x80',
      'status': 'Baru',
      'statusBg': const Color(0xFFEFF6FF),
      'statusColor': const Color(0xFF0F4C81),
      'weight': '500 kg',
      'weightIcon': Icons.scale,
      'deadline': 'Besok, 08:00',
      'deadlineUrgent': true,
      'canHarvest': true,
    },
    {
      'id': '#IKN-8821-2',
      'name': 'Nila Gede',
      'image': 'https://placehold.co/80x80',
      'status': 'Baru',
      'statusBg': const Color(0xFFEFF6FF),
      'statusColor': const Color(0xFF0F4C81),
      'weight': '500 kg',
      'weightIcon': Icons.scale,
      'deadline': 'Besok, 08:00',
      'deadlineUrgent': true,
      'canHarvest': true,
    },
    {
      'id': '#IKN-8824',
      'name': 'Nila Merah...',
      'image': 'https://placehold.co/88x88',
      'status': 'Sedang\nPanen',
      'statusBg': const Color(0xFFFAFDEC),
      'statusColor': const Color(0xFFCEC700),
      'weight': '1.2\nton',
      'weightIcon': Icons.scale,
      'deadline': 'Deadline: 26\nOkt',
      'deadlineUrgent': false,
      'canHarvest': false,
      'harvestProgress': 850,
      'harvestTotal': 1200,
    },
    {
      'id': '#IKN-8830',
      'name': 'Gurame Soang',
      'image': 'https://placehold.co/80x80',
      'status': 'Siap\nPanen',
      'statusBg': const Color(0xFFECFDF5),
      'statusColor': const Color(0xFF10B981),
      'weight': '300\nkg',
      'weightIcon': Icons.scale,
      'deadline': 'Deadline: 28\nOkt',
      'deadlineUrgent': false,
      'canHarvest': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterTabs(),
          Expanded(
            child: _buildOrderList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(
        top: 48,
        bottom: 8,
        left: 24,
        right: 24,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'IKANURA BRANDING',
                    style: TextStyle(
                      color: const Color(0xFF0F4C81),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Daftar Pesanan',
                    style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Kelompok Tani Mina Jaya',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF475569),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari pesanan...',
                      hintStyle: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF94A3B8),
                        size: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.tune,
                  color: Color(0xFF475569),
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = ['Semua', 'Perlu Proses', 'Siap Kirim'];

    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10.5,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0077B6) : Colors.white,
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            const BoxShadow(
                              color: Color(0xFFE2E8F0),
                              blurRadius: 15,
                              offset: Offset(0, 10),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF475569),
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildOrderList() {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        itemCount: _orderList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          return _buildOrderCard(_orderList[index]);
        },
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final hasProgress = order.containsKey('harvestProgress');

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Gradient overlay for first cards
          if (!hasProgress)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          // Green blur decoration for "Siap Panen"
          if (order['status'] == 'Siap\nPanen')
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.05),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.1),
                      blurRadius: 60,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // First product in multi-product order
                _buildProductItem(order),
                
                // Show progress bar if harvesting
                if (hasProgress) ...[
                  const SizedBox(height: 20),
                  _buildHarvestProgress(order),
                ],
                
                const SizedBox(height: 16),
                
                // Action buttons
                _buildActionButtons(order),
                
                // Second product if it's the first card (multi-product)
                if (order['id'] == '#IKN-8821-1') ...[
                  const SizedBox(height: 16),
                  _buildProductItem({
                    ...order,
                    'id': '#IKN-8821-2',
                    'name': 'Nila Gede',
                  }),
                  const SizedBox(height: 16),
                  _buildActionButtons(order),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> order) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: const Color(0xFFF1F5F9),
              child: const Icon(
                Icons.image_outlined,
                color: Color(0xFF94A3B8),
                size: 32,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      order['name'] as String,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: order['statusBg'] as Color,
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(
                        color: (order['statusBg'] as Color).withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      order['status'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: order['statusColor'] as Color,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.25,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Order ID: ${order['id']}',
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          order['weightIcon'] as IconData,
                          color: const Color(0xFF64748B),
                          size: 12,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          order['weight'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF475569),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: order['deadlineUrgent'] == true
                          ? const Color(0xFFFEF2F2)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: order['deadlineUrgent'] == true
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF64748B),
                          size: 12,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          order['deadline'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: order['deadlineUrgent'] == true
                                ? const Color(0xFFDC2626)
                                : const Color(0xFF64748B),
                            fontSize: 12,
                            fontWeight: order['deadlineUrgent'] == true
                                ? FontWeight.w600
                                : FontWeight.w400,
                            height: 1.33,
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
      ],
    );
  }

  Widget _buildHarvestProgress(Map<String, dynamic> order) {
    final progress = order['harvestProgress'] as int;
    final total = order['harvestTotal'] as int;
    final percentage = progress / total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'ESTIMASI PANEN',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$progress',
                    style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    ' / $total kg',
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 48,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Background track with dashed pattern
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9999),
                          child: CustomPaint(
                            painter: _DashedLinePainter(),
                          ),
                        ),
                      ),
                    ),
                    // Progress fill
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: constraints.maxWidth * percentage,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                    ),
                    // Fish marker
                    Positioned(
                      left: (constraints.maxWidth * percentage) - 12,
                      bottom: -8,
                      child: Column(
                        children: [
                          Transform.rotate(
                            angle: -0.2,
                            child: Container(
                              width: 24,
                              height: 22,
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 1,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.water_outlined,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                          Container(
                            width: 4,
                            height: 16,
                            padding: const EdgeInsets.only(top: 4),
                            child: Container(
                              width: 4,
                              height: 12,
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(9999),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> order) {
    final canHarvest = order['canHarvest'] as bool;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF0037),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              shadowColor: Colors.black.withOpacity(0.05),
            ),
            child: const Text(
              'Tolak',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: canHarvest ? () {} : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: canHarvest ? const Color(0xFF0077B6) : const Color(0xFFC7C7C7),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              shadowColor: Colors.black.withOpacity(0.05),
              disabledBackgroundColor: const Color(0xFFC7C7C7),
              disabledForegroundColor: Colors.white,
            ),
            child: const Text(
              'Panen',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE2E8F0).withOpacity(0.5)
      ..strokeWidth = 6;

    const dashWidth = 10.0;
    const dashSpace = 90.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
