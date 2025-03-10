import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserDetail extends StatelessWidget {
  final String altText;
  final double fontSize;
  final Future<String> detail;
  const UserDetail({
    super.key,
    required this.detail,
    required this.altText,
    required this.fontSize,
  });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: detail,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            altText,
            style: GoogleFonts.montserrat(
              fontSize: fontSize,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        } else if (snapshot.hasData) {
          return Text(
            '${snapshot.data}',
            style: GoogleFonts.montserrat(
              fontSize: fontSize,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        } else {
          return Text(
            altText,
            style: GoogleFonts.montserrat(
              fontSize: fontSize,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        }
      },
    );
  }
}
