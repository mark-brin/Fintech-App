import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fintech_app/wallet/wallet.dart';
import 'package:fintech_app/common/navbar.dart';
import 'package:fintech_app/dashboard/scan.dart';
import 'package:fintech_app/common/sidebar.dart';
import 'package:fintech_app/state/appstate.dart';
import 'package:fintech_app/rewards/rewards.dart';
import 'package:fintech_app/profile/profile.dart';
import 'package:fintech_app/state/authstate.dart';
import 'package:fintech_app/dashboard/request.dart';
import 'package:fintech_app/common/mediaplayer.dart';
import 'package:fintech_app/dashboard/generate.dart';
import 'package:fintech_app/dashboard/mandates.dart';
import 'package:fintech_app/dashboard/paymoney.dart';
import 'package:fintech_app/dashboard/approvals.dart';
import 'package:fintech_app/transactions/transactions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

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
    final GlobalKey globalKey = GlobalKey();
    return Scaffold(
      drawer: Sidebar(),
      bottomNavigationBar: MainNavBar(),
      body: Stack(
        children: [
          Consumer<AppState>(
            builder: (context, appState, child) {
              return Consumer<AuthenticationState>(
                builder: (context, auth, _) {
                  final List<Widget> pages = [
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
                    GenerateQR(globalKey: globalKey)
                  ];
                  return PageView(
                    children: pages,
                    controller: appState.pageController,
                    onPageChanged: (index) {
                      appState.setPageIndex = index;
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget body(BuildContext context) {
    var auth = Provider.of<AuthenticationState>(context);
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
                      'Welcome!',
                      style: GoogleFonts.montserrat(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auth.user!.userMetadata!['displayName'] ??
                              'Full Name',
                          style: GoogleFonts.montserrat(
                            fontSize: 27,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
                                  size: 30,
                                  FontAwesomeIcons.user,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'UPI ID: ${getEmailPrefix(context)}@ebixcash',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      auth.user!.email ?? 'Loading...',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      auth.user!.phone == ''
                                          ? '+91 999-999-9999'
                                          : auth.user!.phone!,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.7),
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
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
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
                      buildServiceCard(context, FontAwesomeIcons.moneyBill1Wave,
                          'Pay Money', Colors.green[600]!, 5),
                      buildServiceCard(context, FontAwesomeIcons.sackDollar,
                          'Request Money', Colors.orange[600]!, 6),
                      buildServiceCard(context, FontAwesomeIcons.userCheck,
                          'Approvals', Colors.purple[600]!, 7),
                      buildServiceCard(context, FontAwesomeIcons.file,
                          'Mandates', Colors.blue[600]!, 8),
                      buildServiceCard(context, FontAwesomeIcons.qrcode,
                          'Scan QR', Colors.red[600]!, 9),
                      buildServiceCard(
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
            SizedBox(height: 15),
            MiniMediaplayer(),
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

  Widget buildServiceCard(BuildContext context, IconData icon, String title,
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
