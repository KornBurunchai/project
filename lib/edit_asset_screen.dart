import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'qr_scan_screen.dart';
import 'search_screen.dart';

class EditAssetScreen extends StatefulWidget {
  final Map asset;

  const EditAssetScreen({super.key, required this.asset});

  @override
  State<EditAssetScreen> createState() => _EditAssetScreenState();
}

class _EditAssetScreenState extends State<EditAssetScreen> {
  final TextEditingController assetCodeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController detailController = TextEditingController();

  String status = "ปกติ";

  @override
  void initState() {
    super.initState();

    /// โหลดข้อมูลเดิม
    assetCodeController.text = widget.asset["asset_code"] ?? "";
    nameController.text = widget.asset["asset_name"] ?? "";
    typeController.text = widget.asset["type_name"] ?? "";
    brandController.text = widget.asset["brand"] ?? "";
    locationController.text = widget.asset["location"] ?? "";
    detailController.text = widget.asset["description"] ?? "";
    status = widget.asset["status"] ?? "ปกติ";
  }

  /// UPDATE API
  Future updateAsset() async {
    final res = await http.put(
      Uri.parse(
          "http://10.0.2.2:5000/assets/${widget.asset["asset_id"]}"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "asset_code": assetCodeController.text,
        "asset_name": nameController.text,
        "type_name": typeController.text,
        "brand": brandController.text,
        "location": locationController.text,
        "description": detailController.text,
        "status": status
      }),
    );

    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("แก้ไขข้อมูลสำเร็จ")),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEDEDED),

      appBar: AppBar(
        backgroundColor: const Color(0xff4F6F52),
        foregroundColor: Colors.white,
        title: const Text("แก้ไขข้อมูลครุภัณฑ์"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            buildAssetCodeField(),

            buildTextField("ชื่อครุภัณฑ์", nameController),
            buildTextField("ประเภทครุภัณฑ์", typeController),
            buildTextField("ยี่ห้อ", brandController),
            buildTextField("ที่ตั้งครุภัณฑ์", locationController),
            buildTextField("รายละเอียด", detailController, maxLine: 3),

            const SizedBox(height: 10),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text("สถานะครุภัณฑ์"),
            ),

            Row(
              children: [
                Radio(
                  value: "ปกติ",
                  groupValue: status,
                  onChanged: (value) {
                    setState(() {
                      status = value.toString();
                    });
                  },
                ),
                const Text("ปกติ"),

                Radio(
                  value: "แจ้งซ่อม",
                  groupValue: status,
                  onChanged: (value) {
                    setState(() {
                      status = value.toString();
                    });
                  },
                ),
                const Text("แจ้งซ่อม"),

                Radio(
                  value: "จำหน่ายออก",
                  groupValue: status,
                  onChanged: (value) {
                    setState(() {
                      status = value.toString();
                    });
                  },
                ),
                const Text("จำหน่ายออก"),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: updateAsset,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4F6F52),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(15),
                ),
                child: const Text("บันทึก"),
              ),
            ),
          ],
        ),
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

            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QRScanScreen()),
                );

                if (result != null) {
                  setState(() {
                    assetCodeController.text = result;
                  });
                }
              },
              child: const Icon(Icons.qr_code_scanner, color: Colors.white),
            ),

            const Icon(Icons.edit, color: Colors.white),
          ],
        ),
      ),
    );
  }

  /// รหัสครุภัณฑ์
  Widget buildAssetCodeField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: assetCodeController,
        decoration: InputDecoration(
          hintText: "รหัสครุภัณฑ์",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget buildTextField(
    String hint,
    TextEditingController controller, {
    int maxLine = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        maxLines: maxLine,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}