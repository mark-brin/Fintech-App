import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clearpay/state/authstate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clearpay/state/transactionState.dart';
import 'package:clearpay/transactions/transactionModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});
  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  String filterType = "All";

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transactionState =
          Provider.of<TransactionState>(context, listen: false);
      transactionState.getDataFromDatabase(context);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = Provider.of<TransactionState>(context);
    final authState = Provider.of<AuthState>(context);

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF334D8F),
        title: Text(
          'Transaction History',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            color: Color(0xFF334D8F),
            child: TabBar(
              controller: tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              tabs: [
                Tab(
                  child: Text(
                    'All',
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
                ),
                Tab(
                  child: Text(
                    'Sent',
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
                ),
                Tab(
                  child: Text(
                    'Received',
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
                ),
              ],
              onTap: (index) {
                setState(() {
                  filterType =
                      index == 0 ? "All" : (index == 1 ? "Sent" : "Received");
                });
              },
            ),
          ),
        ),
      ),
      body: transactionState.isBusy
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: tabController,
              children: [
                buildTransactionList(
                  transactionState.userTransactionsList ?? [],
                  authState,
                ),
                buildTransactionList(
                  transactionState.transactionsList ?? [],
                  authState,
                  sentOnly: true,
                ),
                buildTransactionList(
                  transactionState.recipientTransactionsList ?? [],
                  authState,
                  receivedOnly: true,
                ),
              ],
            ),
    );
  }

  Widget buildTransactionList(
    List<TransactionModel> transactions,
    AuthState authState, {
    bool sentOnly = false,
    bool receivedOnly = false,
  }) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              size: 50,
              color: Colors.grey[400],
              FontAwesomeIcons.clockRotateLeft,
            ),
            SizedBox(height: 20),
            Text(
              'No transactions found',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final transactionState =
            Provider.of<TransactionState>(context, listen: false);
        transactionState.getDataFromDatabase(context);
        return Future.value();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final tx = transactions[index];
          final bool isDebit = tx.senderId == authState.userModel!.userId;
          if ((sentOnly && !isDebit) || (receivedOnly && isDebit)) {
            return SizedBox.shrink();
          }
          return buildTransactionCard(tx, isDebit);
        },
      ),
    );
  }

  Widget buildTransactionCard(TransactionModel tx, bool isDebit) {
    final DateTime date = DateTime.parse(tx.createdAt!);
    final String formattedDate =
        '${date.day} ${getMonth(date.month)} ${date.year}';
    final String formattedTime =
        '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
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
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: (isDebit ? Colors.red[600] : Colors.green[600])!
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    size: 22,
                    isDebit
                        ? FontAwesomeIcons.arrowUp
                        : FontAwesomeIcons.arrowDown,
                    color: isDebit ? Colors.red[600] : Colors.green[600],
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isDebit ? tx.recipientName! : tx.senderName!,
                        style: GoogleFonts.montserrat(
                          fontSize: 17,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        isDebit ? 'Money Sent' : 'Money Received',
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
                      isDebit ? '- ₹${tx.amount}' : '+ ₹${tx.amount}',
                      style: GoogleFonts.montserrat(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: isDebit ? Colors.red[600] : Colors.green[600],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: GoogleFonts.montserrat(
                        fontSize: 12.5,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey[200]),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  formattedTime,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
}
