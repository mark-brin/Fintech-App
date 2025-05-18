import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clearpay/state/authstate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clearpay/state/requestState.dart';
import 'package:clearpay/dashboard/payContact.dart';
import 'package:clearpay/state/transactionState.dart';
import 'package:clearpay/transactions/requestModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Request extends StatefulWidget {
  const Request({super.key});
  @override
  State<Request> createState() => RequestState();
}

class RequestState extends State<Request> with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool isLoading = true;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchRequests();
    });
  }

  Future<void> fetchRequests() async {
    setState(() {
      isLoading = true;
    });

    final authState = Provider.of<AuthState>(context, listen: false);
    final requestsState = Provider.of<RequestsState>(context, listen: false);
    await requestsState.fetchRequests(authState.userModel!.userId!);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requestsState = Provider.of<RequestsState>(context);

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
        actions: [
          IconButton(
            onPressed: fetchRequests,
            icon: Icon(
              size: 18,
              color: Colors.white,
              FontAwesomeIcons.arrowsRotate,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Color(0xFF334D8F),
              ),
            )
          : Column(
              children: [
                buildTabBar(requestsState),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      buildPendingRequestsTab(requestsState),
                      buildCompletedRequestsTab(requestsState),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserContactList(
                onContactSelected: (userId, userName) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateRequestScreen(
                        recipientId: userId,
                        recipientName: userName,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
        backgroundColor: Color(0xFF334D8F),
        child: Icon(FontAwesomeIcons.plus, color: Colors.white),
      ),
    );
  }

  Widget buildTabBar(RequestsState requestsState) {
    int pendingCount = requestsState.pendingSentRequests.length +
        requestsState.pendingReceivedRequests.length;

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
                            size: 16,
                            color: Colors.white,
                            FontAwesomeIcons.clockRotateLeft,
                          ),
                          SizedBox(width: 10),
                          Text(
                            '$pendingCount Pending Requests',
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
              indicatorWeight: 3,
              controller: tabController,
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
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

  Widget buildPendingRequestsTab(RequestsState requestsState) {
    return RefreshIndicator(
      onRefresh: fetchRequests,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle('Requests From You'),
            SizedBox(height: 15),
            requestsState.pendingSentRequests.isEmpty
                ? buildEmptyState(
                    'No pending requests sent',
                    'You haven\'t sent any payment requests yet.',
                    FontAwesomeIcons.paperPlane,
                  )
                : Column(
                    children: requestsState.pendingSentRequests.map((request) {
                      return buildRequestCard(
                        request.recipientName!,
                        'Request ID: ${request.id!.substring(0, 8)}',
                        '₹${request.amount}',
                        request.note ?? 'No note',
                        formatDate(request.createdAt!),
                        isPending: true,
                        isFromYou: true,
                        onCancel: () => handleCancelRequest(request.id!),
                      );
                    }).toList(),
                  ),
            SizedBox(height: 25),
            buildSectionTitle('Requests To You'),
            SizedBox(height: 15),
            requestsState.pendingReceivedRequests.isEmpty
                ? buildEmptyState(
                    'No pending requests received',
                    'You don\'t have any payment requests to handle.',
                    FontAwesomeIcons.checkCircle,
                  )
                : Column(
                    children: requestsState.pendingReceivedRequests.map(
                      (request) {
                        return buildRequestCard(
                          request.requesterName!,
                          'Request ID: ${request.id!.substring(0, 8)}',
                          '₹${request.amount}',
                          request.note ?? 'No note',
                          formatDate(request.createdAt!),
                          isPending: true,
                          isFromYou: false,
                          onDecline: () => handleDeclineRequest(request.id!),
                          onPay: () => handlePayRequest(request),
                        );
                      },
                    ).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildCompletedRequestsTab(RequestsState requestsState) {
    return RefreshIndicator(
      onRefresh: fetchRequests,
      child: requestsState.completedRequests.isEmpty
          ? Center(
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
                    'No completed requests yet',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSectionTitle('Recent Activity'),
                  SizedBox(height: 15),
                  Column(
                    children: requestsState.completedRequests.map((request) {
                      bool isFromYou = request.requesterId ==
                          Provider.of<AuthState>(context, listen: false)
                              .userModel!
                              .userId;
                      bool isAccepted = request.status == "completed";
                      return buildRequestCard(
                        isFromYou
                            ? request.recipientName!
                            : request.requesterName!,
                        'Request ID: ${request.id!.substring(0, 8)}',
                        '₹${request.amount}',
                        request.note ?? 'No note',
                        '${isAccepted ? 'Completed' : 'Declined'} on ${formatDate(request.createdAt!)}',
                        isPending: false,
                        isFromYou: isFromYou,
                        isAccepted: isAccepted,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> handleCancelRequest(String requestId) async {
    final requestsState = Provider.of<RequestsState>(context, listen: false);
    try {
      await requestsState.updateRequestStatus(requestId, "declined");
      await fetchRequests();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green[400],
          content: Text("Request cancelled successfully"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          content: Text("Failed to cancel request: ${e.toString()}"),
        ),
      );
    }
  }

  Future<void> handleDeclineRequest(String requestId) async {
    final requestsState = Provider.of<RequestsState>(context, listen: false);
    try {
      await requestsState.updateRequestStatus(requestId, "declined");
      await fetchRequests();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Request declined"),
          backgroundColor: Colors.orange[400],
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          content: Text("Failed to decline request: ${e.toString()}"),
        ),
      );
    }
  }

  Future<void> handlePayRequest(RequestModel request) async {
    final authState = Provider.of<AuthState>(context, listen: false);
    final requestsState = Provider.of<RequestsState>(context, listen: false);
    final transactionState =
        Provider.of<TransactionState>(context, listen: false);
    try {
      await requestsState.processPayment(request, authState, transactionState);
      await fetchRequests();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment successful"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green[400],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to process payment: ${e.toString()}"),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String formatDate(String dateString) {
    final DateTime date = DateTime.parse(dateString);
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day} ${_getMonth(date.month)} ${date.year}';
    }
  }

  String _getMonth(int month) {
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

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        fontSize: 18,
        color: Colors.grey[800],
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget buildRequestCard(
    String name,
    String email,
    String amount,
    String note,
    String time, {
    required bool isPending,
    required bool isFromYou,
    bool isAccepted = false,
    Function()? onCancel,
    Function()? onDecline,
    Function()? onPay,
  }) {
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
                      color: Color(0xFF334D8F),
                      fontWeight: FontWeight.bold,
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
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600,
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
                    size: 14,
                    color: Colors.grey[600],
                    FontAwesomeIcons.noteSticky,
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
                        onPressed: onCancel,
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
                        onPressed: onDecline,
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
                        onPressed: onPay,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF334D8F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
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
                      borderRadius: BorderRadius.circular(20),
                      color: isAccepted ? Colors.green[50] : Colors.red[50],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          size: 12,
                          isAccepted
                              ? FontAwesomeIcons.check
                              : FontAwesomeIcons.xmark,
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

  Widget buildEmptyState(String title, String subtitle, IconData icon) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(top: 30),
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
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class CreateRequestScreen extends StatefulWidget {
  final String recipientId;
  final String recipientName;
  const CreateRequestScreen({
    super.key,
    required this.recipientId,
    required this.recipientName,
  });

  @override
  _CreateRequestScreenState createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  bool isProcessing = false;
  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void createRequest() async {
    if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          content: Text("Please enter an amount"),
        ),
      );
      return;
    }
    setState(() {
      isProcessing = true;
    });
    try {
      final req = Provider.of<RequestsState>(context, listen: false);
      final authState = Provider.of<AuthState>(context, listen: false);
      final request = RequestModel(
        amount: amountController.text,
        note: noteController.text,
        requesterId: authState.userModel!.userId,
        requesterName: authState.userModel!.displayName,
        recipientId: widget.recipientId,
        recipientName: widget.recipientName,
        status: "pending",
        createdAt: DateTime.now().toIso8601String(),
      );
      await req.createRequest(request);
      setState(() {
        isProcessing = false;
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green[400],
          content: Text("Request sent successfully"),
        ),
      );
    } catch (e) {
      setState(() {
        isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          content: Text("Failed to send request: ${e.toString()}"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF334D8F),
        title: Text(
          'Request Money',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(FontAwesomeIcons.chevronLeft, size: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                      color: Color(0xFF334D8F).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        widget.recipientName.isNotEmpty
                            ? widget.recipientName[0].toUpperCase()
                            : "U",
                        style: GoogleFonts.montserrat(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334D8F),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Requesting from",
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.recipientName,
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            Text(
              "Amount",
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Colors.grey[800],
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 1,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ],
              ),
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: "Enter amount",
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: Text(
                      "₹",
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        color: Color(0xFF334D8F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 15,
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Text(
              "Note",
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 1,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ],
              ),
              child: TextField(
                controller: noteController,
                maxLines: 3,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: "What's this for?",
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 15,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isProcessing ? null : createRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF334D8F),
                  disabledBackgroundColor: Color(0xFF334D8F).withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: isProcessing
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        "Send Request",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
