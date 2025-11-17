// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/home_dashboard.dart';
import 'vehicle_form_screen.dart';

class Masuk extends StatefulWidget {
  const Masuk({super.key});

  @override
  State<Masuk> createState() => _MasukState();
}

class _MasukState extends State<Masuk> with SingleTickerProviderStateMixin {
  // FORM KEY
  final _formKey = GlobalKey<FormState>();

  // CONTROLLERS
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _isLoading = false;

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

    _loadRememberMe();
  }

  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString("saved_email");
    final savedRemember = prefs.getBool("remember_me") ?? false;

    if (savedEmail != null) {
      setState(() {
        _emailController.text = savedEmail;
        _rememberMe = savedRemember;
      });
    }
  }

  @override
  void dispose() {
    _pengendaliAnimasi.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // =====================================================================
  //                     LOGIN USER
  // =====================================================================
  Future<void> _loginUser() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // LOGIN
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;
      if (user == null) return;

      // REMEMBER ME
      final prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        prefs.setString("saved_email", email);
        prefs.setBool("remember_me", true);
      } else {
        prefs.remove("saved_email");
        prefs.setBool("remember_me", false);
      }

      // CEK KENDARAAN DI FIRESTORE
      final vehicleDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("vehicle")
          .doc("main")
          .get();

      if (!mounted) return;

      if (!vehicleDoc.exists) {
        // USER BARU → Belum isi data kendaraan
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const VehicleFormScreen()),
        );
      } else {
        // USER LAMA → Sudah isi data kendaraan
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeDashboard()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String msg = "Terjadi kesalahan";

      switch (e.code) {
        case "invalid-email":
          msg = "Format email salah";
          break;
        case "user-not-found":
          msg = "Email tidak terdaftar";
          break;
        case "wrong-password":
          msg = "Password salah";
          break;
        case "network-request-failed":
          msg = "Koneksi internet bermasalah";
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // =====================================================================
  //                         UI
  // =====================================================================

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

                        // JUDUL
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
                            ),
                          ),
                        ),

                        SizedBox(height: 25.h),

                        // EMAIL
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Email wajib diisi";
                            }
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+$',
                            ).hasMatch(v.trim())) {
                              return "Email tidak valid";
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
                          ),
                        ),

                        SizedBox(height: 18.h),

                        // PASSWORD
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _sembunyikanPassword,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Kata sandi wajib diisi";
                            }
                            return null;
                          },
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
                                () => _sembunyikanPassword =
                                    !_sembunyikanPassword,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10.h),

                        // REMEMBER ME + LUPA PASSWORD
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (v) =>
                                      setState(() => _rememberMe = v ?? false),
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
                                    builder: (_) => const LupaKataSandi(),
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

                        // TOMBOL MASUK
                        SizedBox(
                          width: double.infinity,
                          height: 48.h,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _loginUser,
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

                        // PEMBATAS
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

                        _tombolSosial(
                          'Lanjut dengan Google',
                          'assets/google.webp',
                        ),
                        SizedBox(height: 15.h),
                        _tombolSosial(
                          'Lanjut dengan Facebook',
                          'assets/fb.webp',
                        ),

                        SizedBox(height: 25.h),

                        // KE DAFTAR
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
                                    builder: (_) => const Daftar(),
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
            ),
          ],
        ),
      ),
    );
  }

  // TOMBOL SOSIAL
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

// ORNAMEN TETAP
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
