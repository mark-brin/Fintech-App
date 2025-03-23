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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Color(0xFF334D8F),
        elevation: 0,
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
            _buildProfileHeader(),
            FutureBuilder<Map<String, dynamic>>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(
                        color: Color(0xFF334D8F),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return _buildErrorState(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  final user = snapshot.data!;
                  final String name =
                      '${user['firstName']} ${user['lastName']}';
                  final String phone = user['phone'];
                  final String email = user['email'];
                  final String qrData =
                      'Name: $name\nPhone: $phone\nEmail: $email';

                  return Column(
                    children: [
                      _buildProfileDetails(name, phone, email),
                      _buildQRCodeSection(qrData),
                      _buildActionButtons(),
                    ],
                  );
                } else {
                  return _buildErrorState('No user data available');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
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
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
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
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.camera,
                      color: Color(0xFF334D8F),
                      size: 18,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
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

  Widget _buildProfileDetails(String name, String phone, String email) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProfileDetailItem(
            FontAwesomeIcons.user,
            'Full Name',
            name,
            Colors.blue[600]!,
          ),
          Divider(height: 30),
          _buildProfileDetailItem(
            FontAwesomeIcons.phone,
            'Phone Number',
            phone,
            Colors.green[600]!,
          ),
          Divider(height: 30),
          _buildProfileDetailItem(
            FontAwesomeIcons.envelope,
            'Email Address',
            email,
            Colors.red[600]!,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetailItem(
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
          child: Icon(
            icon,
            color: color,
            size: 18,
          ),
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
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            FontAwesomeIcons.penToSquare,
            color: Colors.grey[400],
            size: 16,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildQRCodeSection(String qrData) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.qrcode,
                color: Color(0xFF334D8F),
                size: 20,
              ),
              SizedBox(width: 10),
              Text(
                'My QR Code',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
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
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: QrImageView(
              size: 200,
              data: qrData,
              version: QrVersions.auto,
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF334D8F),
              errorCorrectionLevel: QrErrorCorrectLevel.H,
              embeddedImage: AssetImage('assets/app_icon.png'),
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: Size(40, 40),
              ),
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

  Widget _buildActionButtons() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          _buildActionButton(
            'Share Profile',
            FontAwesomeIcons.shareNodes,
            Colors.blue[600]!,
          ),
          SizedBox(height: 15),
          _buildActionButton(
            'Privacy Settings',
            FontAwesomeIcons.lock,
            Colors.green[600]!,
          ),
          SizedBox(height: 15),
          _buildActionButton(
            'Help & Support',
            FontAwesomeIcons.circleQuestion,
            Colors.orange[600]!,
          ),
          SizedBox(height: 15),
          _buildActionButton(
            'Logout',
            FontAwesomeIcons.rightFromBracket,
            Colors.red[600]!,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
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
          child: Icon(
            icon,
            color: color,
            size: 18,
          ),
        ),
        title: Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        trailing: Icon(
          FontAwesomeIcons.chevronRight,
          color: Colors.grey[400],
          size: 16,
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          Icon(
            FontAwesomeIcons.circleExclamation,
            color: Colors.red[400],
            size: 50,
          ),
          SizedBox(height: 20),
          Text(
            'Error Loading Profile',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 10),
          Text(
            message,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                futureUser = fetchUserData();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF334D8F),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Try Again',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
