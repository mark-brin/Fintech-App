import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomLoader {
  static CustomLoader? customLoader;
  CustomLoader.createObject();
  factory CustomLoader() {
    if (customLoader != null) {
      return customLoader!;
    } else {
      customLoader = CustomLoader.createObject();
      return customLoader!;
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
    var text = "ClearPay";
    return Scaffold(
      body: Center(
        child: CustomScreenLoader(
          text: text,
          width: height,
          height: height,
          backgroundColor: backgroundColor,
        ),
      ),
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
    this.text = "ClearPay",
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
                ],
              ),
              SizedBox(width: 20),
              Text(
                'ClearPay',
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

class Search extends StatelessWidget implements PreferredSizeWidget {
  const Search({
    super.key,
    this.title,
    this.textController,
    this.onSearchChanged,
    this.onActionPressed,
    this.submitButtonText,
  });
  final Widget? title;
  final String? submitButtonText;
  final Function? onActionPressed;
  final ValueChanged<String>? onSearchChanged;
  final TextEditingController? textController;
  @override
  Size get preferredSize => Size.fromHeight(57);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 50,
      width: MediaQuery.of(context).size.width - 65,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackButton(color: Colors.black),
          Expanded(
            child: SizedBox(
              //width: 35,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Search by Name...",
                  border: InputBorder.none,
                ),
                onChanged: onSearchChanged,
                controller: textController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
