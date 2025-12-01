// ignore_for_file: use_build_context_synchronously, deprecated_member_use, curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bengkelku/widgets/ornamen_Lingkaran.dart';
import 'package:bengkelku/services/auth.dart';

// ---------------------------------------------------------
// Uppercase formatter untuk plat nomor
// ---------------------------------------------------------
class UpperCaseTextFormatter extends TextInputFormatter {
  const UpperCaseTextFormatter();
  @override
  TextEditingValue formatEditUpdate(_, newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

// ---------------------------------------------------------
// Slim Dropdown — Floating Label Version
// ---------------------------------------------------------
class SlimDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final IconData? icon; // boleh null (tanpa ikon)
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const SlimDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.icon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: value,
      validator: validator,
      decoration: InputDecoration(
        labelText: label, // ← FLOATING LABEL
        prefixIcon: icon == null ? null : Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFDB0C0C), width: 1.4),
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }
}

// ---------------------------------------------------------
// MAIN SCREEN
// ---------------------------------------------------------
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

  final nomorPolisi = TextEditingController();
  final kilometer = TextEditingController();

  bool loading = false;

  late AnimationController anim;
  late Animation<double> fade;
  late Animation<Offset> slide;

  final modelMotor = {
    "Honda": ["Beat", "Vario 125", "PCX", "Scoopy"],
    "Yamaha": ["NMax", "Aerox", "Fino", "Mio"],
    "Suzuki": ["Nex II", "Address", "Satria F150"],
  };

  final modelMobil = {
    "Toyota": ["Avanza", "Rush", "Agya", "Yaris"],
    "Daihatsu": ["Xenia", "Ayla", "Terios", "Sigra"],
    "Honda": ["Brio", "HR-V", "Jazz", "Civic"],
  };

  // Ikon dinamis hanya untuk jenis kendaraan
  IconData getVehicleIcon() {
    return jenisKendaraan == "Motor"
        ? Icons.motorcycle_rounded
        : Icons.directions_car_rounded;
  }

  @override
  void initState() {
    super.initState();

    anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    fade = CurvedAnimation(parent: anim, curve: Curves.easeInOut);
    slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
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

  // Save Vehicle
  Future<void> simpanData() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Sesi habis / user belum login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sesi kamu habis. Silakan login kembali."),
          ),
        );
        Navigator.of(context).pop(); // balik ke sebelumnya (misal login)
        return;
      }

      await AuthService.instance.saveVehicleData(
        uid: user.uid,
        jenis: jenisKendaraan,
        nomorPolisi: nomorPolisi.text.trim(),
        merek: merek,
        model: model,
        tahun: tahun,
        km: kilometer.text.trim().isEmpty ? null : kilometer.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data kendaraan berhasil disimpan!")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menyimpan data kendaraan. Coba lagi."),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  // TextField floating label
  InputDecoration _input(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label, // ← FLOATING LABEL
      prefixIcon: icon == null ? null : Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Color(0xFFDB0C0C), width: 1.4),
      ),
    );
  }

  // ---------------------------------------------------------
  // UI
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
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
                            SizedBox(height: 0.05.sh),

                            Text(
                              "Isi Data\nKendaraan Anda",
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 24.h),

                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // Jenis Kendaraan — floating label + icon dinamis
                                  SlimDropdown(
                                    label: "Jenis Kendaraan",
                                    value: jenisKendaraan,
                                    items: const ["Motor", "Mobil"],
                                    icon: getVehicleIcon(),
                                    onChanged: (v) {
                                      setState(() {
                                        jenisKendaraan = v!;
                                        merek = null;
                                        model = null;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 20.h),

                                  // Nomor Polisi — floating label
                                  TextFormField(
                                    controller: nomorPolisi,
                                    inputFormatters: const [
                                      UpperCaseTextFormatter(),
                                    ],
                                    decoration: _input("Nomor Polisi"),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return "Wajib diisi";
                                      }
                                      final reg = RegExp(
                                        r'^[A-Z]{1,2}\s?[0-9]{1,4}\s?[A-Z]{1,3}$',
                                      );
                                      if (!reg.hasMatch(v)) {
                                        return "Format tidak valid";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 20.h),

                                  // Merek — floating label
                                  SlimDropdown(
                                    label: "Merek",
                                    value: merek,
                                    items:
                                        (jenisKendaraan == "Motor"
                                                ? modelMotor.keys
                                                : modelMobil.keys)
                                            .toList(),
                                    icon: null,
                                    onChanged: (v) {
                                      setState(() {
                                        merek = v;
                                        model = null;
                                      });
                                    },
                                    validator: (v) =>
                                        v == null ? "Pilih merek" : null,
                                  ),
                                  SizedBox(height: 20.h),

                                  // Model — floating label
                                  SlimDropdown(
                                    label: "Model",
                                    value: model,
                                    items: merek == null
                                        ? []
                                        : (jenisKendaraan == "Motor"
                                              ? modelMotor[merek]!
                                              : modelMobil[merek]!),
                                    icon: null,
                                    onChanged: (v) => setState(() => model = v),
                                    validator: (v) =>
                                        v == null ? "Pilih model" : null,
                                  ),
                                  SizedBox(height: 20.h),

                                  // Tahun — floating label
                                  SlimDropdown(
                                    label: "Tahun",
                                    value: tahun,
                                    items: List.generate(
                                      16,
                                      (i) => (2010 + i).toString(),
                                    ),
                                    icon: null,
                                    onChanged: (v) => setState(() => tahun = v),
                                    validator: (v) =>
                                        v == null ? "Pilih tahun" : null,
                                  ),
                                  SizedBox(height: 20.h),

                                  // Kilometer — floating label + icon
                                  TextFormField(
                                    controller: kilometer,
                                    keyboardType: TextInputType.number,
                                    decoration: _input(
                                      "Kilometer (opsional)",
                                      icon: Icons.speed_rounded,
                                    ),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return null;
                                      if (int.tryParse(v) == null) {
                                        return "Masukkan angka valid";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 30.h),

                                  // Button Simpan
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50.h,
                                    child: ElevatedButton(
                                      onPressed: loading ? null : simpanData,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFDB0C0C,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                      ),
                                      child: loading
                                          ? const CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            )
                                          : const Text(
                                              "Simpan Data",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
