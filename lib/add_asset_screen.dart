import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'qr_scan_screen.dart';
import 'search_screen.dart';
import 'home_screen.dart';

class AddAssetScreen extends StatefulWidget {
  const AddAssetScreen({super.key});

  @override
  State<AddAssetScreen> createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends State<AddAssetScreen> {

  final TextEditingController assetCodeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController detailController = TextEditingController();

  String status = "ปกติ";
  String type = "คอมพิวเตอร์";

  File? imageFile;
  final picker = ImagePicker();

  List<String> typeList = [
    "คอมพิวเตอร์",
    "จอภาพ",
    "เครื่องพิมพ์",
    "โต๊ะ",
    "เก้าอี้",
    "อื่นๆ",
  ];

  List<String> statusList = [
    "ปกติ",
    "แจ้งซ่อม",
    "จำหน่ายออก"
  ];

  /// ================= PICK IMAGE =================
  Future pickImage() async {

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  /// ================= UPLOAD IMAGE =================
  Future<String?> uploadImage() async {

    if(imageFile == null) return null;

    var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://10.0.2.2:5000/upload")
    );

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile!.path),
    );

    var response = await request.send();

    if(response.statusCode == 200){

      var res = await http.Response.fromStream(response);
      var data = jsonDecode(res.body);

      return data["filename"];

    }

    return null;
  }

  /// ================= ADD ASSET =================
  Future addAsset() async {

    String? imageName = await uploadImage();

    var response = await http.post(
      Uri.parse("http://10.0.2.2:5000/assets"),
      headers: {"Content-Type":"application/json"},
      body: jsonEncode({

        "asset_code": assetCodeController.text,
        "asset_name": nameController.text,
        "type_id": 1, // ใส่ id จริงจาก DB ได้
        "brand": brandController.text,
        "location": locationController.text,
        "description": detailController.text,
        "status": status,
        "image": imageName ?? ""

      }),
    );

    if(response.statusCode == 200){

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("เพิ่มครุภัณฑ์สำเร็จ"))
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );

    }else{

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("เพิ่มข้อมูลไม่สำเร็จ"))
      );

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffEDEDED),

      appBar: AppBar(
        backgroundColor: const Color(0xff4F6F52),
        foregroundColor: Colors.white,
        title: const Text("เพิ่มข้อมูลครุภัณฑ์"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            buildAssetCodeField(),

            buildTextField("ชื่อครุภัณฑ์", nameController),

            /// TYPE DROPDOWN
            DropdownButtonFormField(
              value: type,
              items: typeList.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value){
                setState(() {
                  type = value.toString();
                });
              },
              decoration: const InputDecoration(
                labelText: "ประเภทครุภัณฑ์",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            buildTextField("ยี่ห้อ", brandController),
            buildTextField("ที่ตั้งครุภัณฑ์", locationController),
            buildTextField("รายละเอียด", detailController,maxLine:3),

            const SizedBox(height: 10),

            /// STATUS DROPDOWN
            DropdownButtonFormField(
              value: status,
              items: statusList.map((item){
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value){
                setState(() {
                  status = value.toString();
                });
              },
              decoration: const InputDecoration(
                labelText: "สถานะครุภัณฑ์",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            /// IMAGE PREVIEW
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("รูปครุภัณฑ์"),
            ),

            const SizedBox(height: 5),

            imageFile == null
                ? Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(child: Text("ยังไม่มีรูป")),
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                imageFile!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4F6F52),
                foregroundColor: Colors.white,
              ),
              child: const Text("เลือกรูป"),
            ),

            const SizedBox(height: 20),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(

                onPressed: addAsset,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4F6F52),
                  padding: const EdgeInsets.all(15),
                ),

                child: const Text(
                  "บันทึก",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),

      /// BOTTOM MENU
      bottomNavigationBar: Container(
        height: 70,
        color: const Color(0xff4F6F52),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_)=>const HomeScreen()),
                );
              },
              child: const Icon(Icons.home,color: Colors.white),
            ),

            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_)=>const SearchScreen()),
                );
              },
              child: const Icon(Icons.search,color: Colors.white),
            ),

            GestureDetector(
              onTap: () async {

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_)=>const QRScanScreen()),
                );

                if(result != null){
                  setState(() {
                    assetCodeController.text = result;
                  });
                }

              },
              child: const Icon(Icons.qr_code_scanner,color: Colors.white),
            ),

            const Icon(Icons.add,color: Colors.white),

          ],
        ),
      ),
    );
  }

  /// ASSET CODE FIELD
  Widget buildAssetCodeField(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: assetCodeController,
        decoration: InputDecoration(
          hintText: "รหัสครุภัณฑ์",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () async{

              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_)=>const QRScanScreen()),
              );

              if(result != null){
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
      TextEditingController controller,
      {int maxLine = 1}
      ){

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        maxLines: maxLine,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}