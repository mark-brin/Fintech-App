import 'dart:io';
import 'package:clearpay/state/authstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:clearpay/profile/paymentProfile.dart';
import 'package:provider/provider.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});
  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  String? userId;
  String result = '';
  double pageIndex = 0;
  bool isFound = false;
  bool isScanning = true;
  GlobalKey globalKey = GlobalKey();
  late PageController pageController;
  final GlobalKey qrKey = GlobalKey();
  MobileScannerController? scannerController;
  @override
  void initState() {
    super.initState();
    pageController = PageController()..addListener(pageListener);
    scannerController = MobileScannerController(
      torchEnabled: false,
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.normal,
    );
  }

  @override
  void dispose() {
    pageController.removeListener(pageListener);
    pageController.dispose();
    scannerController?.dispose();
    super.dispose();
  }

  void pageListener() {
    setState(() {
      pageIndex = pageController.page!;
    });
  }

  void resetScanner() {
    setState(() {
      isFound = false;
      isScanning = true;
    });
  }

  void handleDetectedBarcode(BarcodeCapture capture) {
    if (isFound) {
      return;
    }

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? rawValue = barcode.rawValue;
      if (rawValue == null) continue;

      setState(() {
        result = rawValue;
      });

      if (rawValue.startsWith("upi://pay?")) {
        isFound = true;
        scannerController?.stop();
        Navigator.pop(context);
      } else if (rawValue.contains("clearpay/profile/")) {
        isFound = true;
        scannerController?.stop();

        var parts = rawValue.split("/");
        if (parts.length >= 4) {
          var userId = parts[2];
          var displayName = parts[3];

          var auth = Provider.of<AuthState>(context, listen: false);
          if (userId == auth.userModel!.userId) {
            setState(() {
              isFound = false;
            });
            scannerController?.start();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("You cannot send money to yourself")),
            );
          } else {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentProfile(
                  userId: userId,
                  payeeName: displayName,
                  userName: auth.user!.displayName!,
                ),
              ),
              //MaterialPageRoute(
              //  builder: (context) => PaymentScreen(
              //    userId: userId,
              //    payeeName: displayName,
              //    userName: state.user!.displayName!,
              //  ),
              //),
            );
          }
        } else {
          setState(() {
            isFound = false;
          });
          scannerController?.start();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid QR code format")),
          );
        }
      }
    }
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> capturePng() async {
    try {
      showErrorMessage("QR code captured successfully!");
    } catch (e) {
      showErrorMessage("Failed to capture QR code: ${e.toString()}");
    }
  }

  Future<File> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(
      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Scan QR',
          style: GoogleFonts.montserrat(
            color: Colors.grey[800],
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            MobileScanner(
              key: qrKey,
              controller: scannerController,
              onDetect: handleDetectedBarcode,
            ),
            QRScannerOverlay(
              borderWidth: 10,
              borderRadius: 10,
              borderLength: 30,
              borderColor: Colors.blue.shade600,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
            if (!isFound)
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Text(
                  'Align QR code within the frame',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        blurRadius: 3,
                        offset: Offset(0, 1),
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              bottom: 100,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.8),
                ),
                child: IconButton(
                  icon: Icon(
                    scannerController?.torchEnabled ?? false
                        ? Icons.flash_on
                        : Icons.flash_off,
                    color: Colors.grey[800],
                  ),
                  onPressed: () {
                    scannerController?.toggleTorch();
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QRScannerOverlay extends StatelessWidget {
  const QRScannerOverlay({
    super.key,
    required this.borderColor,
    required this.borderRadius,
    required this.borderLength,
    required this.borderWidth,
    required this.cutOutSize,
  });

  final Color borderColor;
  final double borderRadius;
  final double borderLength;
  final double borderWidth;
  final double cutOutSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Center(
                child: Container(
                  height: cutOutSize,
                  width: cutOutSize,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            width: cutOutSize,
            height: cutOutSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: borderColor, width: borderWidth),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: borderLength,
                    height: borderLength,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: borderColor, width: borderWidth),
                        left: BorderSide(
                          color: borderColor,
                          width: borderWidth,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: borderLength,
                    height: borderLength,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: borderColor, width: borderWidth),
                        right: BorderSide(
                          color: borderColor,
                          width: borderWidth,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: borderLength,
                    height: borderLength,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: borderColor,
                          width: borderWidth,
                        ),
                        left: BorderSide(
                          color: borderColor,
                          width: borderWidth,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: borderLength,
                    height: borderLength,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: borderColor,
                          width: borderWidth,
                        ),
                        right: BorderSide(
                          color: borderColor,
                          width: borderWidth,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
