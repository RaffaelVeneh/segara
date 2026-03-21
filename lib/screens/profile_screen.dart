import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'my_orders_screen.dart';
import 'settings_screen.dart';
import '../utils/app_snackbar.dart';

class ProfileScreen extends StatefulWidget {
  final String role;

  const ProfileScreen({super.key, required this.role});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final isMitra = widget.role == 'mitra';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-1.0, -1.0),
            radius: 1.414,
            colors: [
              const Color(0xFF0D9488).withValues(alpha: 0.05),
              const Color(0xFF0D9488).withValues(alpha: 0),
            ],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(1.0, -1.0),
              radius: 1.414,
              colors: [
                const Color(0xFF0284C7).withValues(alpha: 0.05),
                const Color(0xFF0284C7).withValues(alpha: 0),
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Header
                _buildHeader(),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 130),
                      child: Column(
                        children: [
                          // Profile Section
                          _buildProfileSection(isMitra),
                          const SizedBox(height: 40),
                          // Menu Items
                          _buildMenuItems(isMitra),
                          const SizedBox(height: 40),
                          // Footer
                          _buildFooter(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC).withValues(alpha: 0.8),
        border: const Border(bottom: BorderSide(color: Colors.transparent)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/icons/logo-segara.png',
                width: 25,
                height: 27.5,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 25,
                    height: 27.5,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D9488),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              const Text(
                'Akun Saya',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(role: widget.role),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
              ),
              child: const Icon(
                Icons.settings_outlined,
                color: Color(0xFF4B5563),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(bool isMitra) {
    return SizedBox(
      height: 196,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Avatar at top
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Avatar with gradient border
                  Container(
                    width: 112,
                    height: 112,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0D9488), Color(0xFF0284C7)],
                      ),
                      borderRadius: BorderRadius.circular(9999),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9999),
                        child: Image.network(
                          'https://placehold.co/96x96',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFFF3F4F6),
                              child: const Icon(
                                Icons.person,
                                size: 48,
                                color: Color(0xFF9CA3AF),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  // Edit button
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9999),
                        border: Border.all(
                          color: const Color(0xFFF3F4F6),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Color(0xFF0D9488),
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Name
          Positioned(
            left: 0,
            right: 0,
            top: 112,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  isMitra ? 'Budi Santoso' : 'Budi Santoso',
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
          // Badge
          Positioned(
            left: 0,
            right: 0,
            top: 156,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCCFBF1).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified,
                        color: Color(0xFF115E59),
                        size: 12,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isMitra ? 'MITRA STRATEGIS' : 'PEMBELI UMUM',
                        style: const TextStyle(
                          color: Color(0xFF115E59),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                          height: 1.33,
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
    );
  }

  Widget _buildMenuItems(bool isMitra) {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.person_outline,
          title: 'Profile Saya',
          subtitle: 'Kelola alamat pengiriman',
          backgroundColor: const Color(0xFFEFF6FF),
          iconColor: const Color(0xFF0284C7),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Fitur Edit Profile akan segera hadir pada update berikutnya.',
                ),
                backgroundColor: Color(0xFF0077B6),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        _buildMenuItem(
          icon: Icons.location_on_outlined,
          title: 'Alamat Saya',
          subtitle: 'Kelola alamat pengiriman',
          backgroundColor: const Color(0xFFEFF6FF),
          iconColor: const Color(0xFF0284C7),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Fitur Edit Address akan segera hadir pada update berikutnya.',
                ),
                backgroundColor: Color(0xFF0077B6),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        _buildMenuItem(
          icon: Icons.receipt_long_outlined,
          title: 'Riwayat Pesanan',
          subtitle: 'Cek status transaksi',
          backgroundColor: const Color(0xFFF0FDFA),
          iconColor: const Color(0xFF0D9488),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyOrdersScreen()),
            );
          },
        ),
        const SizedBox(height: 8),
        _buildMenuItem(
          icon: Icons.headset_mic_outlined,
          title: 'Pusat Bantuan',
          subtitle: 'Hubungi Admin IKANURA',
          backgroundColor: const Color(0xFFF8FAFC),
          iconColor: const Color(0xFF475569),
          onTap: () {
            AppSnackBar.showInfo(
              context,
              message: 'Fitur ini akan segera hadir pada update berikutnya.',
            );
          },
        ),
        const SizedBox(height: 16),
        _buildMenuItem(
          icon: Icons.logout,
          title: 'Keluar',
          subtitle: null,
          backgroundColor: const Color(0xFFFEF2F2),
          iconColor: const Color(0xFFEF4444),
          textColor: const Color(0xFFDC2626),
          hasBorder: true,
          borderColor: const Color(0xFFFEF2F2),
          onTap: () {
            _showLogoutDialog();
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required Color backgroundColor,
    required Color iconColor,
    Color? textColor,
    bool hasBorder = false,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: hasBorder && borderColor != null
              ? Border.all(color: borderColor, width: 1)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: subtitle != null ? 18 : 18,
              ),
            ),
            const SizedBox(width: 16),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor ?? const Color(0xFF111827),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.43,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.33,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Chevron
            if (subtitle != null)
              const Icon(
                Icons.chevron_right,
                color: Color(0xFFD1D5DB),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Opacity(
      opacity: 0.6,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 8),
              const Text(
                'SEGARA x IKANURA',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.7,
                  height: 1.43,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Versi 1.0.0 (Marketplace)',
            style: TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 10,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Keluar',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Batal',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ),
            TextButton(
              onPressed: () {
                // Pop dialog
                Navigator.pop(context);
                // Navigate to login and clear all routes
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text(
                'Keluar',
                style: TextStyle(
                  color: Color(0xFFDC2626),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
