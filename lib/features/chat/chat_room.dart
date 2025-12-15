// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatRoomPage extends StatelessWidget {
  final String title;

  const ChatRoomPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar kuning custom biar mirip desain
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(height: 1),
            Expanded(child: _buildMessagesList()),
            const Divider(height: 1),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFFFFD740),
      padding: EdgeInsets.fromLTRB(8.w, 8.h, 16.w, 10.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Terakhir dilihat 45 menit lalu',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    // dummy messages – nanti bisa diganti dari backend
    final messages = [
      _Message(text: 'Hi team 👋', time: '11:31 AM', isMe: true),
      _Message(text: 'Anyone on for lunch today', time: '11:31 AM', isMe: true),
      _Message(
        text: 'I\'m down! Any ideas??',
        time: '11:35 AM',
        isMe: false,
        sender: 'Jav',
        subtitle: 'Engineering',
      ),
      _Message(text: 'Let me know', time: '11:41 AM', isMe: false),
    ];

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: messages.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          // tanggal di tengah
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Center(
              child: Text(
                '8/20/2020',
                style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
              ),
            ),
          );
        }

        final msg = messages[index - 1];
        return _MessageBubble(message: msg);
      },
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Start typing...',
                  hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.emoji_emotions_outlined),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.send_rounded)),
        ],
      ),
    );
  }
}

// ===== MODEL & BUBBLE CHAT =====

class _Message {
  final String text;
  final String time;
  final bool isMe;
  final String? sender;
  final String? subtitle;

  _Message({
    required this.text,
    required this.time,
    required this.isMe,
    this.sender,
    this.subtitle,
  });
}

class _MessageBubble extends StatelessWidget {
  final _Message message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isMe) {
      // bubble kuning (punya user)
      return Padding(
        padding: EdgeInsets.only(left: 80.w, bottom: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD740),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(message.text, style: TextStyle(fontSize: 13.sp)),
            ),
            SizedBox(height: 2.h),
            Text(
              message.time,
              style: TextStyle(fontSize: 10.sp, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    } else {
      // bubble abu (punya bengkel / orang lain)
      return Padding(
        padding: EdgeInsets.only(right: 80.w, bottom: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 14.r,
              backgroundColor: Colors.grey[300],
              child: Text(
                message.sender != null && message.sender!.isNotEmpty
                    ? message.sender![0]
                    : 'B',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.sender != null) ...[
                    Text(
                      message.sender!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (message.subtitle != null)
                      Text(
                        message.subtitle!,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    SizedBox(height: 4.h),
                  ],
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(fontSize: 13.sp),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    message.time,
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
