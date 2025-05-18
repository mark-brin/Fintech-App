import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Mandates extends StatelessWidget {
  const Mandates({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF334D8F),
        title: Text(
          'Mandates',
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
        actions: [
          IconButton(
            icon: Icon(
              size: 20,
              color: Colors.white,
              FontAwesomeIcons.circleInfo,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          buildHeaderSection(),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 1,
                          color: Colors.black.withOpacity(0.05),
                        ),
                      ],
                    ),
                    child: TabBar(
                      indicator: BoxDecoration(
                        color: Color(0xFF334D8F),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey[700],
                      labelStyle: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: [
                        Tab(text: 'Active'),
                        Tab(text: 'Expired'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        buildActiveMandatesTab(),
                        buildExpiredMandatesTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xFF334D8F),
        child: Icon(FontAwesomeIcons.plus, color: Colors.white),
      ),
    );
  }

  Widget buildHeaderSection() {
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
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      size: 20,
                      color: Colors.white,
                      FontAwesomeIcons.fileContract,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '5 Active Mandates',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Automatic payments authorized by you',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
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
    );
  }

  Widget buildActiveMandatesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildMandateCard(
            'Electricity Bill',
            'Power Distribution Company',
            'Up to ₹2,000/month',
            'Debit on 5th of every month',
            'Active till Dec 2025',
            true,
            'high',
          ),
          buildMandateCard(
            'Netflix Subscription',
            'Netflix Entertainment Services',
            'Fixed ₹649/month',
            'Debit on 15th of every month',
            'Active till Aug 2025',
            true,
            'medium',
          ),
          buildMandateCard(
            'Health Insurance',
            'Star Health Insurance',
            'Fixed ₹5,000/quarter',
            'Next debit on Jun 15, 2025',
            'Active till Jun 2026',
            true,
            'medium',
          ),
          buildMandateCard(
            'Gym Membership',
            'Fitness First',
            'Fixed ₹1,800/month',
            'Debit on 10th of every month',
            'Active till Sep 2025',
            true,
            'low',
          ),
          buildMandateCard(
            'Internet Bill',
            'Airtel Broadband',
            'Up to ₹1,500/month',
            'Debit on 7th of every month',
            'Active till Feb 2026',
            true,
            'low',
          ),
        ],
      ),
    );
  }

  Widget buildExpiredMandatesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildMandateCard(
            'Old Mobile Plan',
            'Jio Telecommunications',
            'Fixed ₹499/month',
            'Last debited on Jan 10, 2025',
            'Expired on Feb 2025',
            false,
            'low',
          ),
          buildMandateCard(
            'Magazine Subscription',
            'Reader\'s Digest',
            'Fixed ₹1,200/year',
            'Last debited on Dec 5, 2024',
            'Expired on Dec 2024',
            false,
            'low',
          ),
          buildMandateCard(
            'Previous Gym',
            'Gold\'s Gym',
            'Fixed ₹2,200/month',
            'Last debited on Nov 15, 2024',
            'Expired on Dec 2024',
            false,
            'low',
          ),
          buildEmptyState(
            'No more expired mandates',
            'Older expired mandates are automatically removed after 6 months.',
            FontAwesomeIcons.clockRotateLeft,
          ),
        ],
      ),
    );
  }

  Widget buildMandateCard(String title, String merchant, String amount,
      String schedule, String validity, bool isActive, String priority) {
    Color priorityColor;
    switch (priority) {
      case 'high':
        priorityColor = Colors.red[600]!;
        break;
      case 'medium':
        priorityColor = Colors.orange[600]!;
        break;
      default:
        priorityColor = isActive ? Colors.green[600]! : Colors.grey[600]!;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 15),
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
        border: Border.all(
          width: 1,
          color: isActive ? priorityColor.withOpacity(0.3) : Colors.grey[300]!,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isActive
                        ? priorityColor.withOpacity(0.1)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    size: 24,
                    getIconForTitle(title),
                    color: isActive ? priorityColor : Colors.grey[600],
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        merchant,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green[50] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isActive ? 'Active' : 'Expired',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.green[600] : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 1,
                  color: Colors.grey[200]!,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        size: 14,
                        color: Colors.grey[600],
                        FontAwesomeIcons.indianRupeeSign,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Amount:',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        amount,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        size: 14,
                        color: Colors.grey[600],
                        FontAwesomeIcons.calendarDays,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Schedule:',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          schedule,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isActive
                        ? priorityColor.withOpacity(0.1)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        size: 12,
                        FontAwesomeIcons.clock,
                        color: isActive ? priorityColor : Colors.grey[600],
                      ),
                      SizedBox(width: 5),
                      Text(
                        validity,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isActive ? priorityColor : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                if (isActive)
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red[600],
                      side: BorderSide(color: Colors.red[600]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                    child: Text(
                      'Revoke',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (!isActive)
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF334D8F),
                      side: BorderSide(color: Color(0xFF334D8F)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                    ),
                    child: Text(
                      'Renew',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmptyState(String title, String subtitle, IconData icon) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.all(20),
      width: double.infinity,
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
      child: Column(
        children: [
          Icon(
            icon,
            size: 50,
            color: Colors.grey[400],
          ),
          SizedBox(height: 15),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Text(
            subtitle,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData getIconForTitle(String title) {
    if (title.contains('Electricity')) {
      return FontAwesomeIcons.bolt;
    } else if (title.contains('Netflix') || title.contains('Magazine')) {
      return FontAwesomeIcons.tv;
    } else if (title.contains('Gym')) {
      return FontAwesomeIcons.dumbbell;
    } else if (title.contains('Mobile') || title.contains('Internet')) {
      return FontAwesomeIcons.wifi;
    } else if (title.contains('Insurance') || title.contains('Health')) {
      return FontAwesomeIcons.heartPulse;
    } else {
      return FontAwesomeIcons.fileInvoice;
    }
  }
}
