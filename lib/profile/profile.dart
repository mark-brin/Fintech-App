import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fintech_app/state/appstate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> futureUser;
  final String apiUrl = 'https://dummyjson.com/users/1';

  @override
  void initState() {
    super.initState();
    futureUser = fetchUserData();
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            var app = Provider.of<AppState>(context, listen: false);
            app.pageController.animateToPage(
              0,
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: 300),
            );
            app.setPageIndex = 0;
          },
        ),
        title: Text(
          'My Details',
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                //Navigator.pop(context);
                var app = Provider.of<AppState>(context, listen: false);
                app.pageController.animateToPage(
                  0,
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 300),
                );
                app.setPageIndex = 0;
              },
              icon: Icon(FontAwesomeIcons.house, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(radius: 75),
            TextButton(
              onPressed: () {},
              child: Text('Update Photo', style: GoogleFonts.montserrat()),
            ),
            SizedBox(height: 15),
            FutureBuilder<Map<String, dynamic>>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final user = snapshot.data!;
                  final String name =
                      '${user['firstName']} ${user['lastName']}';
                  final String phone = user['phone'];
                  final String email = user['email'];
                  final String qrData =
                      'Name: $name\nPhone: $phone\nEmail: $email';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Name: $name',
                          style: GoogleFonts.montserrat(fontSize: 15),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Phone: $phone',
                          style: GoogleFonts.montserrat(fontSize: 15),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Email: $email',
                          style: GoogleFonts.montserrat(fontSize: 15),
                        ),
                      ),
                      SizedBox(height: 35),
                      Center(
                        child: QrImageView(
                          size: 200,
                          data: qrData,
                          version: QrVersions.auto,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Text('No user data available');
                }
              },
            ),
            TextButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.share),
                  SizedBox(width: 5),
                  Text('Share', style: GoogleFonts.montserrat()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
