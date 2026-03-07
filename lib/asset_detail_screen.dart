import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';

import 'home_screen.dart';
import 'qr_scan_screen.dart';
import 'add_asset_screen.dart';
import 'edit_asset_screen.dart';
import 'search_screen.dart';

class AssetDetailScreen extends StatefulWidget {
  final String assetCode;

  const AssetDetailScreen({super.key, required this.assetCode});

  @override
  State<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends State<AssetDetailScreen> {
  Map asset = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchAsset();
  }

  Future fetchAsset() async {
    final res = await http.get(
      Uri.parse("https://unsalubriously-courdinative-nathanael.ngrok-free.dev/assets/code/${widget.assetCode}"),
    );

    if (res.statusCode == 200) {
      setState(() {
        asset = json.decode(res.body);
        loading = false;
      });
    }
  }

  Future deleteAsset() async {
    await http.delete(
      Uri.parse("https://unsalubriously-courdinative-nathanael.ngrok-free.dev/assets/${asset["asset_id"]}"),
    );

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  Widget buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: const Color(0xffEEEEEE),
          borderRadius: BorderRadius.circular(8),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),

            const SizedBox(height: 4),

            Text(value, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        title: const Text("รายละเอียดครุภัณฑ์"),
        backgroundColor: const Color(0xff4F6F52),
        foregroundColor: Colors.white,
      ),

      bottomNavigationBar: Container(
        height: 70,
        color: const Color(0xff4F6F52),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );
              },
            ),

            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
            ),

            IconButton(
              icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QRScanScreen()),
                );

                if (result != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AssetDetailScreen(assetCode: result),
                    ),
                  );
                }
              },
            ),

            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddAssetScreen()),
                );
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            /// IMAGE
            Container(
              width: double.infinity,
              height: 180,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),

              child: asset["image"] != null && asset["image"] != ""
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "https://unsalubriously-courdinative-nathanael.ngrok-free.dev/uploads/${asset["image"]}",
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Center(child: Icon(Icons.image, size: 100)),
            ),

            const SizedBox(height: 20),

            /// QR CODE
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                children: [
                  const Text(
                    "QR Code",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  QrImageView(
                    data: asset["asset_code"] ?? "",
                    size: MediaQuery.of(context).size.width * 0.45,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// DETAILS
            buildField("รหัสครุภัณฑ์", asset["asset_code"] ?? ""),
            buildField("ชื่อครุภัณฑ์", asset["asset_name"] ?? ""),
            buildField("ประเภท", asset["type_name"] ?? ""),
            buildField("ยี่ห้อ", asset["brand"] ?? ""),
            buildField("สถานที่", asset["location"] ?? ""),
            buildField("รายละเอียด", asset["description"] ?? ""),
            buildField("สถานะ", asset["status"] ?? ""),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text("แก้ไข"),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),

                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditAssetScreen(asset: asset),
                        ),
                      );

                      if (result == true) {
                        fetchAsset();
                      }
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.delete),
                    label: const Text("ลบ"),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),

                    onPressed: () async {
                      bool confirm = await showDialog(
                        context: context,

                        builder: (_) => AlertDialog(
                          title: const Text("ยืนยัน"),
                          content: const Text("ต้องการลบข้อมูลนี้ใช่หรือไม่"),

                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("ยกเลิก"),
                            ),

                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("ลบ"),
                            ),
                          ],
                        ),
                      );

                      if (confirm) {
                        deleteAsset();
                      }
                    },
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
