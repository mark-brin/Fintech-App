import 'package:clearpay/state/transactionState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clearpay/state/authstate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clearpay/wallet/allPayments.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Wallet extends StatelessWidget {
  const Wallet({super.key});
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

  String formatDate(String dateString) {
    final DateTime date = DateTime.parse(dateString);
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day} ${getMonth(date.month)} ${date.year}';
    }
  }

  String getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF334D8F),
        title: Text(
          'Wallet',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              size: 20,
              color: Colors.white,
              FontAwesomeIcons.ellipsisVertical,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildBalanceCard(context),
            SizedBox(height: 20),
            buildQuickActions(context),
            SizedBox(height: 20),
            buildTransactionHistory(context),
          ],
        ),
      ),
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
              'Total Balance',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 8),
            Text(
              '₹ ${auth.userModel!.balance.toString()}',
              style: GoogleFonts.montserrat(
                fontSize: 32,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment ID',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${getEmailPrefix(context)}@ebixcash',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF334D8F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                    ),
                    child: Text(
                      'Add Money',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget buildQuickActions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
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
              buildActionButton(
                FontAwesomeIcons.moneyBillTransfer,
                'Send Money',
                Colors.blue[700]!,
                () {},
              ),
              buildActionButton(
                FontAwesomeIcons.creditCard,
                'Pay Bills',
                Colors.purple[700]!,
                () {},
              ),
              buildActionButton(
                FontAwesomeIcons.clockRotateLeft,
                'History',
                Colors.orange[700]!,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionHistory(),
                    ),
                  );
                },
              ),
              buildActionButton(
                FontAwesomeIcons.rightLeft,
                'Exchange',
                Colors.green[700]!,
                () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildActionButton(
      IconData icon, String label, Color color, void Function() onPress) {
    return IconButton(
      onPressed: onPress,
      icon: Column(
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

  Widget buildTransactionHistory(BuildContext context) {
    final state = Provider.of<AuthState>(context, listen: false);
    final transaction = Provider.of<TransactionState>(context);
    return RefreshIndicator(
      onRefresh: () async {
        transaction.getDataFromDatabase(context);
        return Future.value();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payments History',
                  style: GoogleFonts.montserrat(
                    fontSize: 17.5,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionHistory(),
                      ),
                    );
                  },
                  child: Text(
                    'See All',
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
            transaction.userTransactionsList!.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        children: [
                          Icon(
                            FontAwesomeIcons.clockRotateLeft,
                            size: 40,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 15),
                          Text(
                            'No transactions yet',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: List.generate(
                      transaction.userTransactionsList!.length > 5
                          ? 5
                          : transaction.userTransactionsList!.length,
                      (index) {
                        final tx = transaction.userTransactionsList![index];
                        final bool isDebit =
                            tx.senderId == state.userModel!.userId;
                        final String formattedDate = formatDate(tx.createdAt!);

                        return buildTransactionItem(
                          isDebit ? tx.recipientName! : tx.senderName!,
                          isDebit ? 'Sent' : 'Received',
                          isDebit ? '- ₹${tx.amount}' : '+ ₹${tx.amount}',
                          isDebit
                              ? FontAwesomeIcons.arrowUp
                              : FontAwesomeIcons.arrowDown,
                          isDebit ? Colors.red[600]! : Colors.green[600]!,
                          formattedDate,
                          isDebit: isDebit,
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildTransactionItem(String title, String subtitle, String amount,
      IconData icon, Color color, String date,
      {required bool isDebit}) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: color),
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
                date,
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
