import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vibration/vibration.dart';

class QRScanScreenAdd extends StatefulWidget {
  const QRScanScreenAdd({super.key});

  @override
  State<QRScanScreenAdd> createState() => _QRScanScreenAddState();
}

class _QRScanScreenAddState extends State<QRScanScreenAdd>
    with SingleTickerProviderStateMixin {
  bool scanned = false;

  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  void onDetectBarcode(BarcodeCapture capture) {
    if (scanned) return;

    final Barcode barcode = capture.barcodes.first;

    /// ใช้ rawValue เพื่อให้ได้ค่าบาร์โค้ดจริง
    String? code = barcode.rawValue;

    if (code != null) {
      /// ลบเครื่องหมาย * ที่หัวท้าย
      code = code.replaceAll("*", "").trim();

      scanned = true;

      controller.stop();

      Vibration.vibrate(duration: 150);

      print("SCAN RESULT = $code");

      Navigator.pop(context, code);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff4F6F52),
        foregroundColor: Colors.white,
        title: const Text("Scan QR / Barcode"),

        actions: [
          /// เปิดไฟแฟลช
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () {
              controller.toggleTorch();
            },
          ),

          /// สลับกล้อง
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
          MobileScanner(controller: controller, onDetect: onDetectBarcode),

          /// DARK OVERLAY
          Container(color: Colors.black.withOpacity(0.4)),

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

          /// TEXT GUIDE
          const Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Text(
              "วาง QR Code หรือ Barcode ในกรอบ",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
