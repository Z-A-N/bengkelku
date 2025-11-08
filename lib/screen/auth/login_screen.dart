import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  bool _obscureText = true;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            const TopHalfCircleOrnament(),

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
                      SizedBox(
                        height: 0.05.sh,
                      ), // ✅ posisi logo disesuaikan (5% tinggi layar)
                      // 🌅 Logo
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
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
                        opacity: _fadeAnimation,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Sign in to your\n",
                                  style: TextStyle(
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                  ),
                                ),
                                TextSpan(
                                  text: "Account",
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
                          "Enter your email and password to log in",
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
                          hintText: "example@gmail.com",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                      ),

                      SizedBox(height: 18.h),

                      // 🔒 Password
                      TextField(
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () =>
                                setState(() => _obscureText = !_obscureText),
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      // 🔘 Remember me & Forgot Password
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
                                "Remember me",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot Password?",
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

                      // 🔴 Tombol Login
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
                            "Log In",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // OR Divider
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
                              "Or",
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

                      // 🟢 Google Button
                      _socialButton(
                        'Continue with Google',
                        'assets/google.png',
                      ),

                      SizedBox(height: 15.h),

                      // 🔵 Facebook Button
                      _socialButton('Continue with Facebook', 'assets/fb.png'),

                      SizedBox(height: 25.h),

                      // 🔻 Sign Up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don’t have an account? ",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "Sign Up",
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

  Widget _socialButton(String label, String iconPath) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: OutlinedButton.icon(
        icon: Image.asset(iconPath, width: 22.w),
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        label: Text(
          label,
          style: TextStyle(fontSize: 15.sp, color: Colors.black87),
        ),
      ),
    );
  }
}

//
// ☀️ Ornamen setengah lingkaran
//
class TopHalfCircleOrnament extends StatelessWidget {
  const TopHalfCircleOrnament({super.key});

  @override
  Widget build(BuildContext context) {
    final double diameter = 1.6.sw;
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: double.infinity,
        height: 0.3.sh,
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
    final Offset center = Offset(size.width / 2, 0);
    final Rect rect = Rect.fromCircle(center: center, radius: diameter / 2);

    final Paint paint = Paint()
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
      ).createShader(rect);

    canvas.drawCircle(center, diameter / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
