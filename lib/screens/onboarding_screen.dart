import 'package:flutter/material.dart';
import 'pilih_pengguna_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      badge: 'Segar & Alami',
      badgeIcon: Icons.eco,
      title: 'Ikan Nila ',
      highlightedTitle: 'Segar',
      titleEnd: '\nLangsung dari Kolam',
      description:
          'Dapatkan kualitas terbaik ikan air tawar dengan sistem pemeliharaan organik yang terjamin kebersihannya.',
      imagePath: 'assets/images/onboarding-1.png',
    ),
    OnboardingData(
      badge: 'Marketplace',
      badgeIcon: Icons.shopping_bag,
      title: 'Transaksi ',
      highlightedTitle: 'Mudah',
      titleEnd: '\n& Terpercaya',
      description:
          'Platform digital yang menghubungkan pembudidaya dengan pembeli secara langsung tanpa perantara.',
      imagePath: 'assets/images/onboarding-2.png',
    ),
    OnboardingData(
      badge: 'Komunitas',
      badgeIcon: Icons.groups,
      title: 'Tumbuh Bersama\n',
      highlightedTitle: 'Komunitas',
      titleEnd: '',
      description:
          'Bergabung dengan ribuan pembudidaya lainnya untuk saling berbagi ilmu dan pengalaman.',
      imagePath: 'assets/images/onboarding-3.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _skip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PilihPenggunaScreen()),
    );
  }

  void _continue() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PilihPenggunaScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Decorative blur circles
          Positioned(
            left: -80,
            top: -80,
            child: Container(
              width: 384,
              height: 384,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.7071,
                  colors: [
                    const Color(0xFF40916C).withOpacity(0.15),
                    const Color(0xFF40916C).withOpacity(0),
                  ],
                  stops: const [0.0, 0.7],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 40,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 198,
            top: 294.66,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.7071,
                  colors: [
                    const Color(0xFF40916C).withOpacity(0.15),
                    const Color(0xFF40916C).withOpacity(0),
                  ],
                  stops: const [0.0, 0.7],
                ),
                color: const Color(0xFF0077B6).withOpacity(0.10),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 40,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0077B6),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'SEGARA',
                            style: TextStyle(
                              color: Color(0xFF334155),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.35,
                            ),
                          ),
                        ],
                      ),
                      // Skip button
                      GestureDetector(
                        onTap: _skip,
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return _buildPage(_pages[index]);
                    },
                  ),
                ),

                // Footer
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 16, 32, 68),
                  child: Column(
                    children: [
                      // Page indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_pages.length, (index) {
                          return Container(
                            width: index == _currentPage ? 24 : 6,
                            height: 6,
                            margin: EdgeInsets.only(left: index > 0 ? 8 : 0),
                            decoration: BoxDecoration(
                              color: index == _currentPage
                                  ? const Color(0xFF0077B6)
                                  : const Color(0xFFCBD5E1),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),

                      // Continue button
                      GestureDetector(
                        onTap: _continue,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0077B6), Color(0xFF0096C7)],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0077B6).withOpacity(0.20),
                                blurRadius: 15,
                                offset: const Offset(0, 10),
                              ),
                              BoxShadow(
                                color: const Color(0xFF0077B6).withOpacity(0.20),
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  _currentPage < _pages.length - 1
                                      ? 'Selanjutnya'
                                      : 'Mulai Sekarang',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.35,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.20),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ],
                          ),
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

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFF1F5F9),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 30,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Image section
            Expanded(
              child: Stack(
                children: [
                  // Image
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: Image.asset(
                        data.imagePath,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFE2E8F0),
                            child: Center(
                              child: Icon(
                                data.badgeIcon,
                                size: 80,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Gradient overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Colors.white.withOpacity(0.90),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  // Badge
                  Positioned(
                    right: 16,
                    top: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF40916C).withOpacity(0.90),
                        borderRadius: BorderRadius.circular(9999),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            data.badgeIcon,
                            color: Colors.white,
                            size: 10,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            data.badge.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Text content section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                      children: [
                        TextSpan(
                          text: data.title,
                          style: const TextStyle(color: Color(0xFF0F172A)),
                        ),
                        TextSpan(
                          text: data.highlightedTitle,
                          style: const TextStyle(color: Color(0xFF0077B6)),
                        ),
                        TextSpan(
                          text: data.titleEnd,
                          style: const TextStyle(color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Description
                  Text(
                    data.description,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.625,
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
}

class OnboardingData {
  final String badge;
  final IconData badgeIcon;
  final String title;
  final String highlightedTitle;
  final String titleEnd;
  final String description;
  final String imagePath;

  OnboardingData({
    required this.badge,
    required this.badgeIcon,
    required this.title,
    required this.highlightedTitle,
    required this.titleEnd,
    required this.description,
    required this.imagePath,
  });
}
