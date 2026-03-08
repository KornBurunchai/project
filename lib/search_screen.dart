import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'home_screen.dart';
import 'qr_scan_screen.dart';
import 'add_asset_screen.dart';
import 'asset_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  List assets = [];
  bool loading = false;

  /// ================= STATUS COLOR =================
  Color getStatusColor(String status) {
    if (status == "ปกติ") return Colors.green;
    if (status == "แจ้งซ่อม") return Colors.orange;
    if (status == "จำหน่ายออก") return Colors.red;

    return Colors.grey;
  }

  /// ================= SEARCH =================
  Future searchAsset(String keyword) async {
    if (keyword.isEmpty) {
      setState(() {
        assets = [];
      });
      return;
    }

    setState(() {
      loading = true;
    });

    final res = await http.get(
      Uri.parse(
        "https://unsalubriously-courdinative-nathanael.ngrok-free.dev/assets?search=$keyword",
      ),
    );

    if (res.statusCode == 200) {
      final data = json.decode(res.body);

      setState(() {
        assets = data;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  /// ================= ASSET CARD =================
  Widget assetCard(Map asset) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AssetDetailScreen(assetCode: asset["asset_code"]),
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
            /// IMAGE
            Container(
              width: 60,
              height: 60,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300],
              ),

              child: asset["image"] != null && asset["image"] != ""
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        "https://unsalubriously-courdinative-nathanael.ngrok-free.dev/uploads/${asset["image"]}",
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.computer),
            ),

            const SizedBox(width: 12),

            /// TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${asset["asset_name"]} - ${asset["location"]}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    asset["status"] ?? "",
                    style: TextStyle(
                      color: getStatusColor(asset["status"]),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEDEDED),

      body: SafeArea(
        child: Column(
          children: [
            /// ================= HEADER =================
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

                  const SizedBox(height: 15),

                  /// SEARCH BAR
                  TextField(
                    controller: searchController,

                    onChanged: (value) {
                      searchAsset(value);
                    },

                    decoration: const InputDecoration(
                      hintText: "ค้นหาครุภัณฑ์ (ชื่อ / รหัส)",
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

            /// ================= RESULT =================
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : assets.isEmpty
                  ? Column(
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
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),

                      itemCount: assets.length,

                      itemBuilder: (context, index) {
                        final asset = assets[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: assetCard(asset),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      /// ================= BOTTOM MENU =================
      bottomNavigationBar: Container(
        height: 70,
        color: const Color(0xff4F6F52),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
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

            const Icon(Icons.search, color: Colors.white),

            GestureDetector(
              onTap: () {
                Navigator.push(
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
