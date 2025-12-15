// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'chat_room.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = [
      _ChatItem(
        name: 'Bengkel Terus Jaya',
        lastMessage: 'Hai pak, apakah motor saya sudah selesai?',
        time: '09:10',
        unreadCount: 1,
        isBengkel: true,
      ),
      _ChatItem(
        name: 'Arion',
        lastMessage: 'Hai pak, apakah motor saya sudah selesai?',
        time: '09:10',
        unreadCount: 1,
      ),
      _ChatItem(
        name: 'Arion',
        lastMessage: 'Hai pak, apakah motor saya sudah selesai?',
        time: '09:10',
        unreadCount: 1,
      ),
      _ChatItem(
        name: 'Arion',
        lastMessage: 'Hai pak, apakah motor saya sudah selesai?',
        time: '09:10',
        unreadCount: 1,
      ),
      _ChatItem(
        name: 'Arion',
        lastMessage: 'Hai pak, apakah motor saya sudah selesai?',
        time: '09:10',
        unreadCount: 1,
      ),
    ];

    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false, // SafeArea utama sudah di HomeDashboard
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

              // Title
              Center(
                child: Text(
                  'Chat Bengkel',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Search bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[600]),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Cari',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // List chat
              Expanded(
                child: ListView.separated(
                  itemCount: chats.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final item = chats[index];
                    return _ChatTile(item: item);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== MODEL KECIL BUAT DUMMY DATA =====

class _ChatItem {
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isBengkel;

  _ChatItem({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    this.isBengkel = false,
  });
}

// ===== WIDGET TILE CHAT =====

class _ChatTile extends StatelessWidget {
  final _ChatItem item;

  const _ChatTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // buka room chat
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ChatRoomPage(title: item.name)),
        );
      },
      child: Row(
        children: [
          // avatar
          CircleAvatar(
            radius: 22.r,
            backgroundColor: item.isBengkel
                ? const Color(0xFFFFD740)
                : Colors.grey[300],
            child: Text(
              item.name.isNotEmpty ? item.name[0] : '?',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(width: 10.w),

          // nama + last message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  item.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // time + badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.time,
                style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 6.h),
              if (item.unreadCount > 0)
                Container(
                  width: 18.w,
                  height: 18.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEB5757),
                  ),
                  child: Center(
                    child: Text(
                      item.unreadCount.toString(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
