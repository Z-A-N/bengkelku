// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bengkelku/widgets/ornamen_Lingkaran.dart';
import 'package:bengkelku/services/auth.dart';

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
  bool _isLoading = false;

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

  /// Fungsi kirim link reset ke email Firebase
  Future<void> _kirimLinkReset() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _tampilkanDialog(
        judul: "Email Kosong",
        pesan: "Harap masukkan alamat email kamu terlebih dahulu.",
        ikon: Icons.warning_amber_rounded,
        warna: Colors.orange,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
     await AuthService.instance.sendResetPasswordEmail(email);
      _tampilkanDialog(
        judul: "Berhasil!",
        pesan:
            "Tautan reset kata sandi telah dikirim ke:\n$email\n\nCek kotak masuk atau folder spam kamu.",
        ikon: Icons.email_outlined,
        warna: Colors.green,
      );
    } on FirebaseAuthException catch (e) {
      String pesan = "Terjadi kesalahan. Coba lagi nanti.";
      IconData ikon = Icons.error_outline;
      Color warna = Colors.redAccent;

      switch (e.code) {
        case "invalid-email":
          pesan = "Format email tidak valid. Pastikan alamat email benar.";
          break;
        case "user-not-found":
          pesan =
              "Email ini tidak terdaftar. Silakan periksa kembali atau daftar akun baru.";
          break;
        case "network-request-failed":
          pesan = "Koneksi internet bermasalah. Coba lagi.";
          break;
      }

      _tampilkanDialog(judul: "Gagal", pesan: pesan, ikon: ikon, warna: warna);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _tampilkanDialog({
    required String judul,
    required String pesan,
    required IconData ikon,
    required Color warna,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(ikon, color: warna, size: 26),
            const SizedBox(width: 10),
            Text(
              judul,
              style: TextStyle(
                color: warna,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
        content: Text(pesan, style: TextStyle(fontSize: 14.sp, height: 1.4)),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
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
                          child: Image.asset(
                            'assets/logo.png',
                            width: 100.w,
                            height: 100.w,
                            fit: BoxFit.contain,
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
                              onPressed: _isLoading ? null : _kirimLinkReset,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDB0C0C),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                elevation: 2,
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    )
                                  : Text(
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

                      // 🔙 Kembali ke Login
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
                              onTap: () => Navigator.pop(context),
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
// 💬 Deskripsi Animasi (efek mengetik)
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

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _opacity = 1;
        _offset = Offset.zero;
      });
      _typeWriterEffect();
    });
  }

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
