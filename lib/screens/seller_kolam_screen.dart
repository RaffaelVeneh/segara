import 'package:flutter/material.dart';

class SellerKolamScreen extends StatefulWidget {
  const SellerKolamScreen({super.key});

  @override
  State<SellerKolamScreen> createState() => _SellerKolamScreenState();
}

class _SellerKolamScreenState extends State<SellerKolamScreen> {
  String _selectedFilter = 'Semua';

  final List<Map<String, dynamic>> _kolamList = [
    {
      'name': 'Kolam A1',
      'status': 'Siap Panen',
      'statusColor': const Color(0xFF34D399),
      'statusBg': const Color(0xFFDCFCE7),
      'statusTextColor': const Color(0xFF15803D),
      'accentColor': const Color(0xFF34D399),
      'fishData': [
        {'type': 'Nila', 'progress': 0.98, 'tebar': '12 Jan 2023', 'est': 'Besok'},
        {'type': 'Bawal', 'progress': 0.98, 'tebar': '12 Jan 2023', 'est': 'Besok'},
        {'type': 'Lele', 'progress': 0.98, 'tebar': '12 Jan 2023', 'est': 'Besok'},
      ],
    },
    {
      'name': 'Kolam B2',
      'status': 'Pertumbuhan',
      'statusColor': const Color(0xFF0EA5E9),
      'statusBg': const Color(0xFFE0F2FE),
      'statusTextColor': const Color(0xFF0B88CB),
      'accentColor': const Color(0xFF0EA5E9),
      'fishData': [
        {'type': 'Nila', 'progress': 0.45, 'tebar': '12 Jan 2023', 'est': 'Besok'},
        {'type': 'Bawal', 'progress': 0.45, 'tebar': '12 Jan 2023', 'est': 'Besok'},
        {'type': 'Lele', 'progress': 0.45, 'tebar': '20 Feb 2023', 'est': '15 Mei 2023'},
      ],
    },
    {
      'name': 'Kolam C4',
      'status': 'Pertumbuhan',
      'statusColor': const Color(0xFF0EA5E9),
      'statusBg': const Color(0xFFE0F2FE),
      'statusTextColor': const Color(0xFF0B88CB),
      'accentColor': const Color(0xFF0EA5E9),
      'fishData': [
        {'type': 'Nila', 'progress': 0.15, 'tebar': '12 Jan 2023', 'est': 'Besok'},
        {'type': 'Bawal', 'progress': 0.15, 'tebar': '12 Jan 2023', 'est': 'Besok'},
        {'type': 'Lele', 'progress': 0.15, 'tebar': '20 Feb 2023', 'est': '15 Mei 2023'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 95),
                      _buildFilterChips(),
                      const SizedBox(height: 24),
                      _buildSectionHeader(),
                      const SizedBox(height: 24),
                      _buildKolamList(),
                      const SizedBox(height: 96),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 300,
              left: 20,
              right: 20,
              child: _buildSearchBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(
        top: 48,
        bottom: 60,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B88CB), Color(0xFF086AA0)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative gradient circle
          Positioned(
            left: -195,
            top: -169,
            child: Container(
              width: 780,
              height: 676,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.7,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SEGARA App',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.35,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Monitoring Produksi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '260 Kolam Terpadu',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Container(
                            color: const Color(0xFFE2E8F0),
                            child: const Icon(
                              Icons.person,
                              color: Color(0xFF94A3B8),
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF34D399),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.water_outlined,
                      label: 'AKTIF',
                      value: '260',
                      unit: 'Kolam',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.flag_outlined,
                      label: 'TARGET',
                      value: '12.5',
                      unit: 'Ton',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 15,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari nama kolam...',
                hintStyle: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF94A3B8),
                  size: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 15,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Stack(
          children: [
            Container(
              width: 48,
              height: 47,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 15,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.tune,
                color: Color(0xFF475569),
                size: 18,
              ),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF34D399),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      {'label': 'Semua', 'color': null},
      {'label': 'Siap Panen', 'color': const Color(0xFF34D399)},
      {'label': 'Pertumbuhan', 'color': const Color(0xFF0EA5E9)},
      {'label': 'Kosong', 'color': const Color(0xFFCBD5E1)},
    ];

    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter['label'];

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter['label'] as String;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0B88CB) : Colors.white,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(
                  color: isSelected ? Colors.transparent : const Color(0xFFF1F5F9),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isSelected ? 0.1 : 0.05),
                    blurRadius: isSelected ? 6 : 2,
                    offset: Offset(0, isSelected ? 4 : 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (filter['color'] != null) ...[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: filter['color'] as Color,
                        shape: BoxShape.circle,
                        boxShadow: filter['label'] == 'Siap Panen'
                            ? [
                                BoxShadow(
                                  color: (filter['color'] as Color).withOpacity(0.6),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    filter['label'] as String,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF475569),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'Daftar Kolam',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF0B88CB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: const Text(
              'PRIORITAS PANEN',
              style: TextStyle(
                color: Color(0xFF0B88CB),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKolamList() {
    return Column(
      children: _kolamList.map((kolam) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: _buildKolamCard(kolam),
      )).toList(),
    );
  }

  Widget _buildKolamCard(Map<String, dynamic> kolam) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Top-right gradient decoration
          Positioned(
            right: -20,
            top: -19,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    (kolam['accentColor'] as Color).withOpacity(0.1),
                    (kolam['accentColor'] as Color).withOpacity(0),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(9999),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.water,
                          color: Color(0xFF94A3B8),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        kolam['name'] as String,
                        style: const TextStyle(
                          color: Color(0xFF1E293B),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: kolam['statusBg'] as Color,
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(
                        color: kolam['statusBg'] as Color,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: (kolam['statusColor'] as Color)
                                    .withOpacity(0.75),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: kolam['statusColor'] as Color,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          (kolam['status'] as String).toUpperCase(),
                          style: TextStyle(
                            color: kolam['statusTextColor'] as Color,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pertumbuhan',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...(kolam['fishData'] as List<Map<String, dynamic>>)
                      .map((fish) => _buildFishProgress(fish, kolam['accentColor'] as Color))
                      .toList(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFishProgress(Map<String, dynamic> fish, Color accentColor) {
    final progress = fish['progress'] as double;
    final isHighProgress = progress >= 0.9;
    
    Color progressColor;
    Color progressGradientStart;
    Color progressGradientEnd;
    
    if (isHighProgress) {
      progressColor = const Color(0xFF34D399);
      progressGradientStart = const Color(0xFF4ADE80);
      progressGradientEnd = const Color(0xFF34D399);
    } else if (progress >= 0.3) {
      progressColor = const Color(0xFF0EA5E9);
      progressGradientStart = const Color(0xFF60A5FA);
      progressGradientEnd = const Color(0xFF0EA5E9);
    } else {
      progressColor = const Color(0xFF22D3EE);
      progressGradientStart = const Color(0xFF93C5FD);
      progressGradientEnd = const Color(0xFF22D3EE);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  fish['type'] as String,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                        ),
                        Container(
                          height: 12,
                          width: constraints.maxWidth * progress,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [progressGradientStart, progressGradientEnd],
                            ),
                            borderRadius: BorderRadius.circular(9999),
                            
                          ),
                        ),
                        if (progress < 1.0 && progress > 0.05)
                          Positioned(
                            left: (constraints.maxWidth * progress) - 8,
                            top: -5,
                            child: Container(
                              width: 16,
                              height: 22,
                              decoration: BoxDecoration(
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 30,
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    color: progressColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tebar: ${fish['tebar']}',
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Est: ${fish['est']}',
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
