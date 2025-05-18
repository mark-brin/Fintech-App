import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clearpay/wallet/wallet.dart';
import 'package:clearpay/common/navbar.dart';
import 'package:clearpay/dashboard/scan.dart';
import 'package:clearpay/common/sidebar.dart';
import 'package:clearpay/state/appstate.dart';
import 'package:clearpay/rewards/rewards.dart';
import 'package:clearpay/state/authstate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clearpay/dashboard/request.dart';
import 'package:clearpay/dashboard/mandates.dart';
import 'package:clearpay/dashboard/generate.dart';
import 'package:clearpay/common/mediaplayer.dart';
import 'package:clearpay/dashboard/paymoney.dart';
import 'package:clearpay/dashboard/approvals.dart';
import 'package:clearpay/transactions/transactions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});
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
      drawer: Sidebar(),
      bottomNavigationBar: MainNavBar(),
      body: Stack(
        children: [
          Consumer<AppState>(
            builder: (context, appState, child) {
              return Consumer<AuthState>(
                builder: (context, auth, _) {
                  final List<Widget> pages = [
                    body(context),
                    Wallet(),
                    Rewards(),
                    Transactions(),
                    //ProfilePage(),
                    //PayMoney(),
                    //Requests(),
                    //Approvals(),
                    //Mandates(),
                    //ScanQR(),
                    //GenerateQR(globalKey: globalKey),
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
    final GlobalKey globalKey = GlobalKey();
    var auth = Provider.of<AuthState>(context);
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auth.user!.displayName ?? 'Full Name',
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
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Payment ID: ${getEmailPrefix(context)}@ebixcash',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      auth.user!.email ?? 'Loading...',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 11,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      auth.user?.phoneNumber == null
                                          ? '+91 999-999-9999'
                                          : auth.user!.phoneNumber!,
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
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
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
                        Wallet(),
                      ),
                      buildQuickActionCard(
                        context,
                        FontAwesomeIcons.clockRotateLeft,
                        'Transactions',
                        Colors.purple[700]!,
                        Transactions(),
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
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1.1,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      buildServiceCard(
                        context,
                        FontAwesomeIcons.moneyBill1Wave,
                        'Pay Money',
                        Colors.green[600]!,
                        PayMoney(),
                      ),
                      buildServiceCard(
                        context,
                        FontAwesomeIcons.sackDollar,
                        'Request Money',
                        Colors.orange[600]!,
                        Request(),
                      ),
                      buildServiceCard(
                        context,
                        FontAwesomeIcons.userCheck,
                        'Approvals',
                        Colors.purple[600]!,
                        Approvals(),
                      ),
                      buildServiceCard(
                        context,
                        FontAwesomeIcons.file,
                        'Mandates',
                        Colors.blue[600]!,
                        Mandates(),
                      ),
                      buildServiceCard(
                        context,
                        FontAwesomeIcons.qrcode,
                        'Scan QR',
                        Colors.red[600]!,
                        ScanQR(),
                      ),
                      buildServiceCard(
                        context,
                        FontAwesomeIcons.mobileScreenButton,
                        'Generate QR',
                        Colors.teal[600]!,
                        GenerateQR(globalKey: globalKey),
                      ),
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
      Color color, Widget buttonRoute) {
    return InkWell(
      onTap: () {
        // var app = Provider.of<AppState>(context, listen: false);
        // app.setPageIndex = pageIndex;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => buttonRoute),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        width: MediaQuery.of(context).size.width / 2.35,
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
      Color color, Widget buttonRoute) {
    return InkWell(
      onTap: () {
        // var app = Provider.of<AppState>(context, listen: false);
        // app.setPageIndex = pageIndex;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => buttonRoute),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              spreadRadius: 1,
              color: Colors.black.withOpacity(0.05),
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
                color: Colors.grey[800],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
