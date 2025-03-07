import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:fintech_app/state/appstate.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:fintech_app/dashboard/generate.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});
  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  final GlobalKey qrKey = GlobalKey();
  late PageController pageController;
  double pageIndex = 0;
  bool isFound = false;
  GlobalKey globalKey = GlobalKey();
  BarcodeCapture? result;
  String? userId; // This will hold the userId fetched from the API

  @override
  void initState() {
    super.initState();
    pageController = PageController()..addListener(pageListener);
    fetchUserId(); // Fetch user data when the widget initializes
  }

  void pageListener() {
    setState(
      () {
        pageIndex = pageController.page!;
      },
    );
  }

  // Fetch user data from the DummyJSON API
  Future<void> fetchUserId() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/users/1'));
    if (response.statusCode == 200) {
      final user = jsonDecode(response.body);
      setState(() {
        userId = user['id'].toString(); // Store the user ID in a string
      });
    } else {
      throw Exception('Failed to load user data');
    }
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
              controller: pageController,
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return MobileScanner(
                    key: qrKey,
                    onDetect: (barcode) {
                      if (!isFound) {
                        setState(() {
                          result = barcode;
                        });

                        // Check if result.raw can be cast to a String before using contains
                        final rawValue = result?.raw as String?;
                        if (rawValue != null &&
                            rawValue.contains("fintech_app/profile/")) {
                          // var userId = rawValue.split("/")[2];
                          // Navigator.push(
                          //   context,
                          //   ProfilePage.getRoute(profileId: userId),
                          // );
                        }
                      }
                    },
                  );
                } else {
                  return GenerateQR(userId: userId, globalKey: globalKey);
                }
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
            _controls()
          ],
        ),
      ),
    );
  }

  Widget _controls() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 50,
        child: DotsIndicator(
          controller: pageController,
          color: Theme.of(context).colorScheme.onPrimary,
          itemCount: 2,
          onPageSelected: (int page) {
            pageController.animateToPage(
              page,
              duration: const Duration(milliseconds: 750),
              curve: Curves.ease,
            );
          },
        ),
      ),
    );
  }
}

class DotsIndicator extends AnimatedWidget {
  const DotsIndicator({
    super.key,
    required this.controller,
    required this.itemCount,
    required this.onPageSelected,
    this.color = Colors.white,
  }) : super(listenable: controller);
  final PageController controller;
  final int itemCount;
  final ValueChanged<int> onPageSelected;
  final Color color;
  static const double _kDotSize = 6.0;
  static const double _kMaxZoom = 1.5;
  static const double _kDotSpacing = 16.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return SizedBox(
      width: _kDotSpacing,
      child: Center(
        child: Material(
          color: color,
          type: MaterialType.circle,
          child: SizedBox(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
