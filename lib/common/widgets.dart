import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomLoader {
  static CustomLoader? _customLoader;
  CustomLoader._createObject();
  factory CustomLoader() {
    if (_customLoader != null) {
      return _customLoader!;
    } else {
      _customLoader = CustomLoader._createObject();
      return _customLoader!;
    }
  }

  OverlayState? _overlayState;
  OverlayEntry? _overlayEntry;

  _buildLoader() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return SizedBox(
          child: buildLoader(context),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        );
      },
    );
  }

  showLoader(context) {
    _overlayState = Overlay.of(context);
    _buildLoader();
    _overlayState!.insert(_overlayEntry!);
  }

  hideLoader() {
    try {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  buildLoader(BuildContext context, {Color? backgroundColor}) {
    backgroundColor ??= const Color(0xffa8a8a8).withOpacity(.5);
    var height = 150.0;
    var text = "Fintech App";
    return CustomScreenLoader(
      height: height,
      width: height,
      text: text,
      backgroundColor: backgroundColor,
    );
  }
}

class CustomScreenLoader extends StatelessWidget {
  final Color backgroundColor;
  final double height;
  final double width;
  final String text;
  const CustomScreenLoader({
    super.key,
    this.width = 30,
    this.height = 30,
    this.text = "Fintech App",
    this.backgroundColor = const Color(0xfff8f8f8),
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.all(50),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Platform.isIOS
                      ? CupertinoActivityIndicator(radius: 35)
                      : CircularProgressIndicator(strokeWidth: 2),
                  //Image.asset(
                  //  width: 35,
                  //  height: 35,
                  //  '',
                  //),
                ],
              ),
              SizedBox(width: 20),
              Text(
                'Fintech App',
                style: GoogleFonts.montserrat(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget loader() {
  if (Platform.isIOS) {
    return Center(child: CupertinoActivityIndicator());
  } else {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
      ),
    );
  }
}
