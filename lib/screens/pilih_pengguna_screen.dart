import 'package:flutter/material.dart';
import 'login_screen.dart';

class PilihPenggunaScreen extends StatefulWidget {
  const PilihPenggunaScreen({super.key});

  @override
  State<PilihPenggunaScreen> createState() => _PilihPenggunaScreenState();
}

class _PilihPenggunaScreenState extends State<PilihPenggunaScreen> {
  String? _selectedRole;

  void _continue() {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih peran terlebih dahulu'),
          backgroundColor: Color(0xFF0077B6),
        ),
      );
      return;
    }

    // Navigate to login screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Butuh Bantuan?'),
        content: const Text(
          'Pilih "Pembeli Umum" jika Anda ingin membeli ikan untuk konsumsi pribadi atau keluarga.\n\n'
          'Pilih "Mitra Strategis" jika Anda pemilik usaha (rumah makan, hotel, catering) yang membutuhkan pasokan ikan secara rutin.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Decorative background elements
                    Stack(
                      children: [
                        // Blue wave decoration
                        Positioned(
                          left: -40,
                          top: 100.67,
                          child: Container(
                            width: 534,
                            height: 95.10,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1466B8).withValues(alpha: 0.05),
                            ),
                          ),
                        ),
                        // Blur circle
                        Positioned(
                          left: 204,
                          top: -40,
                          child: Container(
                            width: 192,
                            height: 192,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDBEAFE).withValues(alpha: 0.60),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 64,
                                  spreadRadius: 64,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Main content
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Logo
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/icons/logo-segara.png',
                                        width: 38,
                                        height: 38,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                width: 38,
                                                height: 38,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF0077B6),
                                                  shape: BoxShape.circle,
                                                ),
                                              );
                                            },
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'SEGARA',
                                        style: TextStyle(
                                          color: Color(0xFF0F172A),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          height: 1.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Help button
                                  GestureDetector(
                                    onTap: _showHelp,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFFF1F5F9),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 
                                              0.05,
                                            ),
                                            blurRadius: 2,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.help_outline,
                                        color: Color(0xFF94A3B8),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),

                              // Title
                              const Text(
                                'Pilih Peran Pengguna\nBaru',
                                style: TextStyle(
                                  color: Color(0xFF0F172A),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 7.38),

                              // Subtitle
                              const Text(
                                'Siapa Anda? Pilih peran untuk\nmenyesuaikan pengalaman aplikasi Anda.',
                                style: TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 1.625,
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Role cards
                              _buildRoleCard(
                                role: 'buyer',
                                icon: Icons.shopping_basket,
                                iconColor: const Color(0xFF1466B8),
                                backgroundColor: const Color(0xFFEFF6FF),
                                title: 'Pembeli Umum',
                                description:
                                    'Ikan Segar & Sehat untuk Keluarga',
                                isSelected: _selectedRole == 'buyer',
                              ),
                              const SizedBox(height: 24),

                              _buildRoleCard(
                                role: 'mitra',
                                icon: Icons.business_center,
                                iconColor: const Color(0xFF4F46E5),
                                backgroundColor: const Color(0xFFEEF2FF),
                                title: 'Mitra Strategis',
                                description:
                                    'Suplai Stabil & Harga Kontrak untuk\nBisnis',
                                isSelected: _selectedRole == 'mitra',
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

            // Bottom section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.50),
                border: const Border(
                  top: BorderSide(color: Color(0xFFF1F5F9), width: 1),
                ),
              ),
              child: Column(
                children: [
                  // Continue button
                  GestureDetector(
                    onTap: _continue,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment(-0.95, 0.31),
                          end: Alignment(0.95, -0.31),
                          colors: [Color(0xFF1466B8), Color(0xFF0F4C8A)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1466B8).withValues(alpha: 0.30),
                            blurRadius: 15,
                            offset: const Offset(0, 10),
                          ),
                          BoxShadow(
                            color: const Color(0xFF1466B8).withValues(alpha: 0.30),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Lanjutkan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              height: 28 / 18,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 13,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Help link
                  GestureDetector(
                    onTap: _showHelp,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.help_outline,
                          color: Color(0xFF94A3B8),
                          size: 13.31,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Butuh bantuan memilih?',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 16 / 12,
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
      ),
    );
  }

  Widget _buildRoleCard({
    required String role,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String description,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1466B8) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1466B8).withValues(alpha: 0.25),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and radio button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(icon, color: iconColor, size: 25),
                ),
                // Radio button
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF1466B8)
                          : const Color(0xFFE2E8F0),
                      width: 2,
                    ),
                    color: isSelected
                        ? const Color(0xFF1466B8)
                        : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Center(
                          child: Icon(
                            Icons.circle,
                            color: Colors.white,
                            size: 10,
                          ),
                        )
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 28 / 18,
              ),
            ),
            const SizedBox(height: 7),

            // Description
            Text(
              description,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.375,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
