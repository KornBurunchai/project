import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'qr_scan_screen.dart';
import 'add_asset_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEDEDED),

      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: const Color(0xff4F6F52),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "ระบบตรวจเช็คครุภัณฑ์",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 15),

                  /// SEARCH BAR
                  TextField(
                    decoration: InputDecoration(
                      hintText: "ค้นหาครุภัณฑ์",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// 🔹 EMPTY STATE
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.search, size: 80, color: Colors.grey),

                  SizedBox(height: 10),

                  Text(
                    "ค้นหาครุภัณฑ์",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                  SizedBox(height: 5),

                  Text(
                    "กรอกชื่อหรือรหัสเพื่อค้นหา",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      /// 🔻 BOTTOM NAV
      bottomNavigationBar: Container(
        height: 70,
        color: const Color(0xff4F6F52),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            /// HOME
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );
              },
              child: const Icon(Icons.home, color: Colors.white),
            ),

            /// SEARCH (อยู่หน้าเดิม)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
              child: const Icon(Icons.search, color: Colors.white),
            ),

            /// QR
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QRScanScreen()),
                );
              },
              child: const Icon(Icons.qr_code_scanner, color: Colors.white),
            ),

            /// ADD
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddAssetScreen()),
                );
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
