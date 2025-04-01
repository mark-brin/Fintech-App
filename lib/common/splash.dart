import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:fintech_app/common/enums.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fintech_app/state/authstate.dart';
import 'package:fintech_app/auth/onboarding.dart';
import 'package:fintech_app/dashboard/dashboard.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  int currentMessageIndex = 0;
  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late Animation<double> rotateAnimation;
  final List<String> loadingMessages = [
    "Securing connection...",
    "Loading your dashboard...",
    "Updating financial data...",
    "Almost there...",
  ];

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    rotateAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );

    controller.repeat(reverse: false);
    _startMessageCycle();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer();
    });
    super.initState();
  }

  void _startMessageCycle() {
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          currentMessageIndex =
              (currentMessageIndex + 1) % loadingMessages.length;
        });
        _startMessageCycle();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void timer() async {
    Future.delayed(Duration(seconds: 1)).then(
      (_) {
        var state = Provider.of<AuthenticationState>(context, listen: false);
        state.getCurrentUser();
      },
    );
  }

  Widget body() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF334D8F), Color(0xFF1A2747)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: rotateAnimation.value,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(25),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            //child: Image.asset(
                            //  width: 50,
                            //  height: 50,
                            //  'assets/images/icon-480.png',
                            //),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 50),
              FadeTransition(
                opacity: fadeAnimation,
                child: Text(
                  "Fintech App",
                  style: GoogleFonts.montserrat(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              SizedBox(height: 13),
              FadeTransition(
                opacity: fadeAnimation,
                child: Text(
                  "Secure Financial Solutions",
                  style: GoogleFonts.montserrat(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
              SizedBox(height: 60),
              SizedBox(
                width: 40,
                height: 40,
                child: Platform.isIOS
                    ? CupertinoActivityIndicator(
                        radius: 13,
                        color: Colors.white,
                      )
                    : CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
              ),
              SizedBox(height: 25),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: Text(
                  loadingMessages[currentMessageIndex],
                  key: ValueKey<int>(currentMessageIndex),
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthenticationState>(context, listen: false);
    return Scaffold(
      body: state.authStatus == AuthStatus.NOT_DETERMINED
          ? body()
          : state.authStatus == AuthStatus.NOT_LOGGED_IN
              ? OnboardingPage()
              : DashBoard(),
    );
  }
}
