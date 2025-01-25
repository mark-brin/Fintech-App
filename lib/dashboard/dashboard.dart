import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:fintech_app/common/sidebar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});
  Future<String> getName() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/users/1'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['firstName'];
    } else {
      throw Exception('Failed to load user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.5,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 2.5,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  'https://images.pexels.com/photos/30210691/pexels-photo-30210691/free-photo-of-majestic-mountain-landscape-in-north-macedonia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 130,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder<String>(
                              future: getName(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text(
                                    'User',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (snapshot.hasData) {
                                  return Text(
                                    '${snapshot.data}',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    'User',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                              },
                            ),
                            Text(
                              'UPI ID',
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '',
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '',
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        CircleAvatar(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    title: FutureBuilder<String>(
                      future: getName(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                            'Welcome, User',
                            style: GoogleFonts.montserrat(
                              fontSize: 23,
                              color: Colors.white,
                            ),
                          );
                        } else if (snapshot.hasData) {
                          return Text(
                            'Welcome, ${snapshot.data}',
                            style: GoogleFonts.montserrat(
                              fontSize: 23,
                              color: Colors.white,
                            ),
                          );
                        } else {
                          return Text(
                            'Welcome, User',
                            style: GoogleFonts.montserrat(
                              fontSize: 23,
                              color: Colors.white,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    actionButton(context, FontAwesomeIcons.user, 'My Wallet'),
                    actionButton(
                        context, FontAwesomeIcons.wallet, 'Transactions'),
                  ],
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    rowButton(FontAwesomeIcons.moneyBill1Wave, 'Pay Money'),
                    rowButton(FontAwesomeIcons.sackDollar, 'Request\n Money'),
                    rowButton(FontAwesomeIcons.userCheck, 'Approve\n to Pay'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    rowButton(FontAwesomeIcons.file, 'Mandates'),
                    rowButton(FontAwesomeIcons.qrcode, 'Scan\n & Pay'),
                    rowButton(
                        FontAwesomeIcons.mobileScreenButton, 'Generate QR'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget actionButton(BuildContext context, IconData icon, String title) {
    return TextButton(
      onPressed: () {},
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 0.5, color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(5, 5),
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Icon(icon), Text(title)],
        ),
      ),
    );
  }

  Widget rowButton(IconData icon, String title) {
    return Container(
      width: 113,
      height: 113,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 0.5, color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(5, 5),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.purple),
          SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(fontSize: 10, color: Colors.purple),
          )
        ],
      ),
    );
  }
}
