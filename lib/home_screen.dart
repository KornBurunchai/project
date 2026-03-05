import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'qr_scan_screen.dart';
import 'add_asset_screen.dart';
import 'asset_detail_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

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
      width: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(label),
        ],
      ),
    );
  }
}

/// ================= ASSET ITEM =================
class AssetItem extends StatelessWidget {
  final String assetCode;
  final String name;
  final String status;
  final Color statusColor;

  const AssetItem({
    super.key,
    required this.assetCode,
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
          MaterialPageRoute(
            builder: (_) => AssetDetailScreen(assetCode: assetCode),
          ),
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

class _HomeScreenState extends State<HomeScreen> {
  List assets = [];

  int total = 0;
  int normal = 0;
  int repair = 0;
  int disposed = 0;

  @override
  void initState() {
    super.initState();
    fetchAssets();
    fetchDashboard();
  }

  /// ================= GET ASSETS =================
  Future<void> fetchAssets() async {
    final res = await http.get(Uri.parse("http://10.0.2.2:5000/assets"));

    if (res.statusCode == 200) {
      setState(() {
        assets = json.decode(res.body);
      });
    }
  }

  /// ================= GET DASHBOARD =================
  Future<void> fetchDashboard() async {
    final res = await http.get(Uri.parse("http://10.0.2.2:5000/dashboard"));

    if (res.statusCode == 200) {
      final data = json.decode(res.body);

      setState(() {
        total = data["total"];
        normal = data["normal"];
        repair = data["repair"];
        disposed = data["disposed"];
      });
    }
  }

  Color getStatusColor(String status) {
    if (status == "ปกติ") return Colors.green;
    if (status == "แจ้งซ่อม") return Colors.orange;
    if (status == "จำหน่ายออก") return Colors.red;
    return Colors.grey;
  }

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

                  /// DASHBOARD
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      StatusCard(
                        number: total.toString(),
                        label: "ทั้งหมด",
                        color: Colors.blue,
                      ),
                      StatusCard(
                        number: normal.toString(),
                        label: "ปกติ",
                        color: Colors.green,
                      ),
                      StatusCard(
                        number: repair.toString(),
                        label: "แจ้งซ่อม",
                        color: Colors.orange,
                      ),
                      StatusCard(
                        number: disposed.toString(),
                        label: "จำหน่ายออก",
                        color: Colors.red,
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// SEARCH
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

            /// LIST ASSETS
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: assets.length,
                itemBuilder: (context, index) {
                  final item = assets[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AssetItem(
                      assetCode: item["asset_code"],
                      name: "${item["asset_name"]} - ${item["location"]}",
                      status: item["status"],
                      statusColor: getStatusColor(item["status"]),
                    ),
                  );
                },
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
            const Icon(Icons.home, color: Colors.white),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
              child: const Icon(Icons.search, color: Colors.white),
            ),

            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QRScanScreen()),
                );
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
    );
  }
}
