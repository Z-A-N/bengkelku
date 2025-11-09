// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LupaKataSandi extends StatefulWidget {
  const LupaKataSandi({super.key});

  @override
  State<LupaKataSandi> createState() => _LupaKataSandiState();
}

class _LupaKataSandiState extends State<LupaKataSandi>
    with SingleTickerProviderStateMixin {
  late AnimationController _pengendaliAnimasi;
  late Animation<double> _animasiFade;
  late Animation<Offset> _animasiGeser;

  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _pengendaliAnimasi = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animasiFade = CurvedAnimation(
      parent: _pengendaliAnimasi,
      curve: Curves.easeInOut,
    );

    _animasiGeser = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _pengendaliAnimasi,
            curve: Curves.easeOutCubic,
          ),
        );

    _pengendaliAnimasi.forward();
  }

  @override
  void dispose() {
    _pengendaliAnimasi.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _kirimLinkReset() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap masukkan alamat email kamu")),
      );
      return;
    }

    // TODO: Tambahkan logika backend (Firebase / API)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Link reset kata sandi telah dikirim ke $email")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            const OrnamenSetengahLingkaranAtas(),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500.w),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.w,
                    vertical: 25.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 0.06.sh),

                      // 🌅 Logo
                      FadeTransition(
                        opacity: _animasiFade,
                        child: SlideTransition(
                          position: _animasiGeser,
                          child: Center(
                            child: Image.asset(
                              'assets/logo.png',
                              width: 100.w,
                              height: 100.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 25.h),

                      // 📝 Judul
                      FadeTransition(
                        opacity: _animasiFade,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Lupa\n",
                                  style: TextStyle(
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                  ),
                                ),
                                TextSpan(
                                  text: "Kata Sandi?",
                                  style: TextStyle(
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFDB0C0C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      // 🗒 Deskripsi dengan efek mengetik tanpa kursor
                      const DeskripsiAnimasi(),

                      SizedBox(height: 30.h),

                      // ✉️ Input Email
                      FadeTransition(
                        opacity: _animasiFade,
                        child: SlideTransition(
                          position: _animasiGeser,
                          child: TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Email",
                              hintText: "contoh@gmail.com",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              prefixIcon: const Icon(Icons.email_outlined),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 25.h),

                      // 🔴 Tombol Kirim Link Reset
                      FadeTransition(
                        opacity: _animasiFade,
                        child: SlideTransition(
                          position: _animasiGeser,
                          child: SizedBox(
                            width: double.infinity,
                            height: 48.h,
                            child: ElevatedButton(
                              onPressed: _kirimLinkReset,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDB0C0C),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                elevation: 2,
                              ),
                              child: Text(
                                "Kirim Tautan Reset",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 25.h),

                      // 🔙 Kembali ke Halaman Login
                      FadeTransition(
                        opacity: _animasiFade,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Ingat kata sandimu? ",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black87,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Masuk Sekarang",
                                style: TextStyle(
                                  color: const Color(0xFFDB0C0C),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 0.1.sh),
                    ],
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

//
// 🌅 Ornamen Setengah Lingkaran Atas
//
class OrnamenSetengahLingkaranAtas extends StatelessWidget {
  const OrnamenSetengahLingkaranAtas({super.key});

  @override
  Widget build(BuildContext context) {
    final double diameter = 1.6.sw;
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: double.infinity,
        height: 0.3.sh,
        child: CustomPaint(painter: _LukisMatahariTerbit(diameter)),
      ),
    );
  }
}

class _LukisMatahariTerbit extends CustomPainter {
  final double diameter;
  _LukisMatahariTerbit(this.diameter);

  @override
  void paint(Canvas canvas, Size size) {
    final Offset tengah = Offset(size.width / 2, 0);
    final Rect area = Rect.fromCircle(center: tengah, radius: diameter / 2);

    final Paint kuas = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFF59D),
          const Color(0xFFFFEE58),
          const Color.fromARGB(60, 255, 214, 64),
          Colors.white.withOpacity(0.0),
        ],
        stops: const [0.0, 0.3, 0.6, 1.0],
        center: Alignment.topCenter,
        radius: 1.0,
      ).createShader(area);

    canvas.drawCircle(tengah, diameter / 2, kuas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

//
// 💬 Deskripsi Animasi dengan Efek Mengetik (tanpa kursor)
//
class DeskripsiAnimasi extends StatefulWidget {
  const DeskripsiAnimasi({super.key});

  @override
  State<DeskripsiAnimasi> createState() => _DeskripsiAnimasiState();
}

class _DeskripsiAnimasiState extends State<DeskripsiAnimasi> {
  final String _text =
      "Masukkan email kamu untuk mendapatkan tautan reset kata sandi.";
  String _displayedText = "";
  double _opacity = 0;
  Offset _offset = const Offset(0, 0.05);

  @override
  void initState() {
    super.initState();

    // Delay sebelum animasi mulai
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _opacity = 1;
        _offset = Offset.zero;
      });
      _typeWriterEffect();
    });
  }

  // Efek mengetik huruf per huruf
  void _typeWriterEffect() async {
    for (int i = 0; i < _text.length; i++) {
      await Future.delayed(const Duration(milliseconds: 25));
      if (!mounted) return;
      setState(() {
        _displayedText = _text.substring(0, i + 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      child: AnimatedSlide(
        offset: _offset,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _displayedText,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}
