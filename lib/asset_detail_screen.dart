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
      Uri.parse("http://10.0.2.2:5000/assets/code/${widget.assetCode}"),
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
      Uri.parse("http://10.0.2.2:5000/assets/${asset["asset_id"]}"),
    );

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  Widget _field(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          hintText: value,
          filled: true,
          fillColor: const Color(0xffEEEEEE),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
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

            /// HOME
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

            /// SEARCH
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
            ),

            /// SCAN QR
            IconButton(
              icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const QRScanScreen(),
                  ),
                );

                if (result != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AssetDetailScreen(assetCode: result),
                    ),
                  );
                }
              },
            ),

            /// ADD
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddAssetScreen(),
                  ),
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
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    asset["image"] != null && asset["image"] != ""
                        ? Image.network(
                            "http://10.0.2.2:5000/uploads/${asset["image"]}",
                            height: 150,
                          )
                        : const Icon(Icons.image, size: 120),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditAssetScreen(asset: asset),
                          ),
                        );
                      },
                      child: const Text("แก้ไข"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// QR
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    const Text(
                      "QR Code",
                      style: TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 10),

                    QrImageView(
                      data: asset["asset_code"] ?? "",
                      size: 150,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// DETAILS
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    _field("รหัสครุภัณฑ์", asset["asset_code"] ?? ""),
                    _field("ชื่อครุภัณฑ์", asset["asset_name"] ?? ""),
                    _field("ประเภท", asset["type_name"] ?? ""),
                    _field("ยี่ห้อ", asset["brand"] ?? ""),
                    _field("สถานที่", asset["location"] ?? ""),
                    _field("รายละเอียด", asset["description"] ?? ""),
                    _field("สถานะ", asset["status"] ?? ""),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// BUTTONS
            Row(
              children: [

                /// EDIT
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text("แก้ไข"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditAssetScreen(asset: asset),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 10),

                /// DELETE
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
                          content:
                              const Text("ต้องการลบข้อมูลนี้ใช่หรือไม่ ?"),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, false),
                              child: const Text("ยกเลิก"),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, true),
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