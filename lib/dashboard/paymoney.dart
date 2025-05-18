import 'package:clearpay/dashboard/payContact.dart';
import 'package:clearpay/dashboard/scan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clearpay/state/authstate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PayMoney extends StatelessWidget {
  const PayMoney({super.key});
  String getEmailPrefix(BuildContext context) {
    var auth = Provider.of<AuthState>(context);
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF334D8F),
        title: Text(
          'Pay Money',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildBalanceCard(context),
            SizedBox(height: 20),
            buildPaymentOptions(context),
            SizedBox(height: 20),
            buildRecentContacts(context),
            SizedBox(height: 20),
            // buildAmountSection(context),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomButton(context),
    );
  }

  Widget buildBalanceCard(BuildContext context) {
    var auth = Provider.of<AuthState>(context, listen: false);
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
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Balance',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '₹ ${auth.userModel!.balance}',
                  style: GoogleFonts.montserrat(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              'Payment ID: ${getEmailPrefix(context)}@ebixcash',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentOptions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Options',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildPaymentOptionItem(
                context,
                FontAwesomeIcons.qrcode,
                'Scan QR',
                Colors.purple[600]!,
                ScanQR(),
              ),
              buildPaymentOptionItem(
                context,
                FontAwesomeIcons.mobileScreen,
                'Payment ID',
                Colors.blue[600]!,
                Scaffold(),
              ),
              buildPaymentOptionItem(
                context,
                FontAwesomeIcons.addressBook,
                'Contacts',
                Colors.green[600]!,
                UserContactList(),
              ),
              buildPaymentOptionItem(
                context,
                FontAwesomeIcons.buildingColumns,
                'Bank',
                Colors.orange[600]!,
                Scaffold(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPaymentOptionItem(BuildContext context, IconData icon,
      String label, Color color, Widget buttonRoute) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => buttonRoute),
        );
      },
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRecentContacts(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Contacts',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Color(0xFF334D8F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                buildContactItem(context, 'John', 'D', Colors.blue[700]!),
                buildContactItem(context, 'Sarah', 'M', Colors.purple[700]!),
                buildContactItem(context, 'Mike', 'T', Colors.green[700]!),
                buildContactItem(context, 'Emma', 'R', Colors.orange[700]!),
                buildContactItem(context, 'Alex', 'K', Colors.red[700]!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContactItem(
      BuildContext context, String name, String initial, Color color) {
    return Container(
      margin: EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(width: 2, color: color.withOpacity(0.5)),
            ),
            child: Center(
              child: Text(
                initial,
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAmountSection(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter Amount',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 15),
          TextField(
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '₹ 0.00',
              hintStyle: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[400],
              ),
              prefixIcon: Icon(
                size: 20,
                color: Colors.grey[600],
                FontAwesomeIcons.indianRupeeSign,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  width: 2,
                  color: Color(0xFF334D8F),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Add Note (Optional)',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 10),
          TextField(
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.grey[800],
            ),
            decoration: InputDecoration(
              hintText: 'What\'s this payment for?',
              hintStyle: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.grey[400],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  width: 2,
                  color: Color(0xFF334D8F),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              buildQuickAmountChip('₹100'),
              SizedBox(width: 10),
              buildQuickAmountChip('₹500'),
              SizedBox(width: 10),
              buildQuickAmountChip('₹1000'),
              SizedBox(width: 10),
              buildQuickAmountChip('₹2000'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildQuickAmountChip(String amount) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: Color(0xFF334D8F).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 1,
            color: Color(0xFF334D8F).withOpacity(0.3),
          ),
        ),
        child: Text(
          amount,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334D8F),
          ),
        ),
      ),
    );
  }

  Widget buildBottomButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, -5),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF334D8F),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
        child: Text(
          'Proceed to Pay',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
