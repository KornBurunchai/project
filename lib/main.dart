import 'package:flutter/material.dart';
import 'home_screen.dart'; // <-- เรียกหน้าเมื่อกี้
import 'login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ระบบตรวจเช็คครุภัณฑ์',

      theme: ThemeData(
        fontFamily: 'Prompt', // (ถ้าอยากใช้ฟอนต์ไทยสวยๆ)
        scaffoldBackgroundColor: const Color(0xffEDEDED),
      ),

      home: const LoginScreen(), // <-- เปิดมาหน้านี้เลย
    );
  }
}