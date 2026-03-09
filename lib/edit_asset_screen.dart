import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'qr_scan_screen_add.dart';
import 'home_screen.dart';

class EditAssetScreen extends StatefulWidget {

  final Map asset;

  const EditAssetScreen({super.key, required this.asset});

  @override
  State<EditAssetScreen> createState() => _EditAssetScreenState();
}

class _EditAssetScreenState extends State<EditAssetScreen> {

  final TextEditingController assetCodeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController detailController = TextEditingController();

  String status = "ปกติ";

  File? imageFile;
  String? oldImage;

  final picker = ImagePicker();

  /// ================= TYPE =================
  List typeList = [];
  int? typeId;

  /// ================= STATUS =================
  List<String> statusList = [
    "ปกติ",
    "แจ้งซ่อม",
    "จำหน่ายออก"
  ];

  /// ================= INIT =================
  @override
  void initState() {
    super.initState();

    assetCodeController.text = widget.asset["asset_code"] ?? "";
    nameController.text = widget.asset["asset_name"] ?? "";
    brandController.text = widget.asset["brand"] ?? "";
    locationController.text = widget.asset["location"] ?? "";
    detailController.text = widget.asset["description"] ?? "";

    status = widget.asset["status"] ?? "ปกติ";
    oldImage = widget.asset["image"];
    typeId = widget.asset["type_id"];

    loadTypes();
  }

  /// ================= LOAD TYPES =================
  Future loadTypes() async {

    var res = await http.get(
      Uri.parse("https://unsalubriously-courdinative-nathanael.ngrok-free.dev/types")
    );

    if(res.statusCode == 200){

      var data = jsonDecode(res.body);

      setState(() {
        typeList = data;
      });

    }
  }

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

    if(imageFile == null) return oldImage;

    var request = http.MultipartRequest(
        'POST',
        Uri.parse("https://unsalubriously-courdinative-nathanael.ngrok-free.dev/upload")
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

    return oldImage;
  }

  /// ================= UPDATE ASSET =================
  Future updateAsset() async {

    String? imageName = await uploadImage();

    var response = await http.put(
      Uri.parse("https://unsalubriously-courdinative-nathanael.ngrok-free.dev/assets/${widget.asset["asset_id"]}"),
      headers: {"Content-Type":"application/json"},
      body: jsonEncode({

        "asset_code": assetCodeController.text,
        "asset_name": nameController.text,
        "type_id": typeId,
        "brand": brandController.text,
        "location": locationController.text,
        "description": detailController.text,
        "status": status,
        "image": imageName ?? ""

      }),
    );

    if(response.statusCode == 200){

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("แก้ไขครุภัณฑ์สำเร็จ"))
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
      );

    }else{

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("แก้ไขข้อมูลไม่สำเร็จ"))
      );

    }

  }

  /// ================= UI =================
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

            /// TYPE
            DropdownButtonFormField(
              value: typeId,
              items: typeList.map<DropdownMenuItem>((item){

                return DropdownMenuItem(
                  value: item["type_id"],
                  child: Text(item["type_name"]),
                );

              }).toList(),

              onChanged: (value){
                setState(() {
                  typeId = value;
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

            /// STATUS
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

            /// IMAGE
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("รูปครุภัณฑ์"),
            ),

            const SizedBox(height: 5),

            imageFile != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                imageFile!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
                : oldImage != null && oldImage != ""
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "https://unsalubriously-courdinative-nathanael.ngrok-free.dev/uploads/$oldImage",
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
                : Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(child: Text("ยังไม่มีรูป")),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text("เลือกรูป"),
            ),

            const SizedBox(height: 20),

            /// SAVE
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(

                onPressed: updateAsset,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
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
    );
  }

  /// ================= ASSET CODE =================
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
                MaterialPageRoute(
                  builder: (_)=>const QRScanScreenAdd(),
                ),
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

  /// ================= TEXTFIELD =================
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