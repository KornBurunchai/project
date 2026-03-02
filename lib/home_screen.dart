import 'package:flutter/material.dart';
import 'qr_scan_screen.dart';
import 'add_asset_screen.dart';
import 'asset_detail_screen.dart';
import 'search_screen.dart';

/// ================= STATUS CARD =================
class StatusCard extends StatelessWidget {
  final String number;
  final String label;
  final Color color;

  const StatusCard({
    super.key,
    required this.number,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}

/// ================= ASSET ITEM =================
class AssetItem extends StatelessWidget {
  final String name;
  final String status;
  final Color statusColor;

  const AssetItem({
    super.key,
    required this.name,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AssetDetailScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.computer),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                const SizedBox(height: 5),
                Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= HOME SCREEN =================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEDEDED),

      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: const Color(0xff4F6F52),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "ระบบตรวจเช็คครุภัณฑ์",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      StatusCard(
                        number: "20",
                        label: "ทั้งหมด",
                        color: Colors.blue,
                      ),
                      StatusCard(
                        number: "15",
                        label: "ปกติ",
                        color: Colors.green,
                      ),
                      StatusCard(
                        number: "3",
                        label: "แจ้งซ่อม",
                        color: Colors.orange,
                      ),
                      StatusCard(
                        number: "2",
                        label: "จำหน่ายออก",
                        color: Colors.red,
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "ค้นหาครุภัณฑ์",
                        border: InputBorder.none,
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// LIST
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  AssetItem(
                    name: "โน๊ตบุ๊ค - A401",
                    status: "แจ้งซ่อม",
                    statusColor: Colors.orange,
                  ),
                  SizedBox(height: 12),
                  AssetItem(
                    name: "เครื่องคอมพิวเตอร์ - B402",
                    status: "ปกติ",
                    statusColor: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      /// ================= BOTTOM NAV =================
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

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
              child: const Icon(Icons.search, color: Colors.white),
            ),

            /// QR SCAN
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
                }
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
