import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // ukuran desain dasar (misal iPhone 13)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bengkelku',
          home: const SplashScreen(),
        );
      },
    );
  }
}
