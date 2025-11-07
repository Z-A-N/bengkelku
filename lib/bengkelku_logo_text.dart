import 'package:flutter/material.dart';

class BengkelKuText extends StatelessWidget {
  const BengkelKuText({super.key, this.fontSize = 34});

  final double fontSize;

  Shader _linearGradient(List<Color> colors) {
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, fontSize));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // ✨ Teks "Bengkel" (outline kuning, isi gradient merah glossy)
        Stack(
          children: [
            // Outline kuning
            Text(
              'Bengkel',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w900,
                fontFamily: 'Poppins',
                letterSpacing: 1.2,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = const Color.fromARGB(246, 248, 204, 28),
              ),
            ),
            // Isi gradient merah
            Text(
              'Bengkel',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w900,
                fontFamily: 'Poppins',
                letterSpacing: 1.2,
                foreground: Paint()
                  ..shader = _linearGradient([
                    const Color.fromARGB(255, 247, 75, 106), // merah muda terang
                    const Color(0xFFE21B4D), // merah figma
                    const Color(0xFFC0103A), // merah tua
                  ]),
                shadows: const [
                  Shadow(
                    offset: Offset(1, 2),
                    blurRadius: 3,
                    color: Color(0x33000000),
                  ),
                ],
              ),
            ),
          ],
        ),

        // ✨ Teks "Ku." (outline merah tua, isi gradient kuning glossy)
        Stack(
          children: [
            // Outline merah tua
            Text(
              'Ku.',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w900,
                fontFamily: 'Poppins',
                letterSpacing: 1.2,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = const Color(0xFFB01D1D),
              ),
            ),
            // Isi gradient kuning
            Text(
              'Ku.',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w900,
                fontFamily: 'Poppins',
                letterSpacing: 1.2,
                foreground: Paint()
                  ..shader = _linearGradient([
                    const Color(0xFFFFF799), // kuning pucat atas
                    const Color(0xFFFFD320), // kuning utama
                    const Color(0xFFF9B700), // kuning keemasan bawah
                  ]),
                shadows: const [
                  Shadow(
                    offset: Offset(1, 2),
                    blurRadius: 3,
                    color: Color(0x33000000),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
