// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Daftar extends StatefulWidget {
  const Daftar({super.key});

  @override
  State<Daftar> createState() => _DaftarState();
}

class _DaftarState extends State<Daftar> with SingleTickerProviderStateMixin {
  bool _sembunyikanPassword = true;
  bool _sembunyikanKonfirmasi = true;
  bool _isLoading = false;
  bool _isPasswordFocused = false;

  double _strengthValue = 0;
  Color _strengthColor = Colors.grey;
  String _strengthLabel = "";

  String? _emailErrorText;

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late final AnimationController _pengendaliAnimasi;
  late final Animation<double> _animasiFade;
  late final Animation<Offset> _animasiGeser;

  @override
  void initState() {
    super.initState();

    _pengendaliAnimasi = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _animasiFade = CurvedAnimation(
      parent: _pengendaliAnimasi,
      curve: Curves.easeIn,
    );

    _animasiGeser = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _pengendaliAnimasi, curve: Curves.easeOut),
        );

    _pengendaliAnimasi.forward();

    _emailController.addListener(() {
      if (_emailErrorText != null) setState(() => _emailErrorText = null);
    });

    _passwordController.addListener(() => setState(() {}));
    _konfirmasiController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _pengendaliAnimasi.dispose();
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _konfirmasiController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(email);
  }

  void _updatePasswordStrength(String password) {
    if (password.isEmpty) {
      _strengthValue = 0;
      _strengthColor = Colors.grey;
      _strengthLabel = "";
    } else if (password.length < 6) {
      _strengthValue = 0.25;
      _strengthColor = Colors.redAccent;
      _strengthLabel = "❌ Lemah";
    } else if (RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{6,}$').hasMatch(password)) {
      _strengthValue = 0.5;
      _strengthColor = Colors.orangeAccent;
      _strengthLabel = "⚠️ Sedang";
    } else if (RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$%^&*_\-]).{6,}$',
    ).hasMatch(password)) {
      _strengthValue = 1.0;
      _strengthColor = Colors.green;
      _strengthLabel = "💪 Kuat";
    } else {
      _strengthValue = 0.25;
      _strengthColor = Colors.redAccent;
      _strengthLabel = "❌ Lemah";
    }
    setState(() {});
  }

  Future<void> _daftarUser() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _emailErrorText = null;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final nama = _namaController.text.trim();

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseAuth.instance.currentUser?.updateDisplayName(nama);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Akun berhasil dibuat! Silakan login.')),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'email-already-in-use':
            _emailErrorText = 'Email sudah digunakan.';
            break;
          case 'invalid-email':
            _emailErrorText = 'Format email tidak valid.';
            break;
          case 'weak-password':
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Kata sandi terlalu lemah.')),
            );
            break;
          case 'network-request-failed':
            _emailErrorText = 'Tidak dapat terhubung ke jaringan.';
            break;
          default:
            _emailErrorText = e.message ?? 'Terjadi kesalahan.';
        }
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPasswordMatch =
        _konfirmasiController.text.trim() == _passwordController.text.trim();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                        children: [
                          SizedBox(height: 0.05.sh),
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
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Buat Akun\nBaru Sekarang",
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                                height: 1.1,
                              ),
                            ),
                          ),
                          SizedBox(height: 25.h),

                          // 👤 Nama Lengkap
                          TextFormField(
                            controller: _namaController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: _inputDecoration(
                              label: "Nama Lengkap",
                              icon: Icons.person_outline,
                            ),
                            validator: (v) {
                              final t = (v ?? '').trim();
                              if (t.isEmpty) return 'Nama wajib diisi';
                              if (t.length < 3) return 'Nama terlalu pendek';
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          // ✉️ Email
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: _inputDecoration(
                              label: "Email",
                              icon: Icons.email_outlined,
                              error: _emailErrorText,
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Email wajib diisi';
                              }
                              if (!_isValidEmail(v.trim())) {
                                return 'Email tidak valid';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          // 🔒 Password
                          Focus(
                            onFocusChange: (hasFocus) =>
                                setState(() => _isPasswordFocused = hasFocus),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _sembunyikanPassword,
                              onChanged: _updatePasswordStrength,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: _inputDecoration(
                                label: "Kata Sandi",
                                icon: Icons.lock_outline,
                                suffix: IconButton(
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
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Kata sandi wajib diisi';
                                }
                                if (_strengthValue < 0.5) {
                                  return 'Kata sandi terlalu lemah';
                                }
                                return null;
                              },
                            ),
                          ),

                          // 🌈 Indikator
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            height:
                                (_isPasswordFocused ||
                                    _passwordController.text.isNotEmpty)
                                ? 60.h
                                : 0,
                            curve: Curves.easeOut,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8.h),
                                Text(
                                  "Huruf besar, kecil, angka, & simbol.",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13.sp,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: LinearProgressIndicator(
                                    value: _strengthValue,
                                    minHeight: 6.h,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation(
                                      _strengthColor,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  _strengthLabel,
                                  style: TextStyle(
                                    color: _strengthColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // 🔐 Konfirmasi Password
                          TextFormField(
                            controller: _konfirmasiController,
                            obscureText: _sembunyikanKonfirmasi,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: _inputDecoration(
                              label: "Konfirmasi Kata Sandi",
                              icon: Icons.lock_person_outlined,
                              suffix: IconButton(
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
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Konfirmasi wajib diisi';
                              }
                              if (!isPasswordMatch) {
                                return 'Konfirmasi tidak cocok';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 25.h),

                          // 🔴 Tombol Daftar
                          SizedBox(
                            width: double.infinity,
                            height: 48.h,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _daftarUser,
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
                                  : const Text(
                                      "Daftar Sekarang",
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
                          SizedBox(height: 25.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Sudah punya akun? ",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Text(
                                  "Masuk di sini",
                                  style: TextStyle(
                                    color: Color(0xFFDB0C0C),
                                    fontWeight: FontWeight.bold,
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
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? error,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
      prefixIcon: Icon(icon),
      errorText: error,
      suffixIcon: suffix,
    );
  }
}

// ☀️ Ornamen atas
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
      ..shader = const RadialGradient(
        colors: [
          Color(0xFFFFF59D),
          Color(0xFFFFEE58),
          Color.fromARGB(60, 255, 214, 64),
          Colors.transparent,
        ],
        stops: [0.0, 0.3, 0.6, 1.0],
        center: Alignment.topCenter,
        radius: 1.0,
      ).createShader(area);
    canvas.drawCircle(tengah, diameter / 2, kuas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
