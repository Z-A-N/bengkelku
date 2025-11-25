import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BengkelDetailPage extends StatelessWidget {
  const BengkelDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: const _BottomActionBar(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(child: const _HeaderImage()),
              SliverToBoxAdapter(child: const _BengkelSummary()),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    indicatorColor: const Color(0xFFFFD740),
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.black54,
                    indicatorWeight: 3,
                    labelStyle: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: const [
                      Tab(text: "Info"),
                      Tab(text: "Layanan"),
                      Tab(text: "Ulasan"),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: const TabBarView(
            children: [_InfoTab(), _LayananTab(), _UlasanTab()],
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////
/// HEADER FOTO + ICON
///////////////////////////////////////////////////////////////////////////

class _HeaderImage extends StatelessWidget {
  const _HeaderImage();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230.h,
      width: double.infinity,
      child: Stack(
        children: [
          // FOTO
          Positioned.fill(
            child: Image.asset(
              'assets/workshop_sample.jpg', // TODO: ganti image kamu
              fit: BoxFit.cover,
            ),
          ),

          // LAYER GRADIENT
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0),
                      Colors.black.withOpacity(0.25),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _RoundIconButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                  _RoundIconButton(icon: Icons.favorite_border, onTap: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Icon(icon, size: 20.sp, color: Colors.black87),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////
/// RINGKASAN BENGKEL
///////////////////////////////////////////////////////////////////////////

class _BengkelSummary extends StatelessWidget {
  const _BengkelSummary();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bengkel Terus Jaya",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8.h),

          Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.orange, size: 18),
              SizedBox(width: 4.w),
              Text(
                "4.9",
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.grey[700],
              ),
              SizedBox(width: 4.w),
              Text(
                "0.2 km",
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(16.r),
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

          SizedBox(height: 6.h),
          Text(
            "Tambal ban, service motor, ganti oli",
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////
/// TAB INFO
///////////////////////////////////////////////////////////////////////////

class _InfoTab extends StatelessWidget {
  const _InfoTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.place_outlined, size: 22),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                "Jl. MT Haryono No 123, Karangsentul, Padamara, Purbalingga",
                style: TextStyle(fontSize: 13.sp),
              ),
            ),
          ],
        ),

        SizedBox(height: 20.h),

        SizedBox(
          width: double.infinity,
          height: 44.h,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFDB0C0C), width: 1.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              "Lihat di Peta",
              style: TextStyle(
                color: const Color(0xFFDB0C0C),
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
              ),
            ),
          ),
        ),

        SizedBox(height: 26.h),
        Text(
          "Jam Operasional",
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
        ),

        SizedBox(height: 12.h),
        _InfoDay(label: "Senin - Jumat", time: "08:00 - 16:00"),
        _InfoDay(label: "Sabtu", time: "08:00 - 16:00"),
        _InfoDay(label: "Minggu", time: "08:00 - 16:00"),

        SizedBox(height: 26.h),
        Text(
          "Kontak",
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 12.h),

        Row(
          children: [
            const Icon(Icons.phone_outlined, size: 20),
            SizedBox(width: 8.w),
            Text("+62 856-0177-8422", style: TextStyle(fontSize: 13.sp)),
            const Spacer(),
            Text(
              "Hubungi",
              style: TextStyle(
                color: const Color(0xFFDB0C0C),
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoDay extends StatelessWidget {
  final String label;
  final String time;

  const _InfoDay({required this.label, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(fontSize: 13.sp)),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////
/// TAB LAYANAN
///////////////////////////////////////////////////////////////////////////

class _LayananTab extends StatelessWidget {
  const _LayananTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
      children: [
        Text(
          "Perawatan Motor",
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 10.h),
        _ServiceItem(
          title: "Tambal Ban",
          subtitle: "Termasuk oli berkualitas dan filter oli",
          price: "Rp. 15.000",
          buttonText: "Pesan",
        ),
        SizedBox(height: 10.h),
        _ServiceItem(
          title: "Ganti Oli",
          subtitle: "Oli pilihan untuk motor harian",
          price: "Rp. 60.000",
          buttonText: "Pesan",
        ),

        SizedBox(height: 26.h),
        Text(
          "Service Ringan",
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
        ),

        SizedBox(height: 10.h),
        _ServiceItem(
          filled: true,
          title: "Servis Rutin",
          subtitle: "Cek kondisi motor & tune up ringan",
          price: "Rp. 120.000",
          buttonText: "Tambah",
        ),
        SizedBox(height: 10.h),
        _ServiceItem(
          filled: true,
          title: "Cek Rem & Kampas",
          subtitle: "Pengecekan sistem pengereman",
          price: "Rp. 45.000",
          buttonText: "Tambah",
        ),
      ],
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String buttonText;
  final bool filled;

  const _ServiceItem({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.buttonText,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
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
          // GAMBAR PRODUK
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.asset(
              "assets/service_sample.jpg",
              width: 80.w,
              height: 70.h,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: 10.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[700]),
                ),
                SizedBox(height: 6.h),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFDB0C0C),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // BUTTON PESAN / TAMBAH
          SizedBox(
            height: 34.h,
            child: filled
                ? ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD740),
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                : OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFFDB0C0C),
                        width: 1.4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        color: const Color(0xFFDB0C0C),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////
/// TAB ULASAN
///////////////////////////////////////////////////////////////////////////

class _UlasanTab extends StatelessWidget {
  const _UlasanTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
      children: [
        const _RatingSummary(),
        SizedBox(height: 20.h),
        _ReviewCard(
          name: "Courtney Henry",
          rating: 5,
          timeAgo: "2 mins ago",
          text:
              "Consequat velit qui adipisicing sint do reprehenderit ad laborum tempor ullamco exercitation.",
        ),
        const Divider(height: 30),
        _ReviewCard(
          name: "Courtney Henry",
          rating: 4,
          timeAgo: "10 mins ago",
          text: "Ullamco tempor adipisicing et voluptate duis sit esse aliqua.",
        ),
        const Divider(height: 30),
        _ReviewCard(
          name: "Courtney Henry",
          rating: 4,
          timeAgo: "1 hour ago",
          text: "Consequat velit qui adipisicing sint.",
        ),
      ],
    );
  }
}

class _RatingSummary extends StatelessWidget {
  const _RatingSummary();

  @override
  Widget build(BuildContext context) {
    Widget bar(double v) {
      return LinearProgressIndicator(
        value: v,
        minHeight: 5.h,
        backgroundColor: Colors.grey.shade200,
        valueColor: const AlwaysStoppedAnimation(Color(0xFF00796B)),
      );
    }

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _RatingRow(label: "5", bar: bar(0.9)),
                SizedBox(height: 4.h),
                _RatingRow(label: "4", bar: bar(0.6)),
                SizedBox(height: 4.h),
                _RatingRow(label: "3", bar: bar(0.3)),
                SizedBox(height: 4.h),
                _RatingRow(label: "2", bar: bar(0.1)),
                SizedBox(height: 4.h),
                _RatingRow(label: "1", bar: bar(0.05)),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "4.0",
                style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 6.h),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: i < 4 ? Colors.orange : Colors.grey[300],
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                "52 Reviews",
                style: TextStyle(fontSize: 11.sp, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  final String label;
  final Widget bar;
  const _RatingRow({required this.label, required this.bar});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 11.sp)),
        SizedBox(width: 4.w),
        const Icon(Icons.star_rounded, size: 12, color: Colors.orange),
        SizedBox(width: 6.w),
        Expanded(child: bar),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String name;
  final int rating;
  final String timeAgo;
  final String text;

  const _ReviewCard({
    required this.name,
    required this.rating,
    required this.timeAgo,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage("assets/avatar_sample.jpg"),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: i < rating
                                ? Colors.orange
                                : Colors.grey[300],
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        timeAgo,
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
            Icon(Icons.more_vert, color: Colors.grey[700]),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          text,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[800]),
        ),
      ],
    );
  }
}

///////////////////////////////////////////////////////////////////////////
/// BOTTOM BUTTON
///////////////////////////////////////////////////////////////////////////

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar();

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFDB0C0C), width: 1.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.chat_bubble_outline,
                    size: 18,
                    color: Color(0xFFDB0C0C),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    "Chat Bengkel",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFDB0C0C),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 10.w),

          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD740),
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.h),
              ),
              child: Text(
                "Booking Sekarang",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////
/// SLIVER TABBAR
///////////////////////////////////////////////////////////////////////////

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}
