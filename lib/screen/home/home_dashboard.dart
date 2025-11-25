import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../bengkel/bengkel_detail.dart';
import '../profile/profile.dart';
import '../../widgets/navbar.dart';
import '../chat/chat.dart';
import '../riwayat/riwayat.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 0;

  User? get _user => FirebaseAuth.instance.currentUser;

  String get _displayName {
    final name = _user?.displayName;
    if (name != null && name.trim().isNotEmpty) return name;
    final email = _user?.email ?? "";
    if (email.contains("@")) return email.split("@").first;
    return "Pengguna";
  }

  String get _initials {
    final parts = _displayName.trim().split(" ");
    if (parts.length == 1) {
      return parts.first.isNotEmpty ? parts.first[0].toUpperCase() : "U";
    }
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  // buka halaman detail bengkel
  void _openBengkelDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BengkelDetailPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeTab(context),
            _buildRiwayatTab(),
            _buildChatTab(),
            _buildAkunTab(),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }

  // =====================================================
  //                     TAB BERANDA
  // =====================================================

  Widget _buildHomeTab(BuildContext context) {
    const double _mapHeightFactor = 160;

    return SingleChildScrollView(
      child: Stack(
        children: [
          _buildYellowHeader(),

          Positioned(
            top: 75.h,
            left: 16.w,
            right: 16.w,
            child: _buildSearchBar(),
          ),

          Positioned(
            top: 140.h,
            left: 16.w,
            right: 16.w,
            child: _buildMapCard(),
          ),

          Padding(
            padding: EdgeInsets.only(
              top: (145 + _mapHeightFactor + 24).h,
              bottom: 16.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Aksi cepat
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _buildMenuGrid(),
                ),

                SizedBox(height: 16.h),

                // Kartu XP / EXP
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _buildXpCard(),
                ),

                SizedBox(height: 16.h),

                // Judul promo
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    "Ada promo menarik buat kamu nih ~",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                // List promo dengan gambar
                SizedBox(
                  height: 230.h,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    separatorBuilder: (_, __) => SizedBox(width: 12.w),
                    itemBuilder: (_, __) => _buildPromoCard(),
                  ),
                ),

                SizedBox(height: 16.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    "Rekomendasi buat kamu ~",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _buildRecommendationRow(),
                ),

                SizedBox(height: 16.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _buildRecommendationList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  //                    HEADER KUNING
  // =====================================================

  Widget _buildYellowHeader() {
    return Container(
      height: 210.h, // tinggi kuning tetap
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFFFD740),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      // geser isi header naik sedikit
      child: Transform.translate(
        offset: Offset(0, -73.h),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: Colors.white,
                child: Text(
                  _initials,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    color: const Color(0xFFDB0C0C),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Halo", style: TextStyle(fontSize: 13.sp)),
                  Text(
                    _displayName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.notifications_none),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  //                     SEARCH BAR
  // =====================================================

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[600]),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Cari",
                hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            ),
          ),
          Icon(Icons.tune_rounded, color: Colors.grey[600]),
        ],
      ),
    );
  }

  // =====================================================
  //                        MAP CARD
  // =====================================================

  Widget _buildMapCard() {
    return Container(
      height: 160.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: Icon(Icons.map_rounded, size: 70, color: Colors.grey),
            ),
          ),
          Positioned(
            right: 12.w,
            bottom: 12.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                "8 Bengkel Terdekat",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  //                AKSI CEPAT (VERSI LEBIH KECIL)
  // =====================================================

  Widget _buildMenuGrid() {
    final items = [
      _QuickAction(
        "Service Rutin",
        Icons.build_rounded,
        const Color(0xFF2F80ED),
      ),
      _QuickAction(
        "Cari Bengkel",
        Icons.search_rounded,
        const Color(0xFF27AE60),
      ),
      _QuickAction(
        "Voucher",
        Icons.local_offer_outlined,
        const Color(0xFFF2994A),
      ),
      _QuickAction("Favorit", Icons.favorite_border, const Color(0xFF9B51E0)),
      _QuickAction("Booking", Icons.event_available, const Color(0xFF27AE60)),
      _QuickAction(
        "Darurat",
        Icons.phone_in_talk_outlined,
        const Color(0xFFEB5757),
      ),
      _QuickAction(
        "Rekomendasi",
        Icons.thumb_up_alt_outlined,
        const Color(0xFFF2C94C),
      ),
      _QuickAction("Lainnya", Icons.more_horiz, Colors.grey),
    ];

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: GridView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 6,
          mainAxisExtent: 80,
        ),
        itemBuilder: (_, index) {
          final item = items[index];
          return Column(
            children: [
              Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(item.icon, size: 22.sp, color: item.color),
              ),
              SizedBox(height: 4.h),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10.sp, color: Colors.black87),
              ),
            ],
          );
        },
      ),
    );
  }

  // =====================================================
  //                      KARTU XP / EXP
  // =====================================================

  Widget _buildXpCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Center(
              child: Text("😎", style: TextStyle(fontSize: 26.sp)),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "117 XP lagi ada Harta Karun",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: LinearProgressIndicator(
                    value: 0.6, // progress contoh
                    minHeight: 6.h,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation(Color(0xFFDB0C0C)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Icon(Icons.chevron_right, color: Colors.grey[600]),
        ],
      ),
    );
  }

  // =====================================================
  //                         PROMO (DENGAN GAMBAR)
  // =====================================================

  Widget _buildPromoCard() {
    return Container(
      width: 260.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner gambar promo
            SizedBox(
              height: 110.h,
              width: double.infinity,
              child: Image.asset(
                'assets/promo_banner.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // fallback kalau asset belum ada
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1976D2), Color(0xFF64B5F6)],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Banner Promo",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Teks di bawah gambar
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ada Promo Spesial!",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Diskon hingga 30% untuk servis rutin di bengkel pilihan.",
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey[800]),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Text(
                      "Lihat Detail",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  //                REKOMENDASI (ATAS & LIST)
  // =====================================================

  Widget _buildRecommendationRow() {
    return Row(
      children: [
        Expanded(
          child: _buildWorkshopCard(compact: true, onTap: _openBengkelDetail),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildWorkshopCard(compact: true, onTap: _openBengkelDetail),
        ),
      ],
    );
  }

  Widget _buildRecommendationList() {
    return Column(
      children: [
        _buildWorkshopCard(onTap: _openBengkelDetail),
        SizedBox(height: 12.h),
        _buildWorkshopCard(onTap: _openBengkelDetail),
      ],
    );
  }

  Widget _buildWorkshopCard({bool compact = false, VoidCallback? onTap}) {
    final card = Container(
      height: compact ? 210.h : 110.h,
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
      clipBehavior: Clip.antiAlias,
      child: compact
          ? Column(
              children: [
                _buildWorkshopImage(height: 110.h),
                Padding(
                  padding: EdgeInsets.all(10.w),
                  child: _buildWorkshopInfo(),
                ),
              ],
            )
          : Row(
              children: [
                _buildWorkshopImage(width: 110.w),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: _buildWorkshopInfo(withTag: true),
                  ),
                ),
              ],
            ),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, child: card),
    );
  }

  Widget _buildWorkshopImage({double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: const Icon(Icons.car_repair, size: 40, color: Colors.grey),
    );
  }

  Widget _buildWorkshopInfo({bool withTag = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "5.8 km",
          style: TextStyle(fontSize: 11.sp, color: Colors.grey),
        ),
        SizedBox(height: 2.h),
        Text(
          "Bengkel Watanabe Karangsalam",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Colors.orange, size: 16),
            SizedBox(width: 4.w),
            Text(
              "4.8 • 300+ rating",
              style: TextStyle(fontSize: 11.sp, color: Colors.grey),
            ),
          ],
        ),
        if (withTag) ...[
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tambal Ban", style: TextStyle(fontSize: 11.sp)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  "Buka",
                  style: TextStyle(
                    color: const Color(0xFF2E7D32),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // =====================================================
  //              TAB RIWAYAT, CHAT, AKUN
  // =====================================================

  Widget _buildRiwayatTab() {
    return const RiwayatTab();
  }

  Widget _buildChatTab() {
    return const ChatTab();
  }

  Widget _buildAkunTab() {
    return ProfileTab(
      name: _displayName,
      email: _user?.email ?? "-",
      phone: null, // nanti bisa diisi dari Firestore
      onLogout: () {
        // TODO: isi signOut kalau mau
      },
    );
  }
}

class _QuickAction {
  final String label;
  final IconData icon;
  final Color color;
  const _QuickAction(this.label, this.icon, this.color);
}
