import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:clearpay/common/enums.dart';
import 'package:clearpay/auth/usermodel.dart';
import 'package:clearpay/state/authstate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clearpay/dashboard/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clearpay/state/transactionState.dart';
import 'package:clearpay/transactions/transactionModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String payeeName;
  const PaymentScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.payeeName,
  });
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late String userId;
  late String userName;
  late String payeeName;
  bool isExpanded = false;
  late TextEditingController amountController;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    userName = widget.userName;
    payeeName = widget.payeeName;
    amountController = TextEditingController();
  }

  void makePayment() async {
    if (isProcessing) return;

    setState(() {
      isProcessing = true;
    });

    var state = Provider.of<AuthState>(context, listen: false);
    var state1 = Provider.of<TransactionState>(context, listen: false);

    if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter an amount"),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {
        isProcessing = false;
      });
      return;
    }

    try {
      int amountValue = int.parse(amountController.text);
      if (amountValue < 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Amount must be greater than 1Rs"),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          isProcessing = false;
        });
        return;
      }

      if (state.userModel!.balance! < amountValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Insufficient balance"),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          isProcessing = false;
        });
        return;
      }

      // Find recipient
      QuerySnapshot recipientQuery = await FirebaseFirestore.instance
          .collection(USERS)
          .where('displayName', isEqualTo: payeeName)
          .limit(1)
          .get();

      if (recipientQuery.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Recipient not found"),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          isProcessing = false;
        });
        return;
      }

      DocumentSnapshot recipientSnapshot = recipientQuery.docs.first;
      var recipientData = recipientSnapshot.data() as Map<String, dynamic>;
      var recipientBalance = recipientData['balance'] ?? 0;
      var recipientId = recipientData['userId'];

      // Update sender's balance
      int remAmount = state.userModel!.balance! - amountValue;
      state.userModel!.balance = remAmount;
      var user = UserModel(
        balance: remAmount,
        email: state.userModel!.email,
        userId: state.userModel!.userId,
        profilePic: state.userModel!.profilePic,
        displayName: state.userModel!.displayName,
      );
      state.updateUserProfile(user);

      // Update recipient's balance
      int recipientNewBalance = recipientBalance + amountValue;
      await FirebaseFirestore.instance
          .collection(USERS)
          .doc(recipientId)
          .update({'balance': recipientNewBalance});

      // Record transaction
      TransactionModel transaction = TransactionModel(
        amount: amountValue,
        recipientName: payeeName,
        senderId: state.userModel!.userId,
        createdAt: DateTime.now().toString(),
        recipientId: recipientId,
        senderName: state.userModel!.displayName,
      );
      state1.recordTransaction(transaction);
      showSuccessDialog();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${error.toString()}"),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {
        isProcessing = false;
      });
    }
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FontAwesomeIcons.checkDouble,
                  color: Colors.green,
                  size: 50,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Payment Successful!",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "₹${amountController.text} sent to ${capitalizeInitials(payeeName)}",
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DashBoard()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF334D8F),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Done",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String capitalizeInitials(String text) {
    List<String> words = text.toLowerCase().split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }
    return words.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) => false,
      child: Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          toolbarHeight: 70,
          title: Text(
            "Send Money",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              FontAwesomeIcons.chevronLeft,
              size: 18,
              color: Colors.black87,
            ),
          ),
          actions: <Widget>[
            PopupMenuButton<Choice>(
              icon: Icon(
                FontAwesomeIcons.ellipsisVertical,
                color: Colors.black87,
                size: 18,
              ),
              onSelected: (d) {
                if (d.title == "Get Help") {
                  // Handle help action
                } else if (d.title == "Send Feedback") {
                  // Handle feedback action
                }
              },
              itemBuilder: (BuildContext context) {
                return choices.map(
                  (Choice choice) {
                    return PopupMenuItem<Choice>(
                      value: choice,
                      child: Text(
                        choice.title,
                        style: GoogleFonts.raleway(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ).toList();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Recipient info card
              Container(
                margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 3),
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
                          payeeName.isNotEmpty
                              ? payeeName[0].toUpperCase()
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
                          "Paying to",
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          capitalizeInitials(payeeName),
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Amount input section
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 20),
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    Text(
                      "Enter Amount",
                      style: GoogleFonts.raleway(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "₹",
                            style: GoogleFonts.montserrat(
                              fontSize: 40,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF334D8F),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              style: GoogleFonts.montserrat(
                                fontSize: 40,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: "0",
                                hintStyle: GoogleFonts.montserrat(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[300],
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Transaction details card
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Amount",
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          amountController.text.isEmpty
                              ? "₹ 0.00"
                              : "₹ ${amountController.text}",
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Transaction Fee",
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          "₹ 0.00",
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[600],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Divider(
                      color: Colors.grey[200],
                      thickness: 1,
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          amountController.text.isEmpty
                              ? "₹ 0.00"
                              : "₹ ${amountController.text}",
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF334D8F),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              // Payment button
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isProcessing ? null : makePayment,
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
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Pay Now",
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Choice {
  const Choice({
    required this.title,
    required this.icon,
    this.isEnable = false,
  });
  final bool isEnable;
  final IconData icon;
  final String title;
}

List<Choice> choices = <Choice>[
  Choice(
    title: 'Get Help',
    icon: FontAwesomeIcons.circleQuestion,
    isEnable: true,
  ),
  Choice(
    title: 'Send Feedback',
    icon: FontAwesomeIcons.comment,
    isEnable: true,
  ),
];

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:clearpay/common/enums.dart';
// import 'package:clearpay/auth/usermodel.dart';
// import 'package:clearpay/state/authstate.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:clearpay/state/transactionState.dart';
// import 'package:clearpay/transactions/transactionModel.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class PaymentScreen extends StatefulWidget {
//   final String userId;
//   final String userName;
//   final String payeeName;
//   const PaymentScreen({
//     super.key,
//     required this.userId,
//     required this.userName,
//     required this.payeeName,
//   });
//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   late String userId;
//   late String userName;
//   late String payeeName;
//   bool isExpanded = false;
//   late TextEditingController amountController;

//   @override
//   void initState() {
//     super.initState();
//     userId = widget.userId;
//     userName = widget.userName;
//     payeeName = widget.payeeName;
//     amountController = TextEditingController();
//   }

//   // void paymentRedirect() {
//   //   int amountValue = int.parse(amountController.text);
//   //   var state = Provider.of<AuthState>(context, listen: false);
//   //   final tiers = [
//   //     {'maxSpend': 5000, 'multiplier': 1},
//   //     {'maxSpend': 15000, 'multiplier': 1.2},
//   //     {'maxSpend': 30000, 'multiplier': 1.5},
//   //     {'maxSpend': 100000000, 'multiplier': 2.0},
//   //   ];

//   //   if (amountValue >= 100) {
//   //     double totalPoints = 0;
//   //     for (var i = 0; i < tiers.length; i++) {
//   //       var tier = tiers[i];
//   //       if (amountValue <= tier['maxSpend']!) {
//   //         totalPoints = (amountValue / 100) * tier['multiplier']!;
//   //         break;
//   //       } else {
//   //         totalPoints = 0;
//   //       }
//   //     }
//   //     if (totalPoints > 0) {
//   //       var user = UserModel(
//   //         email: state.userModel!.email,
//   //         userId: state.userModel!.userId,
//   //         balance: state.userModel!.balance,
//   //         profilePic: state.userModel!.profilePic,
//   //         displayName: state.userModel!.displayName,
//   //       );
//   //       state.updateUserProfile(user);
//   //       Navigator.push(
//   //         context,
//   //         MaterialPageRoute(
//   //           builder: (context) => LoyaltyEarnedPage(
//   //             points: totalPoints.toInt(),
//   //           ),
//   //         ),
//   //       );
//   //     } else {}
//   //   } else {
//   //     Navigator.push(
//   //       context,
//   //       MaterialPageRoute(builder: (context) => DashBoard()),
//   //     );
//   //   }
//   // }

//   void makePayment() async {
//     var state = Provider.of<AuthState>(context, listen: false);
//     var state1 = Provider.of<TransactionState>(context, listen: false);

//     if (amountController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please enter an amount")),
//       );
//       return;
//     }

//     try {
//       int amountValue = int.parse(amountController.text);
//       if (amountValue < 1) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Amount must be greater than 1Rs")),
//         );
//         return;
//       }

//       if (state.userModel!.balance! < amountValue) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Insufficient balance")),
//         );
//         return;
//       }
//       QuerySnapshot recipientQuery = await FirebaseFirestore.instance
//           .collection(USERS)
//           .where('displayName', isEqualTo: payeeName)
//           .limit(1)
//           .get();
//       if (recipientQuery.docs.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Recipient not found")),
//         );
//         return;
//       }
//       DocumentSnapshot recipientSnapshot = recipientQuery.docs.first;
//       var recipientData = recipientSnapshot.data() as Map<String, dynamic>;
//       var recipientBalance = recipientData['balance'] ?? 0;
//       var recipientId = recipientData['userId'];
//       int remAmount = state.userModel!.balance! - amountValue;
//       state.userModel!.balance = remAmount;
//       var user = UserModel(
//         balance: remAmount,
//         email: state.userModel!.email,
//         userId: state.userModel!.userId,
//         profilePic: state.userModel!.profilePic,
//         displayName: state.userModel!.displayName,
//       );
//       state.updateUserProfile(user);
//       int recipientNewBalance = recipientBalance + amountValue;
//       await FirebaseFirestore.instance
//           .collection(USERS)
//           .doc(recipientId)
//           .update({'balance': recipientNewBalance});
//       TransactionModel transaction = TransactionModel(
//         amount: amountValue,
//         recipientName: payeeName,
//         senderId: state.userModel!.userId,
//         createdAt: DateTime.now().toString(),
//         recipientId: recipientId,
//         senderName: state.userModel!.displayName,
//       );
//       state1.recordTransaction(transaction);
//       //paymentRedirect();
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: ${error.toString()}")),
//       );
//     }
//   }

//   String capitalizeInitials(String text) {
//     List<String> words = text.toLowerCase().split(' ');
//     for (int i = 0; i < words.length; i++) {
//       if (words[i].isNotEmpty) {
//         words[i] = words[i][0].toUpperCase() + words[i].substring(1);
//       }
//     }
//     return words.join(' ');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       onPopInvoked: (didPop) => false,
//       child: Scaffold(
//         appBar: AppBar(
//           toolbarHeight: 100,
//           title: Center(
//             child: Text(
//               "Transaction",
//               style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
//             ),
//           ),
//           leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(
//               size: 20,
//               color: Colors.black,
//               FontAwesomeIcons.chevronLeft,
//             ),
//           ),
//           actions: <Widget>[
//             PopupMenuButton<Choice>(
//               icon: Icon(
//                 color: Colors.black,
//                 FontAwesomeIcons.ellipsisVertical,
//               ),
//               onSelected: (d) {
//                 if (d.title == "Get Help") {
//                 } else if (d.title == "Send FeedBack") {}
//               },
//               itemBuilder: (BuildContext context) {
//                 return choices.map(
//                   (Choice choice) {
//                     return PopupMenuItem<Choice>(
//                       value: choice,
//                       child: Text(
//                         choice.title,
//                         style: GoogleFonts.raleway(
//                           fontSize: 15,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     );
//                   },
//                 ).toList();
//               },
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: 50),
//               Text(
//                 "Enter amount",
//                 style: GoogleFonts.raleway(fontSize: 23),
//               ),
//               SizedBox(height: 30),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "₹",
//                     style: TextStyle(fontSize: 35),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(width: 15),
//                   Container(
//                     width: 75,
//                     decoration: BoxDecoration(
//                       border: Border(
//                         bottom: BorderSide(width: 0.15, color: Colors.black),
//                       ),
//                     ),
//                     child: TextField(
//                       style: GoogleFonts.raleway(fontSize: 30),
//                       textAlign: TextAlign.center,
//                       decoration: InputDecoration(
//                         hintText: "0",
//                         border: InputBorder.none,
//                       ),
//                       controller: amountController,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 30),
//               Text(
//                 "To",
//                 style: GoogleFonts.raleway(
//                   fontSize: 23,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w300,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: 47,
//                     height: 47,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                       // image: DecorationImage(
//                       //   image: customAdvanceNetworkImage(
//                       //     state.userModel!.profilePic ?? Constants.profp,
//                       //   ),
//                       //   fit: BoxFit.fill,
//                       // ),
//                     ),
//                   ),
//                   SizedBox(width: 15),
//                   Text(
//                     capitalizeInitials(payeeName),
//                     style: GoogleFonts.raleway(fontSize: 25),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 25),
//               Container(
//                 height: 250,
//                 padding: EdgeInsets.all(15),
//                 width: MediaQuery.of(context).size.width,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                     border: Border.all(color: Colors.black, width: 0.5),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   padding: EdgeInsets.all(13),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "SubTotal",
//                             style: GoogleFonts.raleway(fontSize: 17),
//                           ),
//                           Text(
//                             amountController.text.isEmpty
//                                 ? "₹ 0.00"
//                                 : "₹ ${amountController.text}",
//                             style: GoogleFonts.raleway(fontSize: 17),
//                           )
//                         ],
//                       ),
//                       SizedBox(height: 5),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Discount",
//                             style: GoogleFonts.raleway(fontSize: 17),
//                           ),
//                           Text(
//                             "₹ 69.00",
//                             style: GoogleFonts.raleway(fontSize: 17),
//                           )
//                         ],
//                       ),
//                       SizedBox(height: 2.5),
//                       Divider(
//                         color: Colors.grey[200],
//                         thickness: 0.5,
//                       ),
//                       SizedBox(height: 2.5),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Total",
//                             style: GoogleFonts.raleway(fontSize: 17),
//                           ),
//                           Text(
//                             "₹ 69.00",
//                             style: GoogleFonts.raleway(fontSize: 17),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: makePayment,
//           shape: CircleBorder(),
//           backgroundColor: Color(0xFF334D8F),
//           child: Icon(
//             size: 27,
//             color: Colors.white,
//             FontAwesomeIcons.check,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Choice {
//   const Choice({
//     required this.title,
//     required this.icon,
//     this.isEnable = false,
//   });
//   final bool isEnable;
//   final IconData icon;
//   final String title;
// }

// List<Choice> choices = <Choice>[
//   Choice(
//     title: 'Get Help',
//     icon: Icons.directions_car,
//     isEnable: true,
//   ),
//   Choice(
//     title: 'Send FeedBack',
//     icon: Icons.directions_railway,
//     isEnable: true,
//   ),
// ];
