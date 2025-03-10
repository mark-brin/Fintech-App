import 'dart:convert';
import 'package:fintech_app/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  @override
  void initState() {
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

  void signin() async {
    setState(() {
      isLoading = true;
    });

    try {
      final userEmail = await fetchUserEmail();
      if (userEmail == emailController.text &&
          passwordController.text == 'password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text('Login successful!'),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashBoard()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Invalid email! Please try again.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  'https://images.pexels.com/photos/4148472/pexels-photo-4148472.jpeg?auto=compress&cs=tinysrgb&w=600',
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'Get on the\npath to energy independence',
                      style: GoogleFonts.montserrat(
                        fontSize: 35,
                        wordSpacing: 3,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  entryField(context, 'Email', emailController, false),
                  SizedBox(height: 25),
                  entryField(context, 'Password', passwordController, true),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: signin,
                    child: Container(
                      height: 75,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        color: Color.fromARGB(255, 214, 232, 52),
                      ),
                      child: Text(
                        'LOG IN',
                        style: GoogleFonts.montserrat(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget entryField(
    BuildContext context,
    String title,
    TextEditingController controller,
    bool isPassword,
  ) {
    return Container(
      height: 75,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blue[100]!.withOpacity(0.75),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: title,
            border: InputBorder.none,
            hintStyle: GoogleFonts.montserrat(color: Colors.white),
          ),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
