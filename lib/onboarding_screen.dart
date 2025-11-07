import 'dart:async';
import 'package:flutter/material.dart';
import 'home_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  Timer? _autoSlideTimer;

  final List<Map<String, String>> onboardingData = [
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

    // Timer untuk auto-slide loop
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_controller.hasClients) {
        int nextPage = _currentPage + 1;
        if (nextPage == onboardingData.length) {
          nextPage = 0; // loop balik ke awal
        }
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
    _controller.dispose();
    _autoSlideTimer?.cancel();
    super.dispose();
  }

  void _nextPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  void _skipOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: onboardingData.length,
                    itemBuilder: (context, index) {
                      final item = onboardingData[index];

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(item["image"]!, height: 150),
                          const SizedBox(height: 30),
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
                            padding: const EdgeInsets.symmetric(horizontal: 30),
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
                      );
                    },
                  ),
                ),

                // Dots indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingData.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 16 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? const Color.fromARGB(255, 228, 10, 10)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Tombol "Mulai Sekarang" hanya di slide terakhir
                if (_currentPage == onboardingData.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD320),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Mulai Sekarang",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 219, 12, 12),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),

            // Tombol "Lewati" di kanan atas (hilang di slide terakhir)
            if (_currentPage != onboardingData.length - 1)
              Positioned(
                right: 20,
                top: 10,
                child: TextButton(
                  onPressed: _skipOnboarding,
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
