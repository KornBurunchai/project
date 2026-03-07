import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanScreenAdd extends StatefulWidget {
  const QRScanScreenAdd({super.key});

  @override
  State<QRScanScreenAdd> createState() => _QRScanScreenAddState();
}

class _QRScanScreenAddState extends State<QRScanScreenAdd> {

  bool scanned = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color(0xff4F6F52),
        foregroundColor: Colors.white,
        title: const Text("Scan QR / Barcode"),
      ),

      body: MobileScanner(

        onDetect: (barcodeCapture) {

          if (scanned) return;

          final barcodes = barcodeCapture.barcodes;

          for (final barcode in barcodes) {

            final String? code = barcode.rawValue;

            if (code != null) {

              scanned = true;

              /// ส่งค่า asset_code กลับไปหน้า Add
              Navigator.pop(context, code);

              break;
            }

          }

        },

      ),

    );

  }
}