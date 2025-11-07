import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => const OnboardingScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Shader linearGradient(List<Color> colors) {
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset('assets/logo.png', width: 120, height: 120),
              ),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // ✨ BENGKEL (outline kuning, isi gradient merah glossy)
                  Stack(
                    children: [
                      Text(
                        'Bengkel',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Poppins',
                          letterSpacing: 1.2,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = const Color.fromARGB(
                              246,
                              248,
                              203,
                              25,
                            ), // outline kuning
                        ),
                      ),
                      Text(
                        'Bengkel',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Poppins',
                          letterSpacing: 1.2,
                          foreground: Paint()
                            ..shader = linearGradient([
                              const Color.fromARGB(
                                255,
                                231,
                                56,
                                88,
                              ), // merah muda terang
                              const Color(0xFFE21B4D), // merah figma
                              const Color(0xFFC0103A), // merah tua bawah
                            ]),
                          shadows: const [
                            Shadow(
                              offset: Offset(1, 2),
                              blurRadius: 3,
                              color: Color(0x33000000),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // ✨ KU. (outline merah tua, isi gradient kuning glossy)
                  Stack(
                    children: [
                      Text(
                        'Ku.',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Poppins',
                          letterSpacing: 1.2,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = const Color(
                              0xFFB01D1D,
                            ), // outline merah tua
                        ),
                      ),
                      Text(
                        'Ku.',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Poppins',
                          letterSpacing: 1.2,
                          foreground: Paint()
                            ..shader = linearGradient([
                              const Color(0xFFFFF799), // kuning pucat atas
                              const Color(0xFFFFD320), // kuning utama
                              const Color(0xFFF9B700), // kuning keemasan bawah
                            ]),
                          shadows: const [
                            Shadow(
                              offset: Offset(1, 2),
                              blurRadius: 3,
                              color: Color(0x33000000),
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
        ),
      ),
    );
  }
}
