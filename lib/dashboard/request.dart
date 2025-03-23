import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fintech_app/state/appstate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});
  @override
  State<Requests> createState() => RequestsState();
}

class RequestsState extends State<Requests>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF334D8F),
        title: Text(
          'Money Requests',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            var app = Provider.of<AppState>(context, listen: false);
            app.pageController.animateToPage(
              0,
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: 300),
            );
            app.setPageIndex = 0;
          },
        ),
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.sliders, color: Colors.white, size: 18),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                _buildPendingRequestsTab(),
                _buildCompletedRequestsTab(),
              ],
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

  Widget _buildTabBar() {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF334D8F),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.clockRotateLeft,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 10),
                          Text(
                            '3 Pending Requests',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.7),
              labelStyle: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                Tab(text: 'Pending'),
                Tab(text: 'Completed'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingRequestsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Requests From You'),
          SizedBox(height: 15),
          _buildRequestCard(
            'John Doe',
            'john@gmail.com',
            '₹1,500.00',
            'Dinner last night',
            '2 hours ago',
            isPending: true,
            isFromYou: true,
          ),
          _buildRequestCard(
            'Sarah Miller',
            'sarah@gmail.com',
            '₹2,200.00',
            'Trip expenses',
            '1 day ago',
            isPending: true,
            isFromYou: true,
          ),
          SizedBox(height: 25),
          _buildSectionTitle('Requests To You'),
          SizedBox(height: 15),
          _buildRequestCard(
            'Mike Thompson',
            'mike@gmail.com',
            '₹850.00',
            'Movie tickets',
            '5 hours ago',
            isPending: true,
            isFromYou: false,
          ),
          _buildEmptyState(
            'No more pending requests',
            'All caught up! You have no more pending requests to handle.',
            FontAwesomeIcons.checkCircle,
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedRequestsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Recent Activity'),
          SizedBox(height: 15),
          _buildRequestCard(
            'Emma Roberts',
            'emma@gmail.com',
            '₹3,000.00',
            'Rent payment',
            'Completed on Mar 10',
            isPending: false,
            isFromYou: true,
            isAccepted: true,
          ),
          _buildRequestCard(
            'Alex Kumar',
            'alex@gmail.com',
            '₹750.00',
            'Lunch payment',
            'Declined on Mar 8',
            isPending: false,
            isFromYou: false,
            isAccepted: false,
          ),
          _buildRequestCard(
            'Lisa Wang',
            'lisa@gmail.com',
            '₹1,200.00',
            'Utility bills',
            'Completed on Mar 5',
            isPending: false,
            isFromYou: true,
            isAccepted: true,
          ),
          _buildRequestCard(
            'Robert Chen',
            'robert@gmail.com',
            '₹500.00',
            'Group gift',
            'Completed on Mar 3',
            isPending: false,
            isFromYou: false,
            isAccepted: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildRequestCard(
      String name, String email, String amount, String note, String time,
      {required bool isPending,
      required bool isFromYou,
      bool isAccepted = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
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
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFF334D8F).withOpacity(0.1),
                  child: Text(
                    name.substring(0, 1),
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334D8F),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        email,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      amount,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color:
                            isFromYou ? Colors.orange[600] : Colors.blue[600],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      time,
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.noteSticky,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      note,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isPending) ...[
              SizedBox(height: 15),
              Row(
                children: [
                  if (isFromYou) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red[600],
                          side: BorderSide(color: Colors.red[600]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Cancel Request',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red[600],
                          side: BorderSide(color: Colors.red[600]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Decline',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF334D8F),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                        child: Text(
                          'Pay Now',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ] else ...[
              SizedBox(height: 15),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isAccepted ? Colors.green[50] : Colors.red[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isAccepted
                              ? FontAwesomeIcons.check
                              : FontAwesomeIcons.xmark,
                          size: 12,
                          color:
                              isAccepted ? Colors.green[600] : Colors.red[600],
                        ),
                        SizedBox(width: 5),
                        Text(
                          isAccepted ? 'Completed' : 'Declined',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isAccepted
                                ? Colors.green[600]
                                : Colors.red[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
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
          Icon(icon, size: 50, color: Colors.green[400]),
          SizedBox(height: 15),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
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
}
