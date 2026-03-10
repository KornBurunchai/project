import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'qr_scan_screen_add.dart';
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

  File? imageFile;
  final picker = ImagePicker();

  List typeList = [];
  int? typeId;

  List<String> statusList = [
    "ปกติ",
    "แจ้งซ่อม",
    "จำหน่ายออก"
  ];

  @override
  void initState() {
    super.initState();
    loadTypes();
  }

  /// โหลดประเภทครุภัณฑ์
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

  /// เลือกรูป / ถ่ายรูป
  Future pickImage(ImageSource source) async {

    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  /// แสดงตัวเลือก Camera / Gallery
  void showImagePicker(){

    showModalBottomSheet(
      context: context,
      builder: (context){

        return SafeArea(
          child: Wrap(
            children: [

              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("ถ่ายรูป"),
                onTap: (){
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),

              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("เลือกรูปจากคลัง"),
                onTap: (){
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),

            ],
          ),
        );

      },
    );

  }

  /// อัปโหลดรูป
  Future<String?> uploadImage() async {

    if(imageFile == null) return "";

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

    return "";
  }

  /// เพิ่มครุภัณฑ์
  Future addAsset() async {

    String? imageName = await uploadImage();

    var response = await http.post(
      Uri.parse("https://unsalubriously-courdinative-nathanael.ngrok-free.dev/assets"),
      headers: {"Content-Type":"application/json"},
      body: jsonEncode({

        "asset_code": assetCodeController.text,
        "asset_name": nameController.text,
        "type_id": typeId,
        "brand": brandController.text,
        "location": locationController.text,
        "description": detailController.text,
        "status": status,
        "image": imageName

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

  /// สแกน QR
  Future scanQR() async {

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_)=>const QRScanScreenAdd(),
      ),
    );

    if(result != null){
      setState(() {
        assetCodeController.text = result.toString().trim();
      });
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
              onPressed: showImagePicker,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text("เลือกรูป / ถ่ายรูป"),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(

                onPressed: addAsset,

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
              onTap: scanQR,
              child: const Icon(Icons.qr_code_scanner,color: Colors.white),
            ),

            const Icon(Icons.add,color: Colors.white),

          ],
        ),
      ),
    );
  }

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
            onPressed: scanQR,
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