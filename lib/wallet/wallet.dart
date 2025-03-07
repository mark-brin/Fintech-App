import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Wallet extends StatelessWidget {
  const Wallet({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wallet',
          style: GoogleFonts.montserrat(),
        ),
      ),
    );
  }
}
