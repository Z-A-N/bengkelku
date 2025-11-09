// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Daftar extends StatefulWidget {
  const Daftar({super.key});

  @override
  State<Daftar> createState() => _DaftarState();
}

class _DaftarState extends State<Daftar> with SingleTickerProviderStateMixin {
  bool _sembunyikanPassword = true;
  bool _sembunyikanKonfirmasi = true;
  late AnimationController _pengendaliAnimasi;
  late Animation<double> _animasiFade;
  late Animation<Offset> _animasiGeser;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            const OrnamenSetengahLingkaranAtas(),

            // 🧱 Konten utama
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
                      SizedBox(height: 0.05.sh),

                      // 🌅 Logo
                      FadeTransition(
                        opacity: _animasiFade,
                        child: SlideTransition(
                          position: _animasiGeser,
                          child: Center(
                            child: Image.asset(
                              'assets/logo.png',
                              width: 90.w,
                              height: 90.w,
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
                                  text: "Buat Akun\n",
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                  ),
                                ),
                                TextSpan(
                                  text: "Baru Sekarang",
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFDB0C0C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 8.h),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Isi informasi di bawah ini untuk membuat akun Anda.",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(height: 25.h),

                      // 👤 Nama lengkap
                      TextField(
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: "Nama Lengkap",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                      ),

                      SizedBox(height: 18.h),

                      // ✉️ Email
                      TextField(
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

                      SizedBox(height: 18.h),

                      // 🔒 Password
                      TextField(
                        obscureText: _sembunyikanPassword,
                        decoration: InputDecoration(
                          labelText: "Kata Sandi",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _sembunyikanPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () => setState(
                              () =>
                                  _sembunyikanPassword = !_sembunyikanPassword,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 18.h),

                      // 🔐 Konfirmasi Password
                      TextField(
                        obscureText: _sembunyikanKonfirmasi,
                        decoration: InputDecoration(
                          labelText: "Konfirmasi Kata Sandi",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          prefixIcon: const Icon(Icons.lock_person_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _sembunyikanKonfirmasi
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () => setState(
                              () => _sembunyikanKonfirmasi =
                                  !_sembunyikanKonfirmasi,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 25.h),

                      // 🔴 Tombol Daftar
                      SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDB0C0C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            "Daftar Sekarang",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 25.h),

                      // 🔻 Sudah punya akun
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sudah punya akun? ",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(
                                context,
                              ); // Kembali ke halaman login
                            },
                            child: Text(
                              "Masuk di sini",
                              style: TextStyle(
                                color: const Color(0xFFDB0C0C),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
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
// ☀️ Ornamen setengah lingkaran atas (sama seperti di halaman Masuk)
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
