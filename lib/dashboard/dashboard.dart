import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fintech_app/wallet/wallet.dart';
import 'package:fintech_app/common/navbar.dart';
import 'package:fintech_app/dashboard/scan.dart';
import 'package:fintech_app/common/sidebar.dart';
import 'package:fintech_app/state/appstate.dart';
import 'package:fintech_app/dashboard/user.dart';
import 'package:fintech_app/rewards/rewards.dart';
import 'package:fintech_app/profile/profile.dart';
import 'package:fintech_app/dashboard/request.dart';
import 'package:fintech_app/dashboard/generate.dart';
import 'package:fintech_app/dashboard/mandates.dart';
import 'package:fintech_app/dashboard/paymoney.dart';
import 'package:fintech_app/dashboard/approvals.dart';
import 'package:fintech_app/transactions/transactions.dart';
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
    final GlobalKey globalKey = GlobalKey();
    return Scaffold(
      drawer: Sidebar(),
      bottomNavigationBar: MainNavBar(),
      body: Stack(
        children: [
          Consumer<AppState>(
            builder: (context, appState, child) {
              return PageView(
                controller: appState.pageController,
                onPageChanged: (index) {
                  appState.setPageIndex = index;
                },
                children: [
                  body(context),
                  Wallet(),
                  Rewards(),
                  Transactions(),
                  ProfilePage(),
                  PayMoney(),
                  Requests(),
                  Approvals(),
                  Mandates(),
                  ScanQR(),
                  GenerateQR(globalKey: globalKey),
                ],
              );
            },
          ),
          //Positioned(
          //  left: 0,
          //  right: 0,
          //  bottom: 25,
          //  child: Padding(
          //    padding: EdgeInsets.symmetric(horizontal: 7.5),
          //    child: Container(
          //      decoration: BoxDecoration(
          //        borderRadius: BorderRadius.circular(50),
          //        boxShadow: [
          //          BoxShadow(
          //            blurRadius: 5,
          //            spreadRadius: 3,
          //            offset: Offset(0, 1.5),
          //            color: Colors.black.withOpacity(0.3),
          //          ),
          //        ],
          //      ),
          //      child: ClipRRect(
          //        borderRadius: BorderRadius.circular(50),
          //        child: BottomNavBar(),
          //      ),
          //    ),
          //  ),
          //),
        ],
      ),
    );
  }

  Widget body(BuildContext context) {
    return Scaffold(
      //drawer: Sidebar(),
      body: SingleChildScrollView(
        child: Column(
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
                                // gradient: LinearGradient(
                                //   begin: Alignment.topLeft,
                                //   end: Alignment.bottomRight,
                                //   colors: [
                                //     Colors.blue[800]!,
                                //     Colors.blue[500]!
                                //   ],
                                // ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    'https://images.pexels.com/photos/30210691/pexels-photo-30210691/free-photo-of-majestic-mountain-landscape-in-north-macedonia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
                                  ),
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
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
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UserDetail(
                                  fontSize: 28,
                                  altText: 'User',
                                  detail: getName(),
                                ),
                                Text(
                                  'UPI ID:',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '**********@ebixcash',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
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
                            child: CircleAvatar(
                              radius: 37.5,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              child: Icon(
                                size: 37.5,
                                FontAwesomeIcons.user,
                                color: Colors.white,
                              ),
                            ),
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
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
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
              height: MediaQuery.of(context).size.height / 1.5,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Quick Actions',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      actionButton(
                        context,
                        FontAwesomeIcons.wallet,
                        'My Wallet',
                        1,
                      ),
                      actionButton(
                        context,
                        FontAwesomeIcons.clockRotateLeft,
                        'Transactions',
                        3,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Services',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      rowButton(
                        context,
                        FontAwesomeIcons.moneyBill1Wave,
                        'Pay Money',
                        5,
                      ),
                      rowButton(
                        context,
                        FontAwesomeIcons.sackDollar,
                        'Request\n Money',
                        6,
                      ),
                      rowButton(
                        context,
                        FontAwesomeIcons.userCheck,
                        'Approve\n to Pay',
                        7,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      rowButton(
                        context,
                        FontAwesomeIcons.file,
                        'Mandates',
                        8,
                      ),
                      rowButton(
                        context,
                        FontAwesomeIcons.qrcode,
                        'Scan\n & Pay',
                        9,
                      ),
                      rowButton(
                        context,
                        FontAwesomeIcons.mobileScreenButton,
                        'Generate QR',
                        10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget actionButton(
      BuildContext context, IconData icon, String title, int pageIndex) {
    return TextButton(
      onPressed: () {
        var app = Provider.of<AppState>(context, listen: false);
        app.setPageIndex = pageIndex;
      },
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 0.5, color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              spreadRadius: 1,
              offset: Offset(0, 2),
              color: Colors.black.withOpacity(0.08),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.blue[600]),
            ),
            Text(
              title,
              style: GoogleFonts.montserrat(
                color: Colors.blue[600],
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget rowButton(
      BuildContext context, IconData icon, String title, int pageIndex) {
    return TextButton(
      onPressed: () {
        var app = Provider.of<AppState>(context, listen: false);
        app.setPageIndex = pageIndex;
      },
      child: Container(
        height: 100,
        width: MediaQuery.of(context).size.width / 3.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 0.5, color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              spreadRadius: 1,
              offset: Offset(0, 2),
              color: Colors.black.withOpacity(0.08),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.blue[600]),
            ),
            SizedBox(height: 7),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 11,
                color: Colors.blue[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
