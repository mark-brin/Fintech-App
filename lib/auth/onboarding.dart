import 'package:fintech_app/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fintech_app/auth/wave.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.only(top: 60, bottom: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  end: Alignment.centerRight,
                  begin: Alignment.centerLeft,
                  colors: [Colors.blue.shade900, Colors.blue.shade400],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      headingText('CHANGE YOUR\n PERSPECTIVE IN STYLE', 25),
                      SizedBox(height: 10),
                      headingText(
                        'Change the quality of your appearance\n with gcommerc now!',
                        17,
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                      );
                    },
                    child: Container(
                      height: 85,
                      width: MediaQuery.of(context).size.width - 50,
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Continue',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 265,
            left: -150,
            right: -150,
            child: Transform.rotate(
              angle: -0.5,
              child: ClipPath(
                clipper: DiagonalWaveClipper(),
                child: Container(height: 400, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget headingText(String title, double fontSize) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.montserrat(
        fontSize: fontSize,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
