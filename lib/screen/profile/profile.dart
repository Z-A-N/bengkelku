// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileTab extends StatefulWidget {
  final String name;
  final String email;
  final String? phone;
  final VoidCallback? onLogout;

  const ProfileTab({
    super.key,
    required this.name,
    required this.email,
    this.phone,
    this.onLogout,
  });

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _notifOn = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                _buildAccountInfoCard(),
                SizedBox(height: 12.h),
                _buildSettingsCard(),
                SizedBox(height: 12.h),
                _buildHelpCard(),
                SizedBox(height: 20.h),
                _buildLogoutButton(),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER KUNING =================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 36.h, bottom: 24.h),
      decoration: const BoxDecoration(
        color: Color(0xFFFFD740),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Text(
            "Profile Saya",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16.h),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 40.r,
                backgroundColor: Colors.white,
                child: Text(
                  _initials(widget.name),
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFDB0C0C),
                  ),
                ),
              ),
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFDB0C0C),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            widget.name,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 4.h),
          Text(
            "Member sejak Maret 2025",
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "Edit Foto Profil",
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFFDB0C0C),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ================= KARTU INFORMASI AKUN =================

  Widget _buildAccountInfoCard() {
    return _ProfileCard(
      title: "Informasi Akun",
      trailingIcon: Icons.edit_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow("Nama Lengkap", widget.name),
          SizedBox(height: 10.h),
          _infoRow("Nomor Hp", widget.phone ?? "-"),
          SizedBox(height: 10.h),
          _infoRow("Email", widget.email),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11.sp, color: Colors.grey[700]),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // ================= KARTU PENGATURAN =================

  Widget _buildSettingsCard() {
    return _ProfileCard(
      title: "Pengaturan Akun",
      child: Column(
        children: [
          _settingRow(
            icon: Icons.lock_outline,
            label: "Ubah Password",
            trailing: const Icon(Icons.chevron_right),
          ),
          Divider(height: 18.h),
          _settingRow(
            icon: Icons.notifications_none,
            label: "Notifikasi",
            trailing: Switch(
              value: _notifOn,
              activeThumbColor: const Color(0xFFDB0C0C),
              onChanged: (val) {
                setState(() => _notifOn = val);
              },
            ),
          ),
          Divider(height: 18.h),
          _settingRow(
            icon: Icons.delete_outline,
            label: "Hapus Akun",
            color: const Color(0xFFDB0C0C),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _settingRow({
    required IconData icon,
    required String label,
    Widget? trailing,
    Color? color,
  }) {
    final iconColor = color ?? Colors.black87;
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: iconColor,
            ),
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  // ================= KARTU BANTUAN =================

  Widget _buildHelpCard() {
    return _ProfileCard(
      title: "Bantuan Dan Dukungan",
      child: Column(
        children: [
          _helpRow("Hubungi Layanan Pelanggan"),
          Divider(height: 18.h),
          _helpRow("FAQ"),
          Divider(height: 18.h),
          _helpRow("Syarat & Ketentuan"),
        ],
      ),
    );
  }

  Widget _helpRow(String label) {
    return Row(
      children: [
        const Icon(Icons.chevron_right, color: Colors.transparent),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.grey),
      ],
    );
  }

  // ================= TOMBOL KELUAR =================

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFDB0C0C)),
          foregroundColor: const Color(0xFFDB0C0C),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
        ),
        onPressed: widget.onLogout,
        child: Text(
          "Keluar",
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(" ");
    if (parts.length == 1) {
      return parts.first.isNotEmpty ? parts.first[0].toUpperCase() : "P";
    }
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

// ================= WIDGET KARTU REUSABLE =================

class _ProfileCard extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData? trailingIcon;

  const _ProfileCard({
    required this.title,
    required this.child,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
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
          Row(
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              if (trailingIcon != null)
                Icon(trailingIcon, size: 18, color: Colors.grey[700]),
            ],
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}
