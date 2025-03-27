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
        ],
      ),
    );
  }

  Widget body(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF334D8F), Color(0xFF4A6FD1)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  AppBar(
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
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UserDetail(
                          fontSize: 27,
                          altText: 'User',
                          detail: getName(),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                child: Icon(
                                  FontAwesomeIcons.user,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'UPI ID: **********@ebixcash',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    FutureBuilder<String>(
                                      future: getEmail(),
                                      builder: (context, snapshot) {
                                        return Text(
                                          snapshot.data ?? 'Loading...',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            color:
                                                Colors.white.withOpacity(0.7),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: 5),
                                    FutureBuilder<String>(
                                      future: getPhone(),
                                      builder: (context, snapshot) {
                                        return Text(
                                          snapshot.data ?? 'Loading...',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            color:
                                                Colors.white.withOpacity(0.7),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildQuickActionCard(
                        context,
                        FontAwesomeIcons.wallet,
                        'My Wallet',
                        Colors.blue[700]!,
                        1,
                      ),
                      buildQuickActionCard(
                        context,
                        FontAwesomeIcons.clockRotateLeft,
                        'Transactions',
                        Colors.purple[700]!,
                        3,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Services',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 15),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      _buildServiceCard(
                          context,
                          FontAwesomeIcons.moneyBill1Wave,
                          'Pay Money',
                          Colors.green[600]!,
                          5),
                      _buildServiceCard(context, FontAwesomeIcons.sackDollar,
                          'Request Money', Colors.orange[600]!, 6),
                      _buildServiceCard(context, FontAwesomeIcons.userCheck,
                          'Approvals', Colors.purple[600]!, 7),
                      _buildServiceCard(context, FontAwesomeIcons.file,
                          'Mandates', Colors.blue[600]!, 8),
                      _buildServiceCard(context, FontAwesomeIcons.qrcode,
                          'Scan QR', Colors.red[600]!, 9),
                      _buildServiceCard(
                          context,
                          FontAwesomeIcons.mobileScreenButton,
                          'Generate QR',
                          Colors.teal[600]!,
                          10),
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

  Widget buildQuickActionCard(BuildContext context, IconData icon, String label,
      Color color, int pageIndex) {
    return InkWell(
      onTap: () {
        var app = Provider.of<AppState>(context, listen: false);
        app.setPageIndex = pageIndex;
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        width: MediaQuery.of(context).size.width / 2.35,
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
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            SizedBox(width: 10.5),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, IconData icon, String title,
      Color color, int pageIndex) {
    return InkWell(
      onTap: () {
        var app = Provider.of<AppState>(context, listen: false);
        app.setPageIndex = pageIndex;
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
