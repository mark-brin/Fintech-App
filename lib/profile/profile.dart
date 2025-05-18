import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clearpay/state/appstate.dart';
import 'package:clearpay/state/authstate.dart';
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
    var auth = Provider.of<AuthState>(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Color(0xFF334D8F),
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () {
        //     var app = Provider.of<AppState>(context, listen: false);
        //     app.pageController.animateToPage(
        //       0,
        //       curve: Curves.easeInOut,
        //       duration: Duration(milliseconds: 300),
        //     );
        //     app.setPageIndex = 0;
        //   },
        // ),
        title: Text(
          'My Profile',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                var app = Provider.of<AppState>(context, listen: false);
                app.pageController.animateToPage(
                  0,
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 300),
                );
                app.setPageIndex = 0;
              },
              icon: Icon(FontAwesomeIcons.house, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildProfileHeader(),
            Column(
              children: [
                buildProfileDetails(
                  auth.user!.displayName ?? 'Full Name',
                  auth.user?.phoneNumber == null
                      ? '+91 999-999-9999'
                      : auth.user!.phoneNumber!,
                  auth.user!.email!,
                ),
                buildQRCodeSection("clearpay/profile/${auth.userId}"),
                buildActionButtons(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF334D8F),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          children: [
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 4, color: Colors.white),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 2,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/men/1.jpg',
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        spreadRadius: 1,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      size: 18,
                      FontAwesomeIcons.camera,
                      color: Color(0xFF334D8F),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: Text(
                'Update Photo',
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
    );
  }

  Widget buildProfileDetails(String name, String phone, String email) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 1,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        children: [
          buildProfileDetailItem(
            FontAwesomeIcons.user,
            'Full Name',
            name,
            Colors.blue[600]!,
          ),
          Divider(height: 30),
          buildProfileDetailItem(
            FontAwesomeIcons.envelope,
            'Email Address',
            email,
            Colors.red[600]!,
          ),
        ],
      ),
    );
  }

  Widget buildProfileDetailItem(
      IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            size: 16,
            color: Colors.grey[400],
            FontAwesomeIcons.penToSquare,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget buildQRCodeSection(String qrData) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 1,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                size: 20,
                FontAwesomeIcons.qrcode,
                color: Color(0xFF334D8F),
              ),
              SizedBox(width: 10),
              Text(
                'My QR Code',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 1, color: Colors.grey[200]!),
            ),
            child: QrImageView(
              size: 200,
              data: qrData,
              version: QrVersions.auto,
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF334D8F),
              errorCorrectionLevel: QrErrorCorrectLevel.H,
              embeddedImage: AssetImage('assets/app_icon.png'),
              embeddedImageStyle: QrEmbeddedImageStyle(size: Size(40, 40)),
            ),
          ),
          SizedBox(height: 15),
          Text(
            'Scan this code to share your contact details',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildActionButtons() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          buildActionButton(
            'Share Profile',
            FontAwesomeIcons.shareNodes,
            Colors.blue[600]!,
          ),
          SizedBox(height: 15),
          buildActionButton(
            'Privacy Settings',
            FontAwesomeIcons.lock,
            Colors.green[600]!,
          ),
          SizedBox(height: 15),
          buildActionButton(
            'Help & Support',
            FontAwesomeIcons.circleQuestion,
            Colors.orange[600]!,
          ),
          SizedBox(height: 15),
          buildActionButton(
            'Logout',
            FontAwesomeIcons.rightFromBracket,
            Colors.red[600]!,
          ),
        ],
      ),
    );
  }

  Widget buildActionButton(String label, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 1,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        title: Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 15,
            color: Colors.grey[800],
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(
          color: Colors.grey[400],
          FontAwesomeIcons.chevronRight,
          size: 16,
        ),
        onTap: () {},
      ),
    );
  }
}
