import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentProfile extends StatefulWidget {
  final String userId;
  const PaymentProfile({super.key, required this.userId});
  @override
  State<PaymentProfile> createState() => _PaymentProfileState();
}

class _PaymentProfileState extends State<PaymentProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 60,
        backgroundColor: Color(0xFF334D8F),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          'Payment Profile',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildBasicUserInfo(),
            _buildPaymentInfo(),
            _buildActionButtons(),
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
            CircleAvatar(
              radius: 75,
              backgroundColor: Colors.grey[300],
              backgroundImage: NetworkImage(
                'https://ui-avatars.com/api/?name=User&background=random',
              ),
            ),
            SizedBox(height: 15),
            Text(
              "User Profile",
              style: GoogleFonts.montserrat(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'User ID: ${widget.userId.substring(0, 8)}...',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicUserInfo() {
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
          _buildProfileDetailItem(
            FontAwesomeIcons.idBadge,
            'User ID',
            widget.userId,
            Colors.blue[600]!,
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
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfo() {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                size: 20,
                FontAwesomeIcons.wallet,
                color: Color(0xFF334D8F),
              ),
              SizedBox(width: 10),
              Text(
                'Payment Options',
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
            width: double.infinity,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFF334D8F).withOpacity(0.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Ready to make a payment to',
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: Color(0xFF334D8F),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'User ID: ${widget.userId.substring(0, 8)}...',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Color(0xFF334D8F),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
            'Send Money',
            FontAwesomeIcons.paperPlane,
            Colors.blue[600]!,
          ),
          SizedBox(height: 15),
          _buildActionButton(
            'Request Payment',
            FontAwesomeIcons.handHoldingDollar,
            Colors.green[600]!,
          ),
          SizedBox(height: 15),
          _buildActionButton(
            'Transaction History',
            FontAwesomeIcons.clockRotateLeft,
            Colors.purple[600]!,
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
}
