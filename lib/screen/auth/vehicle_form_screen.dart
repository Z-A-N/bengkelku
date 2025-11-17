// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VehicleFormScreen extends StatefulWidget {
  const VehicleFormScreen({super.key});

  @override
  State<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends State<VehicleFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomorPolisi = TextEditingController();
  final TextEditingController merek = TextEditingController();
  final TextEditingController model = TextEditingController();
  final TextEditingController tahun = TextEditingController();
  final TextEditingController tipe = TextEditingController();
  final TextEditingController warna = TextEditingController();
  final TextEditingController kilometer = TextEditingController();

  String jenisKendaraan = "Motor";
  String transmisi = "Manual";
  String bahanBakar = "Bensin";

  bool loading = false;

  Future<void> simpanData() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => loading = true);

    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("vehicle")
        .doc("main")
        .set({
      "jenis": jenisKendaraan,
      "nomorPolisi": nomorPolisi.text.trim(),
      "merek": merek.text.trim(),
      "model": model.text.trim(),
      "tahun": tahun.text.trim(),
      "tipe": tipe.text.trim(),
      "warna": warna.text.trim(),
      "transmisi": transmisi,
      "bahanBakar": bahanBakar,
      "km": kilometer.text.trim(),
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Data kendaraan berhasil disimpan!")),
    );

    Navigator.pop(context); // kembali ke login → login redirect ke dashboard
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Kendaraan"),
        backgroundColor: const Color(0xFFDB0C0C),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField(
                value: jenisKendaraan,
                decoration: const InputDecoration(labelText: "Jenis Kendaraan"),
                items: const [
                  DropdownMenuItem(value: "Motor", child: Text("Motor")),
                  DropdownMenuItem(value: "Mobil", child: Text("Mobil")),
                ],
                onChanged: (v) => setState(() => jenisKendaraan = v!),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: nomorPolisi,
                decoration: const InputDecoration(labelText: "Nomor Polisi"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: merek,
                decoration: const InputDecoration(labelText: "Merek"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: model,
                decoration: const InputDecoration(labelText: "Model"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: tahun,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Tahun Pembuatan"),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: tipe,
                decoration: const InputDecoration(labelText: "Tipe / Varian"),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: warna,
                decoration: const InputDecoration(labelText: "Warna Kendaraan"),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField(
                value: transmisi,
                decoration: const InputDecoration(labelText: "Transmisi"),
                items: const [
                  DropdownMenuItem(value: "Manual", child: Text("Manual")),
                  DropdownMenuItem(value: "Matic", child: Text("Matic")),
                ],
                onChanged: (v) => setState(() => transmisi = v!),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField(
                value: bahanBakar,
                decoration: const InputDecoration(labelText: "Bahan Bakar"),
                items: const [
                  DropdownMenuItem(value: "Bensin", child: Text("Bensin")),
                  DropdownMenuItem(value: "Diesel", child: Text("Diesel")),
                  DropdownMenuItem(value: "Listrik", child: Text("Listrik")),
                ],
                onChanged: (v) => setState(() => bahanBakar = v!),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: kilometer,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: "Kilometer Terakhir"),
              ),
              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: loading ? null : simpanData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDB0C0C),
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Simpan Data"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
