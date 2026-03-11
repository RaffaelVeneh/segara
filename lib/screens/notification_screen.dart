import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  final String role;

  const NotificationScreen({
    super.key,
    required this.role,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedTab = 0;

  // Notification categories: 0=all, 1=order, 2=news
  final List<Map<String, dynamic>> _notifications = [
    {
      'category': 'order',
      'section': 'HARI INI',
      'sectionColor': Color(0xFF0975AE),
      'icon': Icons.receipt_long,
      'iconColor': Color(0xFF0975AE),
      'iconBg': Color(0xFF0975AE),
      'title': 'Pesanan #INV-2023',
      'time': '10:30',
      'timeBg': Color(0xFF0975AE),
      'timeColor': Color(0xFF0975AE),
      'description': 'Pembeli telah menerima paket ikan\nnila segar (50kg). Dana akan…',
      'hasAction': true,
      'isUnread': true,
      'hasStars': false,
      'opacity': 1.0,
    },
    {
      'category': 'news',
      'section': 'KEMARIN',
      'sectionColor': Color(0xFFCBD5E1),
      'icon': Icons.build_outlined,
      'iconColor': Color(0xFFD97706),
      'iconBg': Color(0xFFFEF3C7),
      'title': 'Maintenance Sistem',
      'time': '14:00',
      'timeBg': Colors.transparent,
      'timeColor': Color(0xFF94A3B8),
      'description': 'Aplikasi akan maintenance pada jam\n01:00 - 04:00 WIB untuk peningkata…',
      'hasAction': false,
      'isUnread': false,
      'hasStars': false,
      'opacity': 0.9,
    },
    {
      'category': 'order',
      'section': 'KEMARIN',
      'sectionColor': Color(0xFFCBD5E1),
      'icon': Icons.local_shipping_outlined,
      'iconColor': Color(0xFF2563EB),
      'iconBg': Color(0xFFDBEAFE),
      'title': 'Paket Sedang Dikirim',
      'time': '09:15',
      'timeBg': Colors.transparent,
      'timeColor': Color(0xFF94A3B8),
      'description': 'Pesanan #INV-2022 sedang dalam\nperjalanan menuju lokasi pembeli d…',
      'hasAction': false,
      'isUnread': false,
      'hasStars': false,
      'opacity': 0.9,
    },
    {
      'category': 'order',
      'section': 'MINGGU LALU',
      'sectionColor': Color(0xFFCBD5E1),
      'icon': Icons.star_outline,
      'iconColor': Color(0xFF9333EA),
      'iconBg': Color(0xFFF3E8FF),
      'title': 'Ulasan Baru Diterima',
      'time': '20 Des',
      'timeBg': Colors.transparent,
      'timeColor': Color(0xFF94A3B8),
      'description': '"Ikan sehat dan lincah! Pengiriman\nsangat cepat dan aman."',
      'hasAction': false,
      'isUnread': false,
      'hasStars': true,
      'opacity': 0.8,
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedTab == 0) {
      // Semua
      return _notifications;
    } else if (_selectedTab == 1) {
      // Pesanan
      return _notifications.where((n) => n['category'] == 'order').toList();
    } else {
      // Berita
      return _notifications.where((n) => n['category'] == 'news').toList();
    }
  }

  Map<String, List<Map<String, dynamic>>> get _groupedNotifications {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var notification in _filteredNotifications) {
      final section = notification['section'] as String;
      if (!grouped.containsKey(section)) {
        grouped[section] = [];
      }
      grouped[section]!.add(notification);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Tab Filter
            _buildTabFilter(),
            // Notifications List
            Expanded(
              child: _filteredNotifications.isEmpty
                  ? _buildEmptyState()
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 130),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildNotificationSections(),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC).withOpacity(0.8),
      ),
      child: Center(
        child: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.33,
          ),
        ),
      ),
    );
  }

  Widget _buildTabFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTabButton('Semua', 0),
            const SizedBox(width: 8),
            _buildTabButton('Pesanan', 1),
            const SizedBox(width: 8),
            _buildTabButton('Berita', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isActive = _selectedTab == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0975AE) : Colors.white,
          borderRadius: BorderRadius.circular(9999),
          border: isActive 
              ? null 
              : Border.all(color: const Color(0xFFF1F5F9), width: 1),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF0975AE).withOpacity(0.3),
                    blurRadius: 40,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF475569),
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            height: 1.43,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String label, Color dotColor) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: dotColor,
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            height: 1.33,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String time,
    required Color timeBg,
    required Color timeColor,
    required String description,
    required bool hasAction,
    required bool isUnread,
    bool hasStars = false,
    double opacity = 1.0,
  }) {
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFF8FAFC),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Unread indicator
            if (isUnread)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(1),
                        blurRadius: 0,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  color: Color(0xFF0F172A),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  height: 1.43,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: timeBg,
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: Text(
                                time,
                                style: TextStyle(
                                  color: timeColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Description
                        Text(
                          description,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.625,
                          ),
                        ),
                        if (hasAction) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: const [
                              Text(
                                'Lihat Rincian',
                                style: TextStyle(
                                  color: Color(0xFF0975AE),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  height: 1.33,
                                ),
                              ),
                              SizedBox(width: 2),
                              Icon(
                                Icons.arrow_forward,
                                color: Color(0xFF0975AE),
                                size: 12,
                              ),
                            ],
                          ),
                        ],
                        if (hasStars) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: List.generate(
                              5,
                              (index) => const Padding(
                                padding: EdgeInsets.only(right: 2),
                                child: Icon(
                                  Icons.star,
                                  color: Color(0xFFFACC15),
                                  size: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNotificationSections() {
    final List<Widget> widgets = [];
    final sections = _groupedNotifications;
    final sectionOrder = ['HARI INI', 'KEMARIN', 'MINGGU LALU'];
    
    bool isFirst = true;
    for (var sectionName in sectionOrder) {
      if (sections.containsKey(sectionName)) {
        final notifications = sections[sectionName]!;
        
        // Add spacing before section (except first)
        if (!isFirst) {
          widgets.add(const SizedBox(height: 24));
        }
        
        // Section header
        final firstNotif = notifications.first;
        widgets.add(_buildSectionHeader(
          sectionName,
          firstNotif['sectionColor'] as Color,
        ));
        widgets.add(const SizedBox(height: 16));
        
        // Notifications in this section
        for (int i = 0; i < notifications.length; i++) {
          final notif = notifications[i];
          widgets.add(_buildNotificationCard(
            icon: notif['icon'] as IconData,
            iconColor: notif['iconColor'] as Color,
            iconBg: notif['iconBg'] is Color
                ? notif['iconBg'] as Color
                : (notif['iconBg'] as Color).withOpacity(0.1),
            title: notif['title'] as String,
            time: notif['time'] as String,
            timeBg: notif['timeBg'] is Color
                ? notif['timeBg'] as Color
                : (notif['timeBg'] as Color).withOpacity(0.05),
            timeColor: notif['timeColor'] as Color,
            description: notif['description'] as String,
            hasAction: notif['hasAction'] as bool,
            isUnread: notif['isUnread'] as bool,
            hasStars: notif['hasStars'] as bool,
            opacity: notif['opacity'] as double,
          ));
          
          // Add spacing between notifications
          if (i < notifications.length - 1) {
            widgets.add(const SizedBox(height: 16));
          }
        }
        
        isFirst = false;
      }
    }
    
    return widgets;
  }

  Widget _buildEmptyState() {
    String message;
    if (_selectedTab == 1) {
      message = 'Belum ada notifikasi pesanan';
    } else if (_selectedTab == 2) {
      message = 'Belum ada notifikasi berita';
    } else {
      message = 'Belum ada notifikasi';
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: const Color(0xFFCBD5E1),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Notifikasi akan muncul di sini',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
