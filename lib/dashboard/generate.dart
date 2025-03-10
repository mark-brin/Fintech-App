// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fintech_app/state/appstate.dart';

class GenerateQR extends StatelessWidget {
  final String? userId;
  const GenerateQR({super.key, this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate QR', style: GoogleFonts.montserrat()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.pop();
            //var app = Provider.of<AppState>(context, listen: false);
            //app.pageController.animateToPage(
            //  0,
            //  curve: Curves.easeInOut,
            //  duration: Duration(milliseconds: 300),
            //);
            //app.setPageIndex = 0;
          },
        ),
      ),
      body: Container(
        color: Colors.black,
        // color: Theme.of(context).dividerColor.withOpacity(.2),
        alignment: Alignment.center,
        child: InkWell(
          onTap: () {},
          child: RepaintBoundary(
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff07B7A6),
                      border: Border.all(
                        width: 4,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(22),
                    child: QrImageView(
                      data: "fintech_app/${userId ?? 'default_id'}",
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: Size(60, 60),
                      ),
                      backgroundColor: Color(0xff07B7A6),
                      version: QrVersions.auto,
                      size: MediaQuery.of(context).size.width * .7,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
