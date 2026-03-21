import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import 'onboarding_screen.dart';
import 'main_screen.dart';
import 'seller_main_screen.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({super.key});

  @override
  ConsumerState<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _navigationDone = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Check login status and navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && !_navigationDone) {
        _handleNavigation();
      }
    });
  }

  Future<void> _handleNavigation() async {
    _navigationDone = true;

    // Check login status from SharedPreferences/SecureStorage
    final authNotifier = ref.read(authProvider.notifier);
    await authNotifier.checkLoginStatus();

    // Watch the auth state after checking
    final authState = ref.read(authProvider);

    if (!mounted) return;

    if (authState.isLoggedIn && authState.user != null) {
      // User is logged in, navigate to role-based screen
      final userRole = authState.user!.role;

      late Widget nextScreen;
      switch (userRole.toUpperCase()) {
        case 'ADMIN':
          nextScreen = const MainScreen(role: 'admin');
          break;
        case 'SELLER_RT':
          nextScreen = const SellerMainScreen();
          break;
        case 'BUYER':
        default:
          nextScreen = const MainScreen(role: 'buyer');
          break;
      }

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.easeInOut;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            var opacityAnimation = animation.drive(tween);

            return FadeTransition(opacity: opacityAnimation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    } else {
      // User not logged in, navigate to onboarding
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.easeInOut;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            var opacityAnimation = animation.drive(tween);

            return FadeTransition(opacity: opacityAnimation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
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
                          color: const Color(0xFF90E0EF).withValues(alpha: 0.10),
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
                          color: const Color(0xFF48CAE4).withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Animated logo in center
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: Tween(begin: 0.8, end: 1.2).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Curves.easeInOut,
                      ),
                    ),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.waves,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Segara',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
