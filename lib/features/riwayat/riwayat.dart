// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RiwayatTab extends StatefulWidget {
  const RiwayatTab({super.key});

  @override
  State<RiwayatTab> createState() => _RiwayatTabState();
}

class _RiwayatTabState extends State<RiwayatTab> {
  // 0 = Semua, 1 = Proses, 2 = Selesai, 3 = Batal
  int _selectedFilter = 0;

  final List<_OrderItem> _orders = [
    _OrderItem(
      customerName: 'Arion Regasta',
      vehicle: 'Yamaha NMAX • B 1234 X',
      service: 'Servis Rutin dan Ganti Ban',
      date: '2 Nov 2025',
      time: '10:00 WIB',
      status: OrderStatus.pending,
    ),
    _OrderItem(
      customerName: 'Arion Regasta',
      vehicle: 'Honda Vario • B 5678 XY',
      service: 'Ganti Oli Mesin',
      date: '10 Nov 2025',
      time: '14:30 WIB',
      status: OrderStatus.process,
    ),
    _OrderItem(
      customerName: 'Arion Regasta',
      vehicle: 'Yamaha NMAX • B 1234 X',
      service: 'Servis Ringan',
      date: '20 Okt 2025',
      time: '09:00 WIB',
      status: OrderStatus.done,
    ),
    _OrderItem(
      customerName: 'Arion Regasta',
      vehicle: 'Honda Beat • B 9999 ZZ',
      service: 'Tambal Ban',
      date: '5 Okt 2025',
      time: '19:00 WIB',
      status: OrderStatus.cancelled,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // filter sesuai tab di atas
    final filtered = _orders.where((o) {
      if (_selectedFilter == 0) return true; // Semua
      if (_selectedFilter == 1) {
        return o.status == OrderStatus.process ||
            o.status == OrderStatus.pending;
      }
      if (_selectedFilter == 2) return o.status == OrderStatus.done;
      if (_selectedFilter == 3) return o.status == OrderStatus.cancelled;
      return true;
    }).toList();

    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),

            // Title
            Center(
              child: Text(
                'Riwayat Pemesanan',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
            ),

            SizedBox(height: 12.h),

            // TAB FILTER: Semua / Proses / Selesai / Batal
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  _buildFilterChip(0, 'Semua'),
                  _buildFilterChip(1, 'Proses'),
                  _buildFilterChip(2, 'Selesai'),
                  _buildFilterChip(3, 'Batal'),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // LIST RIWAYAT
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  return _OrderCard(item: item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(int index, String label) {
    final bool isActive = _selectedFilter == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedFilter = index);
        },
        child: Container(
          height: 40.h,
          margin: EdgeInsets.only(right: index == 3 ? 0 : 8.w),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFFFD740) : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isActive
                  ? const Color(0xFFFFD740)
                  : const Color(0xFFE0E0E0),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.black87 : Colors.grey[700],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===== MODEL DATA =====

enum OrderStatus { pending, process, done, cancelled }

class _OrderItem {
  final String customerName;
  final String vehicle;
  final String service;
  final String date;
  final String time;
  final OrderStatus status;

  _OrderItem({
    required this.customerName,
    required this.vehicle,
    required this.service,
    required this.date,
    required this.time,
    required this.status,
  });
}

// ===== KARTU RIWAYAT =====

class _OrderCard extends StatelessWidget {
  final _OrderItem item;

  const _OrderCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final statusText = _statusText(item.status);
    final statusBg = _statusBgColor(item.status);
    final statusTextColor = _statusTextColor(item.status);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFFFE082)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama + status chip
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.customerName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      item.vehicle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: statusTextColor,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // service summary
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              item.service,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[800]),
            ),
          ),

          SizedBox(height: 10.h),

          // date + time + tombol detail
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: Colors.grey[700],
              ),
              SizedBox(width: 4.w),
              Text(
                item.date,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[800]),
              ),
              SizedBox(width: 18.w),
              Icon(Icons.access_time, size: 14, color: Colors.grey[700]),
              SizedBox(width: 4.w),
              Text(
                item.time,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[800]),
              ),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFEB5757),
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 6.h,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                onPressed: () {
                  // TODO: nanti arahkan ke detail riwayat
                },
                child: Text(
                  'Detail',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _statusText(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
        return 'Menunggu';
      case OrderStatus.process:
        return 'Proses';
      case OrderStatus.done:
        return 'Selesai';
      case OrderStatus.cancelled:
        return 'Batal';
    }
  }

  Color _statusBgColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
      case OrderStatus.process:
        return const Color(0xFFFFF3CD); // kuning muda
      case OrderStatus.done:
        return const Color(0xFFE8F5E9); // hijau muda
      case OrderStatus.cancelled:
        return const Color(0xFFFFEBEE); // merah muda
    }
  }

  Color _statusTextColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
      case OrderStatus.process:
        return const Color(0xFFF2994A); // oranye
      case OrderStatus.done:
        return const Color(0xFF2E7D32); // hijau
      case OrderStatus.cancelled:
        return const Color(0xFFEB5757); // merah
    }
  }
}
