import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fintech_app/auth/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fintech_app/auth/usermodel.dart';
import 'package:fintech_app/state/authstate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF334D8F), Color(0xFF1A2747)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Account',
                  style: GoogleFonts.montserrat(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Sign up to get started!',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 40),
                buildTextField(
                  label: 'Full Name',
                  controller: nameController,
                  icon: FontAwesomeIcons.user,
                ),
                SizedBox(height: 20),
                buildTextField(
                  label: 'Email',
                  controller: emailController,
                  icon: FontAwesomeIcons.envelope,
                ),
                SizedBox(height: 20),
                buildTextField(
                  isPassword: true,
                  label: 'Password',
                  icon: FontAwesomeIcons.lock,
                  controller: passwordController,
                  isPasswordVisible: isPasswordVisible,
                  onVisibilityToggle: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
                SizedBox(height: 20),
                buildTextField(
                  controller: confirmPasswordController,
                  label: 'Confirm Password',
                  icon: FontAwesomeIcons.lock,
                  isPassword: true,
                  isPasswordVisible: isConfirmPasswordVisible,
                  onVisibilityToggle: () {
                    setState(() {
                      isConfirmPasswordVisible = !isConfirmPasswordVisible;
                    });
                  },
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF334D8F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'SIGN UP',
                      style: GoogleFonts.montserrat(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: GoogleFonts.montserrat(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                        );
                      },
                      child: Text(
                        'Sign In',
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
                    'Or sign up with',
                    style: GoogleFonts.montserrat(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildSocialButton(FontAwesomeIcons.google),
                    SizedBox(width: 20),
                    buildSocialButton(FontAwesomeIcons.apple),
                    SizedBox(width: 20),
                    buildSocialButton(FontAwesomeIcons.facebook),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onVisibilityToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        style: GoogleFonts.montserrat(
          fontSize: 16,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: InputBorder.none,
          labelText: label,
          labelStyle: GoogleFonts.montserrat(
            color: Colors.white.withOpacity(0.7),
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.white.withOpacity(0.7),
            size: 18,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    size: 18,
                    isPasswordVisible
                        ? FontAwesomeIcons.eyeSlash
                        : FontAwesomeIcons.eye,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  onPressed: onVisibilityToggle,
                )
              : null,
        ),
      ),
    );
  }

  Widget buildSocialButton(IconData icon) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        icon,
        size: 24,
        color: Colors.white,
      ),
    );
  }

  void signUp() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    final userModel = UserModel(
      displayName: nameController.text,
      email: emailController.text,
      createdAt: DateTime.now().toUtc().toString(),
    );
    final authState = Provider.of<AuthenticationState>(context, listen: false);
    setState(() {});
    authState
        .signUp(userModel, context: context, password: passwordController.text)
        .then((userId) {
      if (userId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account created! Please verify your email')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create account. Please try again.'),
          ),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    }).whenComplete(() {
      setState(() {});
    });
  }
}
