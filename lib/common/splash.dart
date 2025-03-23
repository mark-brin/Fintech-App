import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fintech_app/auth/onboarding.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer();
    });
    super.initState();
  }

  void timer() async {
    Future.delayed(Duration(seconds: 1)).then(
      (_) {
        //var state = Provider.of<AuthState>(context, listen: false);
        //state.getCurrentUser();
      },
    );
  }

  Widget bodyMain() {
    double height = 150;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Container(
        height: height,
        width: height,
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
                children: [
                  Platform.isIOS
                      ? CupertinoActivityIndicator(radius: 35)
                      : CircularProgressIndicator(strokeWidth: 2.5),
                  Image.asset(
                    width: 35,
                    height: 35,
                    'assets/images/icon-480.png',
                  ),
                ],
              ),
              SizedBox(width: 15),
              Text(
                "Fintech App",
                style: TextStyle(
                  fontSize: 23.5,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
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
    //var state = Provider.of<AuthState>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: OnboardingPage(),
      //body: state.authStatus == AuthStatus.NOT_DETERMINED
      //    ? _body()
      //    : state.authStatus == AuthStatus.NOT_LOGGED_IN
      //        ? OnboardingPage()
      //        : DashBoard(),
    );
  }
}
