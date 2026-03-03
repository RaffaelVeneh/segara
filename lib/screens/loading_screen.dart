import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Navigate to onboarding after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.2, -1.0),
            end: Alignment(0.2, 1.0),
            colors: [Color(0xFF0077B6), Color(0xFF023E8A)],
          ),
        ),
        child: Stack(
          children: [
            // Bottom wave decorations
            Positioned(
              left: 0,
              bottom: 0,
              child: SizedBox(
                width: 390,
                height: 250,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 781.30,
                        height: 189.55,
                        decoration: BoxDecoration(
                          color: const Color(0xFF90E0EF).withOpacity(0.10),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Container(
                        width: 781.30,
                        height: 229.14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF48CAE4).withOpacity(0.15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Blurred decorative circles
            Positioned(
              left: 84,
              top: -176.80,
              child: Container(
                width: 384,
                height: 384,
                decoration: BoxDecoration(
                  color: const Color(0xFF48CAE4).withOpacity(0.20),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 100,
                      spreadRadius: 50,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: -39,
              top: 539.61,
              child: Container(
                width: 256,
                height: 256,
                decoration: BoxDecoration(
                  color: const Color(0xFF48CAE4).withOpacity(0.10),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 80,
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
                  // Top logos (UNY & KSI)
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLogoIcon('assets/icons/logo-UNY.png'),
                        const SizedBox(width: 16),
                        _buildLogoIcon('assets/icons/logo-ksi.png'),
                      ],
                    ),
                  ),
                  
                  // Center logo section
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo with shadow
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Blurred background
                              Container(
                                width: 192,
                                height: 192,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 40,
                                      spreadRadius: 20,
                                    ),
                                  ],
                                ),
                              ),
                              // Main logo circle (Segara)
                              Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.20),
                                    width: 4,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.20),
                                      blurRadius: 50,
                                      offset: Offset(0, 25),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/icons/logo-segara.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // SEGARA text
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              'SEGARA',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 3.60,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.07),
                                    offset: const Offset(0, 4),
                                    blurRadius: 3,
                                  ),
                                  Shadow(
                                    color: Colors.black.withOpacity(0.06),
                                    offset: const Offset(0, 2),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Decorative line
                          const SizedBox(height: 12),
                          Container(
                            width: 64,
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0),
                                  Colors.white.withOpacity(0.50),
                                  Colors.white.withOpacity(0),
                                ],
                              ),
                            ),
                          ),
                          
                          // Subtitle
                          const SizedBox(height: 14),
                          Text(
                            'FRESH FISH MARKETPLACE',
                            style: TextStyle(
                              color: const Color(0xFFDBEAFE),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 3.60,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Bottom section
                  Padding(
                    padding: const EdgeInsets.only(bottom: 48, left: 24, right: 24),
                    child: Column(
                      children: [
                        // Program info
                        Text(
                          'Program Penguatan Kapasitas\nOrganisasi Kemahasiswaan (PPK Ormawa)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.90),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.625,
                          ),
                        ),
                        
                        // Separator
                        const SizedBox(height: 4),
                        Container(
                          width: 96,
                          height: 1,
                          color: Colors.white.withOpacity(0.20),
                        ),
                        
                        // Location
                        const SizedBox(height: 8),
                        Text(
                          'KALURAHAN SIDOAGUNG, GODEAN, SLEMAN',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFFBFDBFE),
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.25,
                          ),
                        ),
                        
                        // Loading dots
                        const SizedBox(height: 32),
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (index) {
                                double delay = index * 0.3;
                                double value = (_controller.value + delay) % 1.0;
                                double opacity = (value < 0.5) 
                                  ? 0.3 + (value * 1.4) 
                                  : 1.0 - ((value - 0.5) * 1.4);
                                
                                return Padding(
                                  padding: EdgeInsets.only(
                                    left: index > 0 ? 8.0 : 0,
                                  ),
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(opacity.clamp(0.3, 1.0)),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
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

  Widget _buildLogoIcon(String assetPath) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.20),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ClipOval(
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
