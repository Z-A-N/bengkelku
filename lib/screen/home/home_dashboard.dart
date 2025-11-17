import 'package:flutter/material.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: const Color(0xFFDB0C0C),
      ),
      body: const Center(
        child: Text(
          "Selamat datang di Dashboard!",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
