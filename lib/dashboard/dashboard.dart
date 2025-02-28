import 'dart:convert';
import 'package:fintech_app/dashboard/approval.dart';
import 'package:fintech_app/dashboard/generate.dart';
import 'package:fintech_app/dashboard/mandates.dart';
import 'package:fintech_app/dashboard/paymoney.dart';
import 'package:fintech_app/dashboard/request.dart';
import 'package:fintech_app/dashboard/scan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fintech_app/common/navbar.dart';
import 'package:fintech_app/common/sidebar.dart';
import 'package:fintech_app/state/appstate.dart';
import 'package:fintech_app/dashboard/userDetail.dart';
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

  Future<String> getEmail() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/users/1'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['email'];
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<String> getPhone() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/users/1'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['phone'];
    } else {
      throw Exception('Failed to load user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      bottomNavigationBar: MainNavBar(),
      body: Stack(
        children: [
          getPage(context, Provider.of<AppState>(context).pageIndex),
          Positioned(
            left: 0,
            right: 0,
            bottom: 25,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      spreadRadius: 3,
                      offset: Offset(0, 1.5),
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: BottomNavBar(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget body(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      bottomNavigationBar: MainNavBar(),
      body: Stack(
        children: [
          // BottomNavBar(),
          Column(
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
                                height:
                                    MediaQuery.of(context).size.height / 2.5,
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
                      child: Container(
                        // width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  UserDetail(
                                    fontSize: 25,
                                    altText: 'User',
                                    detail: getName(),
                                  ),
                                  Text(
                                    'UPI ID:',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '**********@ebixcash',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  UserDetail(
                                    fontSize: 15,
                                    altText: 'Email',
                                    detail: getEmail(),
                                  ),
                                  SizedBox(height: 5),
                                  UserDetail(
                                    fontSize: 15,
                                    altText: '(Phone)',
                                    detail: getPhone(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).size.width / 1.3,
                              child: CircleAvatar(),
                            ),
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
                        title: Text(
                          'Welcome,',
                          style: GoogleFonts.montserrat(
                            fontSize: 23,
                            color: Colors.white,
                          ),
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
                        actionButton(
                          context,
                          FontAwesomeIcons.user,
                          'My Wallet',
                        ),
                        actionButton(
                          context,
                          FontAwesomeIcons.wallet,
                          'Transactions',
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        rowButton(
                          context,
                          FontAwesomeIcons.moneyBill1Wave,
                          'Pay Money',
                          PayMoney(),
                        ),
                        rowButton(
                          context,
                          FontAwesomeIcons.sackDollar,
                          'Request\n Money',
                          Requests(),
                        ),
                        rowButton(
                          context,
                          FontAwesomeIcons.userCheck,
                          'Approve\n to Pay',
                          Approvals(),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        rowButton(
                          context,
                          FontAwesomeIcons.file,
                          'Mandates',
                          Mandates(),
                        ),
                        rowButton(
                          context,
                          FontAwesomeIcons.qrcode,
                          'Scan\n & Pay',
                          ScanQR(),
                        ),
                        rowButton(
                          context,
                          FontAwesomeIcons.mobileScreenButton,
                          'Generate QR',
                          GenerateQR(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
          children: [
            Icon(icon, color: Colors.blue[600]),
            Text(
              title,
              style: GoogleFonts.montserrat(color: Colors.blue[600]),
            )
          ],
        ),
      ),
    );
  }

  Widget getPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        return body(context);
      case 1:
        return Container();
      case 2:
        return Container();
      case 3:
        return Container();
      default:
        return Container();
    }
  }

  Widget rowButton(
    BuildContext context,
    IconData icon,
    String title,
    Widget redirectWidget,
  ) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => redirectWidget),
        );
      },
      child: Container(
        width: 115,
        height: 115,
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
            Icon(icon, color: Colors.blue[600]),
            SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 10,
                color: Colors.blue[600],
              ),
            )
          ],
        ),
      ),
    );
  }
}
