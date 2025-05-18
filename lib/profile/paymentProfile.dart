import 'package:flutter/material.dart';
import 'package:clearpay/common/enums.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clearpay/dashboard/request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clearpay/transactions/paymentScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentProfile extends StatefulWidget {
  final String userId;
  final String userName;
  final String payeeName;
  const PaymentProfile({
    super.key,
    required this.userId,
    required this.userName,
    required this.payeeName,
  });
  @override
  State<PaymentProfile> createState() => _PaymentProfileState();
}

class _PaymentProfileState extends State<PaymentProfile> {
  bool isLoading = true;
  Map<String, dynamic>? userDetails;
  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(USERS)
          .doc(widget.userId)
          .get();
      if (userDoc.exists) {
        setState(() {
          userDetails = userDoc.data() as Map<String, dynamic>?;
          isLoading = false;
        });
      } else {
        setState(() {
          userDetails = null;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        userDetails = null;
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to fetch user details: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userDetails == null) {
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
        body: Center(
          child: Text(
            'User not found',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              color: Colors.grey[800],
            ),
          ),
        ),
      );
    }

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
            buildProfileHeader(),
            buildBasicUserInfo(),
            buildActionButtons(),
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
            CircleAvatar(
              radius: 75,
              backgroundColor: Colors.grey[300],
              backgroundImage: userDetails!['photoUrl'] != null
                  ? NetworkImage(userDetails!['photoUrl'])
                  : NetworkImage(
                      'https://images.pexels.com/photos/13221344/pexels-photo-13221344.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load',
                    ),
            ),
            SizedBox(height: 15),
            Text(
              userDetails!['displayName'] ?? 'Unknown User',
              style: GoogleFonts.montserrat(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBasicUserInfo() {
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
          SizedBox(height: 15),
          if (userDetails!['email'] != null)
            buildProfileDetailItem(
              FontAwesomeIcons.envelope,
              'Email',
              userDetails!['email'],
              Colors.green[600]!,
            ),
          if (userDetails!['email'] != null) SizedBox(height: 15),
          if (userDetails!['phoneNumber'] != null)
            buildProfileDetailItem(
              FontAwesomeIcons.phone,
              'Phone',
              userDetails!['phoneNumber'],
              Colors.orange[600]!,
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

  Widget buildActionButtons() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          buildActionButton(
            'Send Money',
            Colors.blue[600]!,
            FontAwesomeIcons.paperPlane,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(
                    userId: widget.userId,
                    userName: widget.userName,
                    payeeName: widget.payeeName,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 15),
          buildActionButton(
            'Request Payment',
            Colors.green[600]!,
            FontAwesomeIcons.handHoldingDollar,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Request()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildActionButton(
      String label, Color color, IconData icon, void Function() onpress) {
    return TextButton(
      onPressed: onpress,
      child: Container(
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
            size: 16,
            color: Colors.grey[400],
            FontAwesomeIcons.chevronRight,
          ),
        ),
      ),
    );
  }
}
