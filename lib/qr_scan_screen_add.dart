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
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
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

    laserAnimation = Tween<double>(begin: -120, end: 120).animate(laserController);
  }

  @override
  void dispose() {
    controller.dispose();
    laserController.dispose();
    super.dispose();
  }

  void onDetectBarcode(BarcodeCapture barcodeCapture) {

    if (scanned) return;

    for (final barcode in barcodeCapture.barcodes) {

      final String? code = barcode.rawValue;

      if (code != null) {

        setState(() {
          scanned = true;
        });

        controller.stop();

        Vibration.vibrate(duration: 150);

        /// ส่งค่า asset_code กลับหน้า Add
        Navigator.pop(context, code);

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

          /// LASER LINE
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

          /// TEXT GUIDE
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