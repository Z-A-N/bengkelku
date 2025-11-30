import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/bengkel_model.dart';
import 'booking_success.dart';

/// 1 item layanan yang dipilih user
class LayananItem {
  final String id;
  final String nama;
  final int harga;

  LayananItem({required this.id, required this.nama, required this.harga});
}

class BookingSummaryPage extends StatefulWidget {
  final Bengkel bengkel;

  /// list layanan yang dikirim dari halaman detail
  final List<LayananItem> layananDipilih;

  const BookingSummaryPage({
    super.key,
    required this.bengkel,
    required this.layananDipilih,
  });

  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  late final List<DateTime> _tanggalOptions;
  late DateTime _selectedTanggal;
  String? _selectedJam;

  final _jenisKendaraanC = TextEditingController();
  final _nomorPolisiC = TextEditingController();
  final _catatanC = TextEditingController();

  String? _metodePembayaran = "Bayar Ditempat";
  bool _isSaving = false;

  /// list layanan yang akan dimodifikasi (tambah/hapus) di halaman ini
  late List<LayananItem> _layananDipilih;

  final List<String> _timeSlots = const [
    "Kurang dari 30 Menit",
    "09:00 - 11:00",
    "11:00 - 13:00",
    "13:00 - 15:00",
    "15:00 - 17:00",
    "17:00 - 19:00",
    "19:00 - 21:00",
  ];

  @override
  void initState() {
    super.initState();

    // copy list dari widget agar bisa dimodifikasi
    _layananDipilih = List<LayananItem>.from(widget.layananDipilih);

    final now = DateTime.now();
    _tanggalOptions = List.generate(
      5,
      (i) => DateTime(now.year, now.month, now.day).add(Duration(days: i)),
    );
    _selectedTanggal = _tanggalOptions.first;
  }

  @override
  void dispose() {
    _jenisKendaraanC.dispose();
    _nomorPolisiC.dispose();
    _catatanC.dispose();
    super.dispose();
  }

  // =====================================================
  //  SIMPAN BOOKING KE FIRESTORE
  // =====================================================

  Future<void> _saveBooking() async {
    if (_selectedJam == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih jam kunjungan dulu ya")),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Kamu harus login dulu")));
      return;
    }

    setState(() => _isSaving = true);

    try {
      await FirebaseFirestore.instance.collection('bookings').add({
        "userId": user.uid,
        "bengkelId": widget.bengkel.id,
        "bengkelNama": widget.bengkel.nama,
        "bengkelAlamat": widget.bengkel.alamat,
        "layanan": _layananDipilih
            .map((e) => {"id": e.id, "nama": e.nama, "harga": e.harga})
            .toList(),
        "tanggal": Timestamp.fromDate(_selectedTanggal),
        "jam": _selectedJam,
        "jenisKendaraan": _jenisKendaraanC.text.trim(),
        "nomorPolisi": _nomorPolisiC.text.trim(),
        "catatan": _catatanC.text.trim(),
        "metodePembayaran": _metodePembayaran,
        "status": "menunggu",
        "createdAt": FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      // NAVIGASI KE HALAMAN BERHASIL (slide dari bawah)
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => BookingSuccessPage(
            bengkel: widget.bengkel,
            layananDipilih: List<LayananItem>.from(_layananDipilih),
            tanggal: _selectedTanggal,
            jam: _selectedJam!,
            jenisKendaraan: _jenisKendaraanC.text.trim(),
            nomorPolisi: _nomorPolisiC.text.trim(),
            catatan: _catatanC.text.trim(),
            metodePembayaran: _metodePembayaran ?? "Bayar Ditempat",
          ),
          transitionsBuilder: (_, animation, __, child) {
            final offsetAnim =
                Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                );
            return SlideTransition(position: offsetAnim, child: child);
          },
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal menyimpan booking: $e")));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // =====================================================
  //  BUILD UI
  // =====================================================

  @override
  Widget build(BuildContext context) {
    final total = _layananDipilih.fold<int>(0, (sum, item) => sum + item.harga);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD740),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Ringkasan Booking",
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 120.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBengkelCard(),
                  SizedBox(height: 16.h),
                  _buildTanggalSection(),
                  SizedBox(height: 16.h),
                  _buildJamSection(),
                  SizedBox(height: 16.h),
                  _buildLayananDipilihSection(),
                  SizedBox(height: 16.h),
                  _buildInformasiKendaraanSection(),
                  SizedBox(height: 16.h),
                  _buildMetodePembayaranSection(),
                ],
              ),
            ),

            // bottom action
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  16.w,
                  8.h,
                  16.w,
                  12.h + MediaQuery.of(context).padding.bottom,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTotalAndConfirmButton(total),
                    SizedBox(height: 8.h),
                    TextButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.pop(context),
                      child: const Text(
                        "Batalkan",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_isSaving)
              Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  // ---------------- BENGKEL CARD ----------------

  Widget _buildBengkelCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              width: 70.w,
              height: 70.w,
              color: Colors.grey.shade200,
              child: const Icon(Icons.car_repair, color: Colors.grey, size: 32),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.bengkel.nama,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.orange,
                      size: 16,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      widget.bengkel.rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "(324 ulasan)",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        widget.bengkel.alamat,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              widget.bengkel.buka ? "Buka sekarang" : "Tutup",
              style: TextStyle(
                color: widget.bengkel.buka
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFFB71C1C),
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- TANGGAL KUNJUNGAN ----------------

  Widget _buildTanggalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pilih Tanggal Kunjungan",
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 80.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _tanggalOptions.length,
            separatorBuilder: (_, __) => SizedBox(width: 8.w),
            itemBuilder: (_, index) {
              final date = _tanggalOptions[index];
              final isSelected = date == _selectedTanggal;

              final hari = _namaHari(date.weekday);
              final tanggal = date.day.toString().padLeft(2, '0');
              final bulan = _namaBulanPendek(date.month);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTanggal = date;
                  });
                },
                child: Container(
                  width: 60.w,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFFD740) : Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFFFC107)
                          : Colors.grey.shade300,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        hari,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: isSelected ? Colors.black : Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        tanggal,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.black : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        bulan,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: isSelected ? Colors.black : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _namaHari(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return "Sen";
      case DateTime.tuesday:
        return "Sel";
      case DateTime.wednesday:
        return "Rab";
      case DateTime.thursday:
        return "Kam";
      case DateTime.friday:
        return "Jum";
      case DateTime.saturday:
        return "Sab";
      case DateTime.sunday:
        return "Min";
      default:
        return "";
    }
  }

  String _namaBulanPendek(int month) {
    const names = [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "Mei",
      "Jun",
      "Jul",
      "Agu",
      "Sep",
      "Okt",
      "Nov",
      "Des",
    ];
    return names[month];
  }

  // ---------------- JAM KUNJUNGAN ----------------

  Widget _buildJamSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pilih Jam Kunjungan",
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: _timeSlots.map((slot) {
              final selected = _selectedJam == slot;
              return Column(
                children: [
                  ListTile(
                    dense: true,
                    title: Text(slot, style: TextStyle(fontSize: 13.sp)),
                    trailing: Radio<String>(
                      value: slot,
                      groupValue: _selectedJam,
                      onChanged: (v) {
                        setState(() => _selectedJam = v);
                      },
                      activeColor: const Color(0xFFDB0C0C),
                    ),
                    onTap: () {
                      setState(() => _selectedJam = slot);
                    },
                  ),
                  if (slot != _timeSlots.last)
                    Divider(height: 1, color: Colors.grey.shade200),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ---------------- LAYANAN DIPILIH ----------------

  Widget _buildLayananDipilihSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Layanan Dipilih",
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.h),
        if (_layananDipilih.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              "Belum ada layanan. Silakan kembali dan pilih layanan.",
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
            ),
          )
        else
          Column(
            children: [
              ..._layananDipilih.map((item) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.nama,
                          style: TextStyle(fontSize: 13.sp),
                        ),
                      ),
                      Text(
                        "Rp ${item.harga}",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFDB0C0C),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _layananDipilih.remove(item);
                          });
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              TextButton(
                onPressed: () {
                  // KIRIM BALIK list layanan terbaru ke _LayananTab
                  Navigator.pop(context, _layananDipilih);
                },
                child: const Text("Tambah layanan lain"),
              ),
            ],
          ),
      ],
    );
  }

  // ---------------- INFORMASI KENDARAAN ----------------

  Widget _buildInformasiKendaraanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Informasi Kendaraan",
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.h),
        _buildTextField(
          label: "Jenis Kendaraan",
          hint: "Honda Beat",
          controller: _jenisKendaraanC,
        ),
        SizedBox(height: 8.h),
        _buildTextField(
          label: "Nomor polisi (opsional)",
          hint: "R 1234 XX",
          controller: _nomorPolisiC,
        ),
        SizedBox(height: 8.h),
        _buildTextField(
          label: "Catatan (opsional)",
          hint: "Mesin agak kasar",
          controller: _catatanC,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[800]),
        ),
        SizedBox(height: 4.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 10.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Color(0xFFFFD740)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Color(0xFFFFD740)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(
                color: Color(0xFFDB0C0C),
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- METODE PEMBAYARAN ----------------

  Widget _buildMetodePembayaranSection() {
    final methods = ["Bayar Ditempat", "Transfer Bank", "E-Wallet"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Metode Pembayaran",
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.h),
        Column(
          children: methods.map((m) {
            final selected = _metodePembayaran == m;
            return Container(
              margin: EdgeInsets.only(bottom: 8.h),
              child: InkWell(
                onTap: () {
                  setState(() => _metodePembayaran = m);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: const Color(0xFFFFD740),
                      width: selected ? 1.6 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.home_outlined, size: 18),
                      SizedBox(width: 8.w),
                      Text(
                        m,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      if (selected)
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFFDB0C0C),
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ---------------- TOTAL & KONFIRMASI ----------------

  Widget _buildTotalAndConfirmButton(int total) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total Pembayaran",
              style: TextStyle(fontWeight: FontWeight.w600),
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
        SizedBox(height: 8.h),
        SizedBox(
          width: double.infinity,
          height: 44.h,
          child: ElevatedButton(
            onPressed: _isSaving ? null : _saveBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD740),
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
            child: Text(
              _isSaving ? "Menyimpan..." : "Konfirmasi Booking",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.sp),
            ),
          ),
        ),
      ],
    );
  }
}
