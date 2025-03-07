import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Rewards extends StatelessWidget {
  const Rewards({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rewards',
          style: GoogleFonts.montserrat(),
        ),
      ),
    );
  }
}
