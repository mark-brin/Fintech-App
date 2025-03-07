import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Transactions extends StatelessWidget {
  const Transactions({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transactions',
          style: GoogleFonts.montserrat(),
        ),
      ),
    );
  }
}
