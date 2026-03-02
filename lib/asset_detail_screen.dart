import 'package:flutter/material.dart';
import 'qr_scan_screen.dart';
import 'home_screen.dart';
import 'add_asset_screen.dart';
import 'edit_asset_screen.dart';
import 'search_screen.dart';

class AssetDetailScreen extends StatelessWidget {
  const AssetDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        backgroundColor: const Color(0xff4F6F52),
        title: const Text("รายละเอียดครุภัณฑ์"),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),

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
                  MaterialPageRoute(builder: (_) => const AddAssetScreen()),
                );
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// IMAGE CARD
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset(
                        "assets/images/laptop.jpg",
                        height: 120,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("แก้ไข"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// QR CARD
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("QR Code"),
                    const SizedBox(height: 10),
                    Center(child: Image.asset("assets/qr.png", height: 150)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// DETAIL CARD
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _readOnlyField("C-123"),
                    _readOnlyField("MacBook"),
                    _readOnlyField("ประเภทครุภัณฑ์"),
                    _readOnlyField("Apple"),
                    _readOnlyField("A401"),
                    _readOnlyField("รายละเอียด"),
                    _readOnlyField("ปกติ"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// BUTTONS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditAssetScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text(
                      "แก้ไข",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.delete),
                    label: const Text("ลบ"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _readOnlyField(String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          hintText: value,
          filled: true,
          fillColor: const Color(0xffEEEEEE),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
