// lib/screen/booking/booking_success.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:confetti/confetti.dart';

import '../../models/bengkel_model.dart';
import 'booking_summary.dart'; // buat akses LayananItem

class BookingSuccessPage extends StatefulWidget {
  final Bengkel bengkel;
  final List<LayananItem> layananDipilih;
  final DateTime tanggal;
  final String jam;
  final String jenisKendaraan;
  final String nomorPolisi;
  final String catatan;
  final String metodePembayaran;

  const BookingSuccessPage({
    super.key,
    required this.bengkel,
    required this.layananDipilih,
    required this.tanggal,
    required this.jam,
    required this.jenisKendaraan,
    required this.nomorPolisi,
    required this.catatan,
    required this.metodePembayaran,
  });

  @override
  State<BookingSuccessPage> createState() => _BookingSuccessPageState();
}

class _BookingSuccessPageState extends State<BookingSuccessPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _checkController;
  late final Animation<double> _checkScale;
  late final ConfettiController _confetti;

  @override
  void initState() {
    super.initState();

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _checkScale = CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    );

    _confetti = ConfettiController(duration: const Duration(seconds: 2));

    // jalanin animasi begitu halaman muncul
    _checkController.forward();
    _confetti.play();
  }

  @override
  void dispose() {
    _checkController.dispose();
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.layananDipilih.fold<num>(0, (p, e) => p + e.harga);

    return Scaffold(
      backgroundColor: const Color(0xFFFF3366),
      body: SafeArea(
        child: Stack(
          children: [
            // HEADER MERAH + ANIMASI
            _buildHeader(),

            // KARTU PUTIH DARI BAWAH
            Align(
              alignment: Alignment.bottomCenter,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 1.0, end: 0.0),
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(
                      0,
                      value * MediaQuery.of(context).size.height,
                    ),
                    child: child,
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(top: 250.h),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.78,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBengkelCard(),
                        SizedBox(height: 16.h),
                        _buildTanggalWaktuSection(),
                        SizedBox(height: 16.h),
                        _buildLayananSection(total),
                        SizedBox(height: 16.h),
                        _buildStatusSection(),
                        SizedBox(height: 16.h),
                        _buildInfoKendaraanSection(),
                        SizedBox(height: 16.h),
                        _buildMetodePembayaranSection(),
                        SizedBox(height: 24.h),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // balik ke home (clear stack)
                                Navigator.of(
                                  context,
                                ).popUntil((route) => route.isFirst);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFD740),
                                foregroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.r),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                              ),
                              child: Text(
                                "Kembali ke Beranda",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
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

  // ================= HEADER MERAH =================

  Widget _buildHeader() {
    return SizedBox(
      height: 230.h,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // background merah
          Container(color: const Color(0xFFFF3366)),

          // confetti
          ConfettiWidget(
            confettiController: _confetti,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            numberOfParticles: 20,
            maxBlastForce: 20,
            minBlastForce: 8,
            emissionFrequency: 0.01,
          ),

          // ceklis
          ScaleTransition(
            scale: _checkScale,
            child: Container(
              width: 90.w,
              height: 90.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.green,
                size: 52,
              ),
            ),
          ),

          // teks
          Positioned(
            bottom: 32.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  "Booking Berhasil!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Pesanan kamu sudah diterima oleh bengkel.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    "Dijadwalkan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================== CARD BENGKEL ==================

  Widget _buildBengkelCard() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              width: 64.w,
              height: 64.w,
              color: Colors.grey.shade200,
              child: const Icon(Icons.car_repair, color: Colors.grey),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.bengkel.nama,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "#BK12345",
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[700]),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "0,2 km dari kamu", // placeholder
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================== TANGGAL & WAKTU ==================

  Widget _buildTanggalWaktuSection() {
    final tanggalStr =
        "${widget.tanggal.day} ${_namaBulan(widget.tanggal.month)} ${widget.tanggal.year}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Tanggal & Waktu"),
        SizedBox(height: 8.h),
        _iconRow(
          icon: Icons.calendar_today_outlined,
          label: "Tanggal",
          value: tanggalStr,
        ),
        SizedBox(height: 8.h),
        _iconRow(icon: Icons.access_time, label: "Waktu", value: widget.jam),
      ],
    );
  }

  Widget _iconRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3CD),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFFFF9800)),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11.sp, color: Colors.grey[700]),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================== LAYANAN DIPILIH ==================

  Widget _buildLayananSection(num total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Layanan Dipilih"),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              for (final l in widget.layananDipilih) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(l.nama, style: TextStyle(fontSize: 13.sp)),
                    ),
                    Text(
                      "Rp ${l.harga}",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (l != widget.layananDipilih.last)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    child: Divider(height: 1, color: Colors.grey.shade200),
                  ),
              ],
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Biaya",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "Rp $total",
                    style: const TextStyle(
                      color: Color(0xFFDB0C0C),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================== STATUS BOOKING ==================

  Widget _buildStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Status Booking"),
        SizedBox(height: 8.h),
        _statusRow(
          icon: Icons.check_circle,
          color: const Color(0xFF4CAF50),
          title: "Booking Diterima",
          time: "10:15 WIB",
          isDone: true,
        ),
        _statusRow(
          icon: Icons.timelapse,
          color: const Color(0xFFFFC107),
          title: "Proses",
          time: "Menunggu jadwal",
          isDone: false,
        ),
      ],
    );
  }

  Widget _statusRow({
    required IconData icon,
    required Color color,
    required String title,
    required String time,
    required bool isDone,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: isDone ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  time,
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================== INFO KENDARAAN ==================

  Widget _buildInfoKendaraanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Informasi Kendaraan"),
        SizedBox(height: 8.h),
        _infoRow("Jenis Kendaraan", widget.jenisKendaraan),
        _infoRow(
          "Nomor Polisi",
          widget.nomorPolisi.isEmpty ? "-" : widget.nomorPolisi,
        ),
        _infoRow("Catatan", widget.catatan.isEmpty ? "-" : widget.catatan),
      ],
    );
  }

  // ================== METODE PEMBAYARAN ==================

  Widget _buildMetodePembayaranSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Metode Pembayaran"),
        SizedBox(height: 8.h),
        _infoRow("Metode", widget.metodePembayaran),
        _infoRow("Status Pembayaran", "Belum dibayar"),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
    );
  }

  String _namaBulan(int m) {
    const list = [
      "",
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];
    return list[m];
  }
}
