import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fintech_app/state/appstate.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:fintech_app/profile/paymentProfile.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});
  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  String? userId;
  final GlobalKey qrKey = GlobalKey();
  late PageController pageController;
  double pageIndex = 0;
  bool isFound = false;
  GlobalKey globalKey = GlobalKey();
  BarcodeCapture? result;

  @override
  void initState() {
    super.initState();
    pageController = PageController()..addListener(pageListener);
  }

  void pageListener() {
    setState(
      () {
        pageIndex = pageController.page!;
      },
    );
  }

  capturePng() async {}

  Future<File> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR', style: GoogleFonts.montserrat()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            var app = Provider.of<AppState>(context, listen: false);
            app.pageController.animateToPage(
              0,
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: 300),
            );
            app.setPageIndex = 0;
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PageView.builder(
              itemCount: 2,
              controller: pageController,
              itemBuilder: (BuildContext context, int index) {
                return MobileScanner(
                  key: qrKey,
                  onDetect: (barcode) {
                    if (!isFound) {
                      setState(() {
                        result = barcode;
                      });
                      final rawValue = result?.raw as String?;
                      if (rawValue != null &&
                          rawValue.contains("fintech_app/profile/")) {
                        try {
                          var userId = rawValue.split("/").last;
                          setState(() {
                            isFound = true;
                          });
                          Future.delayed(Duration(milliseconds: 500), () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentProfile(
                                  userId: userId,
                                ),
                              ),
                            ).then((_) {
                              setState(() {
                                isFound = false;
                              });
                            });
                          });
                        } catch (e) {
                          setState(() {
                            isFound = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Error processing QR code: ${e.toString()}",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
                );
              },
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedContainer(
                    duration: Duration(microseconds: 200),
                    child: pageIndex == 0
                        ? SizedBox.shrink()
                        : IconButton(
                            onPressed: () async {
                              if (pageIndex == 1) {
                                capturePng();
                              }
                            },
                            icon: Icon(
                              Icons.share_outlined,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
