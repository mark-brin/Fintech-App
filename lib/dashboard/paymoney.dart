import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fintech_app/state/appstate.dart';

class PayMoney extends StatelessWidget {
  const PayMoney({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pay Money',
          style: GoogleFonts.montserrat(),
        ),
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
    );
  }
}
