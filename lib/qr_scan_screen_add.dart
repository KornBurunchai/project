import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanScreenAdd extends StatelessWidget {
  const QRScanScreenAdd({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color(0xff4F6F52),
        foregroundColor: Colors.white,
        title: const Text("Scan QR Code"),
      ),

      body: MobileScanner(

        onDetect: (barcodeCapture) {

          final barcodes = barcodeCapture.barcodes;

          for (final barcode in barcodes) {

            final String? code = barcode.rawValue;

            if (code != null) {

              /// ส่งค่า asset_code กลับไปหน้า Add
              Navigator.pop(context, code);

            }

          }

        },

      ),

    );
  }
}