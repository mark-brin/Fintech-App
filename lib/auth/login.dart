import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:fintech_app/auth/signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fintech_app/common/widgets.dart';
import 'package:fintech_app/state/authstate.dart';
import 'package:fintech_app/dashboard/dashboard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignIn extends StatefulWidget {
  final VoidCallback? loginCallback;
  const SignIn({super.key, this.loginCallback});
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  late CustomLoader loader;
  bool isPasswordVisible = false;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    loader = CustomLoader();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<String?> fetchUserEmail() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/users/1'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['email'];
    } else {
      throw Exception('Failed to load user');
    }
  }

  static bool validateEmail(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    var status = regExp.hasMatch(email);
    return status;
  }

  static bool validateCredentials(
      BuildContext context, String? email, String? password) {
    if (email == null || email.isEmpty) {
      SnackBar(content: Text('Please enter email id'));
      return false;
    } else if (password == null || password.isEmpty) {
      SnackBar(content: Text('Please enter password'));
      return false;
    } else if (password.length < 8) {
      SnackBar(content: Text('Password must be 8 character long'));
      return false;
    }
    var status = validateEmail(email);
    if (!status) {
      SnackBar(content: Text('Please enter valid email id'));
      return false;
    }
    return true;
  }

  void signin() async {
    var auth = Provider.of<AuthenticationState>(context, listen: false);
    if (auth.isBusy) {
      return;
    }
    loader.showLoader(context);
    var isValid = validateCredentials(
      context,
      emailController.text,
      passwordController.text,
    );
    if (isValid) {
      auth
          .signIn(
        context: context,
        emailController.text,
        passwordController.text,
      )
          .then(
        (status) {
          if (auth.user != null) {
            loader.hideLoader();
            Navigator.pop(context);
            widget.loginCallback!();
          } else {
            loader.hideLoader();
          }
        },
      );
    } else {
      loader.hideLoader();
    }
  }

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthenticationState>(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF334D8F), Color(0xFF1A2747)],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          FontAwesomeIcons.wallet,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: Text(
                        'Welcome Back',
                        style: GoogleFonts.montserrat(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Sign in to continue to your account',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Text(
                      'Email',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: emailController,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                          border: InputBorder.none,
                          hintText: 'Enter your email',
                          hintStyle: GoogleFonts.montserrat(
                            color: Colors.white.withOpacity(0.5),
                          ),
                          prefixIcon: Icon(
                            FontAwesomeIcons.envelope,
                            color: Colors.white.withOpacity(0.7),
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Password',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                          border: InputBorder.none,
                          hintText: 'Enter your password',
                          hintStyle: GoogleFonts.montserrat(
                            color: Colors.white.withOpacity(0.5),
                          ),
                          prefixIcon: Icon(
                            size: 18,
                            FontAwesomeIcons.lock,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              size: 18,
                              isPasswordVisible
                                  ? FontAwesomeIcons.eyeSlash
                                  : FontAwesomeIcons.eye,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DashBoard(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.montserrat(
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      height: 55,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: isLoading ? null : signin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF334D8F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? CircularProgressIndicator(
                                color: Color(0xFF334D8F),
                              )
                            : Text(
                                'SIGN IN',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: GoogleFonts.montserrat(
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUp(
                                  loginCallback: auth.getCurrentUser,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Or sign in with',
                        style: GoogleFonts.montserrat(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(FontAwesomeIcons.google),
                        SizedBox(width: 20),
                        _buildSocialButton(FontAwesomeIcons.apple),
                        SizedBox(width: 20),
                        _buildSocialButton(FontAwesomeIcons.facebook),
                      ],
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon, size: 24, color: Colors.white),
    );
  }
}
