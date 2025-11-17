// Improved UI/UX version of vehicle_form_screen.dart
// Theme tetap sama, namun lebih modern, bersih, dan presisi.
// Catatan: Sesuaikan import & struktur folder sesuai project Anda.

// ignore_for_file: use_build_context_synchronously, deprecated_member_use, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  const UpperCaseTextFormatter();
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

class VehicleFormScreen extends StatefulWidget {
  const VehicleFormScreen({super.key});
  @override
  State<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends State<VehicleFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  String jenisKendaraan = "Motor";
  String? merek;
  String? model;
  String? tahun;

  final TextEditingController nomorPolisi = TextEditingController();
  final TextEditingController kilometer = TextEditingController();

  bool loading = false;

  late AnimationController anim;
  late Animation<double> fade;
  late Animation<Offset> slide;

  final Map<String, List<String>> modelMotor = {
    "Honda": ["Beat", "Vario 125", "PCX", "Scoopy"],
    "Yamaha": ["NMax", "Aerox", "Fino", "Mio"],
    "Suzuki": ["Nex II", "Address", "Satria F150"],
  };

  final Map<String, List<String>> modelMobil = {
    "Toyota": ["Avanza", "Rush", "Agya", "Yaris"],
    "Daihatsu": ["Xenia", "Ayla", "Terios", "Sigra"],
    "Honda": ["Brio", "HR-V", "Jazz", "Civic"],
  };

  @override
  void initState() {
    super.initState();
    anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    fade = CurvedAnimation(parent: anim, curve: Curves.easeInOut);
    slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic));
    anim.forward();
  }

  @override
  void dispose() {
    anim.dispose();
    nomorPolisi.dispose();
    kilometer.dispose();
    super.dispose();
  }

  Future<void> simpanData() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => loading = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("vehicle")
        .doc("main")
        .set({
          "jenis": jenisKendaraan,
          "nomorPolisi": nomorPolisi.text.trim(),
          "merek": merek,
          "model": model,
          "tahun": tahun,
          "km": kilometer.text.trim(),
          "updatedAt": DateTime.now(),
        }, SetOptions(merge: true));

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Data kendaraan berhasil disimpan!")),
    );

    Navigator.pop(context);
  }

  InputDecoration _dekor(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(color: Color(0xFFDDDDDD), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(color: Color(0xFFE6E6E6), width: 1),
      ),
      prefixIcon: Icon(icon, size: 22.sp, color: Colors.grey[800]),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Stack(
            children: [
              const OrnamenSetengahLingkaranAtas(),

              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 520.w),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 28.w,
                      vertical: 24.h,
                    ),
                    child: FadeTransition(
                      opacity: fade,
                      child: SlideTransition(
                        position: slide,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 0.04.sh),

                            Text(
                              "Isi Data\nKendaraan Anda",
                              style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.1,
                                color: Colors.black87,
                              ),
                            ),

                            SizedBox(height: 28.h),

                            Container(
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    DropdownButtonFormField(
                                      value: jenisKendaraan,
                                      decoration: _dekor(
                                        "Jenis Kendaraan",
                                        Icons.directions_bus_filled,
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                          value: "Motor",
                                          child: Text("Motor"),
                                        ),
                                        DropdownMenuItem(
                                          value: "Mobil",
                                          child: Text("Mobil"),
                                        ),
                                      ],
                                      onChanged: (v) {
                                        setState(() {
                                          jenisKendaraan = v!;
                                          merek = null;
                                          model = null;
                                        });
                                      },
                                    ),

                                    SizedBox(height: 18.h),

                                    TextFormField(
                                      controller: nomorPolisi,
                                      inputFormatters: const [
                                        UpperCaseTextFormatter(),
                                      ],
                                      decoration: _dekor(
                                        "Nomor Polisi",
                                        Icons.numbers,
                                      ),
                                      validator: (v) {
                                        if (v == null || v.isEmpty)
                                          return "Wajib diisi";
                                        final reg = RegExp(
                                          r'^[A-Z]{1,2}\s?[0-9]{1,4}\s?[A-Z]{1,3}\$',
                                        );
                                        if (!reg.hasMatch(v))
                                          return "Format plat tidak valid";
                                        return null;
                                      },
                                    ),

                                    SizedBox(height: 18.h),

                                    DropdownButtonFormField<String>(
                                      value: merek,
                                      decoration: _dekor(
                                        "Merek",
                                        Icons.branding_watermark,
                                      ),
                                      items:
                                          (jenisKendaraan == "Motor"
                                                  ? modelMotor.keys
                                                  : modelMobil.keys)
                                              .map(
                                                (m) => DropdownMenuItem(
                                                  value: m,
                                                  child: Text(m),
                                                ),
                                              )
                                              .toList(),
                                      onChanged: (v) => setState(() {
                                        merek = v;
                                        model = null;
                                      }),
                                      validator: (v) =>
                                          v == null ? "Pilih merek" : null,
                                    ),

                                    SizedBox(height: 18.h),

                                    DropdownButtonFormField<String>(
                                      value: model,
                                      decoration: _dekor(
                                        "Model",
                                        Icons.fire_truck_sharp,
                                      ),
                                      items: merek == null
                                          ? []
                                          : (jenisKendaraan == "Motor"
                                                    ? modelMotor[merek]!
                                                    : modelMobil[merek]!)
                                                .map(
                                                  (m) => DropdownMenuItem(
                                                    value: m,
                                                    child: Text(m),
                                                  ),
                                                )
                                                .toList(),
                                      onChanged: (v) =>
                                          setState(() => model = v),
                                      validator: (v) =>
                                          v == null ? "Pilih model" : null,
                                    ),

                                    SizedBox(height: 18.h),

                                    DropdownButtonFormField<String>(
                                      value: tahun,
                                      decoration: _dekor(
                                        "Tahun",
                                        Icons.date_range,
                                      ),
                                      items:
                                          List.generate(
                                                16,
                                                (i) => (2010 + i).toString(),
                                              )
                                              .map(
                                                (t) => DropdownMenuItem(
                                                  value: t,
                                                  child: Text(t),
                                                ),
                                              )
                                              .toList(),
                                      onChanged: (v) =>
                                          setState(() => tahun = v),
                                      validator: (v) =>
                                          v == null ? "Pilih tahun" : null,
                                    ),

                                    SizedBox(height: 18.h),

                                    TextFormField(
                                      controller: kilometer,
                                      keyboardType: TextInputType.number,
                                      decoration: _dekor(
                                        "Kilometer (opsional)",
                                        Icons.speed,
                                      ),
                                      validator: (v) {
                                        if (v == null || v.isEmpty) return null;
                                        if (int.tryParse(v) == null)
                                          return "Masukkan angka yang valid";
                                        return null;
                                      },
                                    ),

                                    SizedBox(height: 26.h),

                                    SizedBox(
                                      width: double.infinity,
                                      height: 52.h,
                                      child: ElevatedButton(
                                        onPressed: loading ? null : simpanData,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFFDB0C0C,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14.r,
                                            ),
                                          ),
                                        ),
                                        child: loading
                                            ? const CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              )
                                            : Text(
                                                "Simpan Data",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
}

class OrnamenSetengahLingkaranAtas extends StatelessWidget {
  const OrnamenSetengahLingkaranAtas({super.key});
  @override
  Widget build(BuildContext context) {
    final diameter = 1.6.sw;
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: double.infinity,
        height: 0.3.sh,
        child: CustomPaint(painter: _MatahariTerbit(diameter)),
      ),
    );
  }
}

class _MatahariTerbit extends CustomPainter {
  final double diameter;
  const _MatahariTerbit(this.diameter);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, 0);
    final area = Rect.fromCircle(center: center, radius: diameter / 2);

    final paint = Paint()
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

    canvas.drawCircle(center, diameter / 2, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
