import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Transactions extends StatelessWidget {
  const Transactions({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF334D8F),
        title: Text(
          'Transactions',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(FontAwesomeIcons.sliders, color: Colors.white, size: 20),
          ),
          IconButton(
            icon: Icon(
              size: 20,
              color: Colors.white,
              FontAwesomeIcons.magnifyingGlass,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTransactionSummary(),
            SizedBox(height: 20),
            buildTransactionFilters(),
            SizedBox(height: 20),
            buildTransactionList(),
          ],
        ),
      ),
    );
  }

  Widget buildTransactionSummary() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF334D8F),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(padding: EdgeInsets.all(7.5)),
    );
  }

  Widget buildSummaryCard(String title, String amount, String percentage,
      IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.2),
                ),
                child: Icon(icon, size: 14, color: color),
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            amount,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              percentage,
              style: GoogleFonts.montserrat(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTransactionFilters() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                child: Row(
                  children: [
                    Text(
                      'March 2025',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Color(0xFF334D8F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      size: 12,
                      color: Color(0xFF334D8F),
                      FontAwesomeIcons.chevronDown,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                buildFilterChip('All', true),
                buildFilterChip('Income', false),
                buildFilterChip('Expenses', false),
                buildFilterChip('Shopping', false),
                buildFilterChip('Food', false),
                buildFilterChip('Travel', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: FilterChip(
        selected: isSelected,
        label: Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
        backgroundColor: Colors.white,
        selectedColor: Color(0xFF334D8F),
        checkmarkColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.1),
        elevation: 2,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onSelected: (bool selected) {},
      ),
    );
  }

  Widget buildTransactionList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDateDivider('Today, 15 Mar 2025'),
          buildTransactionItem(
            'Amazon Pay',
            'Shopping',
            '- ₹1,200.00',
            '12:45 PM',
            FontAwesomeIcons.bagShopping,
            Colors.blue[600]!,
            isDebit: true,
          ),
          buildTransactionItem(
            'Food Delivery',
            'Food & Dining',
            '- ₹450.00',
            '02:30 PM',
            FontAwesomeIcons.utensils,
            Colors.orange[600]!,
            isDebit: true,
          ),
          buildDateDivider('Yesterday, 14 Mar 2025'),
          buildTransactionItem(
            'Salary Credit',
            'Income',
            '+ ₹45,000.00',
            '09:15 AM',
            FontAwesomeIcons.buildingColumns,
            Colors.green[600]!,
            isDebit: false,
          ),
          buildTransactionItem(
            'Uber Ride',
            'Transportation',
            '- ₹350.00',
            '11:20 AM',
            FontAwesomeIcons.car,
            Colors.purple[600]!,
            isDebit: true,
          ),
          buildDateDivider('12 Mar 2025'),
          buildTransactionItem(
            'Netflix',
            'Entertainment',
            '- ₹649.00',
            '06:30 PM',
            FontAwesomeIcons.tv,
            Colors.red[600]!,
            isDebit: true,
          ),
          buildTransactionItem(
            'Electricity Bill',
            'Utilities',
            '- ₹1,450.00',
            '03:45 PM',
            FontAwesomeIcons.bolt,
            Colors.amber[700]!,
            isDebit: true,
          ),
          buildTransactionItem(
            'Freelance Payment',
            'Income',
            '+ ₹3,250.00',
            '10:15 AM',
            FontAwesomeIcons.laptopCode,
            Colors.green[600]!,
            isDebit: false,
          ),
          buildDateDivider('10 Mar 2025'),
          buildTransactionItem(
            'Gym Membership',
            'Health & Fitness',
            '- ₹1,800.00',
            '08:20 AM',
            FontAwesomeIcons.dumbbell,
            Colors.indigo[600]!,
            isDebit: true,
          ),
          buildTransactionItem(
            'Interest Credit',
            'Income',
            '+ ₹125.50',
            '12:00 AM',
            FontAwesomeIcons.percent,
            Colors.green[600]!,
            isDebit: false,
          ),
        ],
      ),
    );
  }

  Widget buildDateDivider(String date) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Text(
            date,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Divider(
              color: Colors.grey[300],
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTransactionItem(String title, String subtitle, String amount,
      String time, IconData icon, Color color,
      {required bool isDebit}) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
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
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
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
                  color: isDebit ? Colors.red[600] : Colors.green[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                time,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
