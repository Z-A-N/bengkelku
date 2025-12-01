// ignore_for_file: deprecated_member_use, unnecessary_underscores

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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  late AnimationController _pengendaliAnimasi;
  late Animation<double> _animasiFade;
  late Animation<Offset> _animasiGeser;

  String? _emailErrorText;
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

    // Reset error ketika user ngetik lagi
    _emailController.addListener(() {
      if (_emailErrorText != null) {
        setState(() => _emailErrorText = null);
      }
    });
  }

  @override
  void dispose() {
    _pengendaliAnimasi.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // ===============================================================
  // SNACKBAR
  // ===============================================================
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: isError
              ? Colors.red.shade700
              : const Color(0xFF27AE60),
          content: Text(message),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  // ===============================================================
  // KIRIM RESET PASSWORD – MIRIP LOGIN, TANPA CEK PAKSA
  // ===============================================================
  Future<void> _kirimLinkReset() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();

    setState(() {
      _isLoading = true;
      _emailErrorText = null;
    });

    try {
      await AuthService.instance.sendResetPasswordEmail(email);

      // Firebase secara security TIDAK kasih tahu apakah email terdaftar atau tidak.
      // Jadi selalu kasih pesan general:
      _showSnackBar(
        "Jika email terdaftar, tautan reset kata sandi telah dikirim.",
        isError: false,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          setState(() => _emailErrorText = "Format email salah");
          break;

        case "network-request-failed":
          _showSnackBar("Koneksi internet bermasalah.", isError: true);
          break;

        // Beberapa versi lama masih bisa kirim user-not-found,
        // kalau mau, bisa juga kamu munculkan error di bawah field:
        case "user-not-found":
          setState(() => _emailErrorText = "Email tidak terdaftar");
          break;

        default:
          _showSnackBar("Terjadi kesalahan. Coba lagi.", isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ===============================================================
  // UI
  // ===============================================================
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 0.05.sh),

                        // LOGO
                        FadeTransition(
                          opacity: _animasiFade,
                          child: SlideTransition(
                            position: _animasiGeser,
                            child: Image.asset(
                              'assets/logo.png',
                              width: 90.w,
                              height: 90.w,
                            ),
                          ),
                        ),

                        SizedBox(height: 25.h),

                        // JUDUL (mirip login)
                        FadeTransition(
                          opacity: _animasiFade,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Reset\n",
                                    style: TextStyle(
                                      fontSize: 26.sp,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Kata Sandi",
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
                            "Masukkan email kamu untuk menerima tautan reset kata sandi.",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),

                        SizedBox(height: 25.h),

                        // INPUT EMAIL
                        FadeTransition(
                          opacity: _animasiFade,
                          child: SlideTransition(
                            position: _animasiGeser,
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return "Email wajib diisi";
                                }
                                final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                                if (!regex.hasMatch(v.trim())) {
                                  return "Format email tidak valid";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Email",
                                hintText: "contoh@gmail.com",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                prefixIcon: const Icon(Icons.email_outlined),
                                errorText: _emailErrorText,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 25.h),

                        // TOMBOL KIRIM RESET (mirip tombol login)
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

                        SizedBox(height: 20.h),

                        // KEMBALI KE LOGIN (mirip login footer)
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
            ),
          ],
        ),
      ),
    );
  }
}
