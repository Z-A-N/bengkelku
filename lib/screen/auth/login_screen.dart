// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Masuk extends StatefulWidget {
  const Masuk({super.key});

  @override
  State<Masuk> createState() => _MasukState();
}

class _MasukState extends State<Masuk> with SingleTickerProviderStateMixin {
  bool _sembunyikanPassword = true;
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
                                  text: "Masuk ke akun\n",
                                  style: TextStyle(
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                  ),
                                ),
                                TextSpan(
                                  text: "Anda",
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

                      SizedBox(height: 8.h),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Masukkan email dan kata sandi untuk masuk",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(height: 25.h),

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

                      SizedBox(height: 10.h),

                      // 🔘 Ingat saya & Lupa kata sandi
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: false,
                                onChanged: (_) {},
                                activeColor: const Color(0xFFDB0C0C),
                              ),
                              Text(
                                "Ingat saya",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LupaKataSandi(),
                                ),
                              );
                            },
                            child: Text(
                              "Lupa kata sandi?",
                              style: TextStyle(
                                color: const Color(0xFFDB0C0C),
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15.h),

                      // 🔴 Tombol Masuk
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
                            "Masuk",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Garis pembatas “Atau”
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Text(
                              "Atau",
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // 🟢 Tombol Google
                      _tombolSosial(
                        'Lanjut dengan Google',
                        'assets/google.png',
                      ),

                      SizedBox(height: 15.h),

                      // 🔵 Tombol Facebook
                      _tombolSosial('Lanjut dengan Facebook', 'assets/fb.png'),

                      SizedBox(height: 25.h),

                      // 🔻 Daftar akun
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Belum punya akun? ",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Daftar(),
                                ),
                              );
                            },
                            child: Text(
                              "Daftar",
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

  // 🧩 Komponen tombol sosial media
  Widget _tombolSosial(String teks, String pathIkon) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: OutlinedButton.icon(
        icon: Image.asset(pathIkon, width: 22.w),
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        label: Text(
          teks,
          style: TextStyle(fontSize: 15.sp, color: Colors.black87),
        ),
      ),
    );
  }
}

//
// ☀️ Ornamen setengah lingkaran atas
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
