import 'package:flutter/material.dart';
import 'qr_scan_screen.dart';
import 'search_screen.dart';

class EditAssetScreen extends StatefulWidget {
  const EditAssetScreen({super.key});

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEDEDED),

      appBar: AppBar(
        backgroundColor: const Color(0xff4F6F52),
        foregroundColor: Colors.white,
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
            /// 🔹 รหัสครุภัณฑ์ (มีปุ่ม QR)
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
                  onPressed: () {
                    // ใส่ image picker ภายหลังได้
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff4F6F52),
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
                onPressed: () {
                  print("Asset Code: ${assetCodeController.text}");
                  print("Name: ${nameController.text}");
                  print("Type: ${typeController.text}");
                  print("Brand: ${brandController.text}");
                  print("Location: ${locationController.text}");
                  print("Detail: ${detailController.text}");
                  print("Status: $status");

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("แก้ไขข้อมูลสำเร็จ")),
                  );
                },
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

      /// 🔻 BOTTOM MENU
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

  /// 🔹 ช่องรหัส พร้อมปุ่ม QR
  Widget buildAssetCodeField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: assetCodeController,
        decoration: InputDecoration(
          hintText: "รหัสครุภัณฑ์",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () async {
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
          ),
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
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
