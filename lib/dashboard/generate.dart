import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fintech_app/state/appstate.dart';
import 'package:fintech_app/state/authstate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GenerateQR extends StatelessWidget {
  final GlobalKey globalKey;
  const GenerateQR({super.key, required this.globalKey});
  String getEmailPrefix(BuildContext context) {
    var auth = Provider.of<AuthenticationState>(context);
    String email = auth.user!.email ?? '';
    int atIndex = email.indexOf('@');
    if (atIndex != -1) {
      return email.substring(0, atIndex);
    } else {
      return email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Generate QR',
          style: GoogleFonts.montserrat(
            color: Colors.grey[800],
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
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
        actions: [
          IconButton(
            icon: Icon(
              FontAwesomeIcons.ellipsisVertical,
              size: 20,
              color: Colors.grey[800],
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildQRHeader(),
            _buildQRCodeSection(context),
            _buildInfoSection(),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildQRHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Payment QR',
            style: GoogleFonts.montserrat(
              fontSize: 24,
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Share this QR code to receive payments directly to your account',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCodeSection(BuildContext context) {
    final auth = Provider.of<AuthenticationState>(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: () {},
        child: RepaintBoundary(
          key: globalKey,
          child: Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: Offset(0, 10),
                  color: Colors.black.withOpacity(0.08),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 2, color: Colors.blue.shade600),
                  ),
                  padding: EdgeInsets.all(15),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[600],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.all(20),
                          child: QrImageView(
                            version: QrVersions.auto,
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue.shade600,
                            data: "fintech_app/profile/${auth.userId}",
                            size: MediaQuery.of(context).size.width * .5,
                            errorCorrectionLevel: QrErrorCorrectLevel.H,
                            embeddedImageStyle: QrEmbeddedImageStyle(
                              size: Size(50, 50),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 2,
                              color: Colors.blue.shade600,
                            ),
                          ),
                          child: Icon(
                            size: 16,
                            FontAwesomeIcons.wallet,
                            color: Colors.blue[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.grey[200]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        size: 14,
                        FontAwesomeIcons.at,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${getEmailPrefix(context)}@ebixcash',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        size: 14,
                        FontAwesomeIcons.copy,
                        color: Colors.blue[600],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          _buildInfoItem(
            'Secure Payments',
            'This QR code is encrypted and secure for transactions',
            FontAwesomeIcons.shieldHalved,
          ),
          SizedBox(height: 17),
          _buildInfoItem(
            'Instant Notification',
            'Get notified instantly when someone pays you',
            FontAwesomeIcons.bell,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String description, IconData icon) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue.shade600.withOpacity(0.1),
          ),
          child: Icon(icon, size: 18, color: Colors.blue[600]),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.shareNodes, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Share QR',
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue[600],
                side: BorderSide(color: Colors.blue.shade600),
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.download, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Download',
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
