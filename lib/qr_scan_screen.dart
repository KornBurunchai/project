import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vibration/vibration.dart';
import 'package:http/http.dart' as http;

import 'asset_detail_screen.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen>
    with SingleTickerProviderStateMixin {

  bool scanned = false;

  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
    formats: [
      BarcodeFormat.qrCode,
      BarcodeFormat.code128,
      BarcodeFormat.code39,
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
      BarcodeFormat.itf,
    ],
  );

  late AnimationController laserController;
  late Animation<double> laserAnimation;

  @override
  void initState() {
    super.initState();

    laserController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    laserAnimation = Tween<double>(
      begin: -120,
      end: 120,
    ).animate(laserController);
  }

  @override
  void dispose() {
    controller.dispose();
    laserController.dispose();
    super.dispose();
  }

  Future checkAsset(String code) async {

    var res = await http.get(
      Uri.parse("https://YOUR_URL/assets/code/$code"),
    );

    if(res.statusCode == 200){

      var data = jsonDecode(res.body);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AssetDetailScreen(assetCode: data["asset_code"]),
        ),
      );

    }else{

      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("ไม่พบข้อมูล"),
            content: const Text("ไม่เจอข้อมูลครุภัณฑ์"),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                  setState(() {
                    scanned = false;
                  });
                  controller.start();
                },
                child: const Text("ตกลง"),
              )
            ],
          );
        },
      );

    }

  }

  void onDetectBarcode(BarcodeCapture barcodeCapture) {

    if (scanned) return;

    for (final barcode in barcodeCapture.barcodes) {

      final String? code = barcode.rawValue ?? barcode.displayValue;

      print("SCAN RESULT = $code");
      print("FORMAT = ${barcode.format}");

      if (code != null && code.isNotEmpty) {

        setState(() {
          scanned = true;
        });

        controller.stop();

        Vibration.vibrate(duration: 150);

        checkAsset(code.trim());

        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color(0xff4F6F52),
        foregroundColor: Colors.white,
        title: const Text("Scan QR / Barcode"),

        actions: [

          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () {
              controller.toggleTorch();
            },
          ),

          IconButton(
            icon: const Icon(Icons.flip_camera_android),
            onPressed: () {
              controller.switchCamera();
            },
          ),

        ],
      ),

      body: Stack(
        children: [

          /// CAMERA
          MobileScanner(
            controller: controller,
            onDetect: onDetectBarcode,
          ),

          /// DARK OVERLAY
          Container(
            color: Colors.black.withOpacity(0.4),
          ),

          /// SCAN FRAME
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          /// LASER
          Center(
            child: AnimatedBuilder(
              animation: laserAnimation,
              builder: (context, child) {

                return Transform.translate(
                  offset: Offset(0, laserAnimation.value),
                  child: Container(
                    width: 250,
                    height: 2,
                    color: Colors.red,
                  ),
                );

              },
            ),
          ),

          /// TEXT
          const Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Text(
              "วาง QR Code หรือ Barcode ในกรอบ",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),

        ],
      ),
    );
  }
}