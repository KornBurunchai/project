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

          if(scanned) return;

          final barcode = barcodeCapture.barcodes.first;

          final String? code = barcode.rawValue;

          if(code != null){

            scanned = true;

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => AssetDetailScreen(assetCode: code),
              ),
            );

          }

        },

      ),
    );
  }
}