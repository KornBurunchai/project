import 'package:flutter/material.dart';
import 'qr_scan_screen.dart';
import 'home_screen.dart';
import 'asset_detail_screen.dart';
import 'search_screen.dart';

class EditAssetScreen extends StatelessWidget {
  const EditAssetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEDEDED),

      appBar: AppBar(
        backgroundColor: const Color(0xff4F6F52),
        foregroundColor: Colors.white,

        /// 🔹 ปุ่มย้อนกลับไปหน้า Detail
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text("แก้ไขข้อมูลครุภัณฑ์"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField("รหัสครุภัณฑ์"),
            buildTextField("ชื่อครุภัณฑ์"),
            buildTextField("ประเภทครุภัณฑ์"),
            buildTextField("ยี่ห้อ"),
            buildTextField("ที่ตั้งครุภัณฑ์"),
            buildTextField("รายละเอียด", maxLine: 3),

            const SizedBox(height: 10),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text("สถานะครุภัณฑ์"),
            ),

            Row(
              children: const [
                Radio(value: 1, groupValue: 1, onChanged: null),
                Text("ปกติ"),
                Radio(value: 2, groupValue: 1, onChanged: null),
                Text("แจ้งซ่อม"),
                Radio(value: 3, groupValue: 1, onChanged: null),
                Text("จำหน่ายออก"),
              ],
            ),

            const SizedBox(height: 10),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text("รูปครุภัณฑ์"),
            ),

            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xff4F6F52,
                    ), // ปุ่มสีเขียวเหมือนเดิม
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("browse"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4F6F52),
                  foregroundColor: Colors.white, // 👈 ตัวอักษรสีขาว
                  padding: const EdgeInsets.all(15),
                ),
                child: const Text("บันทึก"),
              ),
            ),
          ],
        ),
      ),

      /// 🔻 BOTTOM MENU เหมือน Home
      bottomNavigationBar: Container(
        height: 70,
        color: const Color(0xff4F6F52),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.home, color: Colors.white),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
              child: const Icon(Icons.search, color: Colors.white),
            ),

            /// 🔹 QR SCAN BUTTON
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QRScanScreen()),
                );

                if (result != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("QR Code: $result")));

                  print("QR = $result");
                }
              },
              child: const Icon(Icons.qr_code_scanner, color: Colors.white),
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditAssetScreen()),
                );
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String hint, {int maxLine = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        maxLines: maxLine,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
