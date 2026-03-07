import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'asset_detail_screen.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  bool scanned = false;
  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff4F6F52),
        foregroundColor: Colors.white,
        title: const Text("Scan QR / Barcode"),
      ),

      body: MobileScanner(
        controller: controller,

        onDetect: (barcodeCapture) {
          if (scanned) return;

          final List<Barcode> barcodes = barcodeCapture.barcodes;

          for (final barcode in barcodes) {
            final String? code = barcode.rawValue;

            if (code != null) {
              scanned = true;

              controller.stop(); // หยุดกล้อง

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => AssetDetailScreen(assetCode: code),
                ),
              );

              break;
            }
          }
        },
      ),
    );
  }
}
