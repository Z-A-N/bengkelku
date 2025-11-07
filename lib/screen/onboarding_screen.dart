import 'dart:async';
import 'package:flutter/material.dart';
import 'auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _controller = PageController();
  int _currentPage = 0;
  Timer? _autoSlideTimer;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  static const List<Map<String, String>> onboardingData = [
    {
      "image": "assets/board1.png",
      "title": "Temukan Bengkel Terdekat",
      "desc": "Lihat bengkel di sekitar kamu dengan mudah dan cepat.",
    },
    {
      "image": "assets/board2.png",
      "title": "Booking Layanan dari Rumah",
      "desc": "Pesan perbaikan kendaraan tanpa perlu datang ke bengkel.",
    },
    {
      "image": "assets/board3.png",
      "title": "Panggil Teknisi Darurat",
      "desc": "Teknisi siap datang ke lokasi kamu kapan pun dibutuhkan.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      if (!_controller.hasClients) return;

      int nextPage = _currentPage + 1;

      if (nextPage >= onboardingData.length) {
        await _fadeController.forward();
        await _controller.animateToPage(
          0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
        await _fadeController.reverse();
        nextPage = 0;
      } else {
        _controller.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  Future<void> _goToLastSlideWithFade() async {
    await _fadeController.forward();
    await _controller.animateToPage(
      onboardingData.length - 1,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
    await _fadeController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 🌅 Ornamen bawah (matahari terbit)
            const BottomHalfCircleOrnament(),

            FadeTransition(
              opacity: _fadeAnimation.drive(Tween(begin: 1.0, end: 0.6)),
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      onPageChanged: (index) {
                        if (mounted) setState(() => _currentPage = index);
                      },
                      itemCount: onboardingData.length,
                      itemBuilder: (context, index) {
                        final item = onboardingData[index];
                        final isLastSlide = index == onboardingData.length - 1;

                        // ✅ sudah diturunkan sedikit agar tampil lebih bawah
                        final double topPadding = height < 700
                            ? (isLastSlide ? 95 : 115)
                            : (isLastSlide ? 115 : 135);
                        final double imageHeight = height < 700
                            ? (isLastSlide ? 170 : 145)
                            : (isLastSlide ? 200 : 170);

                        return Padding(
                          padding: EdgeInsets.only(top: topPadding),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                item["image"]!,
                                height: imageHeight,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 35),
                              Text(
                                item["title"]!,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB01D1D),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                ),
                                child: Text(
                                  item["desc"]!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // 🔘 Dots indikator
                  if (_currentPage != onboardingData.length - 1)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          onboardingData.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 14 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? const Color(0xFFE40A0A)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 25),

                  // 🔸 Tombol CTA (halaman terakhir)
                  if (_currentPage == onboardingData.length - 1)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(80, 0, 80, 45),
                      child: ElevatedButton(
                        onPressed: _navigateToHome,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDB0C0C),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          "Mulai Sekarang",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 15),
                ],
              ),
            ),

            // 🔹 Tombol Lewati
            if (_currentPage != onboardingData.length - 1)
              Positioned(
                right: 20,
                top: 10,
                child: TextButton(
                  onPressed: _goToLastSlideWithFade,
                  child: const Text(
                    "Lewati",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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

// 🌅 Ornamen bawah seperti matahari terbit (gradasi kuning)
class BottomHalfCircleOrnament extends StatelessWidget {
  const BottomHalfCircleOrnament({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double diameter = size.width * 1.6;

    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: double.infinity,
        height: size.height * 0.4,
        child: CustomPaint(painter: _SunrisePainter(diameter)),
      ),
    );
  }
}

class _SunrisePainter extends CustomPainter {
  final double diameter;
  _SunrisePainter(this.diameter);

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height);
    final Rect rect = Rect.fromCircle(center: center, radius: diameter / 2);

    final Paint paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFF59D),
          const Color(0xFFFFEE58),
          const Color.fromARGB(60, 255, 214, 64),
          // ignore: deprecated_member_use
          Colors.white.withOpacity(0.0),
        ],
        stops: const [0.0, 0.3, 0.6, 1.0],
        center: Alignment.bottomCenter,
        radius: 1.0,
      ).createShader(rect);

    canvas.drawCircle(center, diameter / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
