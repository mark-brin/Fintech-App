import 'package:flutter/material.dart';
import "package:flutter/foundation.dart";
import 'package:clearpay/common/enums.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:clearpay/transactions/paymentScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserContactList extends StatefulWidget {
  final Function(String userId, String userName)? onContactSelected;
  const UserContactList({super.key, this.onContactSelected});
  @override
  State<UserContactList> createState() => _UserContactListState();
}

class _UserContactListState extends State<UserContactList> {
  bool _isLoading = true;
  String _searchQuery = '';
  Iterable<Contact>? _contacts = [];
  List<Contact>? _filteredContacts = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchContacts() async {
    var status = await Permission.contacts.request();
    try {
      if (status.isGranted) {
        setState(() {
          _isLoading = true;
        });
        Iterable<Contact> contacts = await ContactsService.getContacts();
        setState(() {
          _contacts = contacts;
          _filteredContacts = contacts
              .where(
                (contact) =>
                    contact.displayName != null &&
                    contact.displayName != "???" &&
                    contact.displayName != "-" &&
                    contact.phones != null &&
                    contact.phones!.isNotEmpty,
              )
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
            content: Text("Permission to access contacts was denied"),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (kDebugMode) {
        print("Error Importing Contacts: $e");
      }
    }
  }

  void filterContacts(String query) {
    setState(() {
      _searchQuery = query;
      if (_contacts != null) {
        _filteredContacts = _contacts!
            .where(
              (contact) =>
                  contact.displayName != null &&
                  contact.displayName != "???" &&
                  contact.displayName != "-" &&
                  contact.phones != null &&
                  contact.phones!.isNotEmpty &&
                  contact.displayName!.toLowerCase().contains(
                        query.toLowerCase(),
                      ),
            )
            .toList();
      }
    });
  }

  Future<bool> checkUserExists(String phoneNumber) async {
    try {
      String cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(USERS)
          .where('phone', isEqualTo: cleanedNumber)
          .limit(1)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print("Error checking user existence: $e");
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        centerTitle: true,
        title: Text(
          "Contacts",
          style: GoogleFonts.montserrat(
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            size: 18,
            color: Colors.black87,
            FontAwesomeIcons.chevronLeft,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: searchController,
                onChanged: filterContacts,
                decoration: InputDecoration(
                  hintText: 'Search contacts...',
                  hintStyle: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  prefixIcon: Icon(
                    size: 16,
                    color: Colors.grey[500],
                    FontAwesomeIcons.magnifyingGlass,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFF334D8F),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Loading contacts...",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            )
          : _filteredContacts == null || _filteredContacts!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.addressBook,
                        size: 50,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 20),
                      Text(
                        _searchQuery.isEmpty
                            ? "No contacts found"
                            : "No contacts match your search",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemCount: _filteredContacts!.length,
                  itemBuilder: (context, index) {
                    Contact contact = _filteredContacts![index];
                    String phoneNumber = contact.phones!.first.value ?? '';
                    return FutureBuilder<bool>(
                      future: checkUserExists(phoneNumber),
                      builder: (context, snapshot) {
                        bool userExists = snapshot.data ?? false;
                        return Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 16,
                          ),
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
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: userExists
                                    ? Color(0xFF334D8F).withOpacity(0.1)
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: (contact.avatar != null &&
                                      contact.avatar!.isNotEmpty)
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.memory(
                                        contact.avatar!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        contact.initials(),
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: userExists
                                              ? Color(0xFF334D8F)
                                              : Colors.grey[600],
                                        ),
                                      ),
                                    ),
                            ),
                            title: Text(
                              contact.displayName ?? '',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4),
                                Text(
                                  phoneNumber,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  userExists
                                      ? "Registered on ClearPay"
                                      : "Not registered",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: userExists
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: userExists
                                        ? Color(0xFF334D8F)
                                        : Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            trailing: userExists
                                ? Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xFF334D8F).withOpacity(0.1),
                                    ),
                                    child: Icon(
                                      size: 16,
                                      color: Color(0xFF334D8F),
                                      FontAwesomeIcons.paperPlane,
                                    ),
                                  )
                                : null,
                            onTap: () async {
                              if (userExists) {
                                QuerySnapshot userQuery =
                                    await FirebaseFirestore.instance
                                        .collection(USERS)
                                        .where('phone',
                                            isEqualTo: phoneNumber.replaceAll(
                                                RegExp(r'[^\d+]'), ''))
                                        .limit(1)
                                        .get();
                                if (userQuery.docs.isNotEmpty) {
                                  var userData = userQuery.docs.first.data()
                                      as Map<String, dynamic>;

                                  if (widget.onContactSelected != null) {
                                    widget.onContactSelected!(
                                        userData['userId'],
                                        userData['displayName']);
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PaymentScreen(
                                          userId: userData['userId'],
                                          userName: contact.displayName ?? '',
                                          payeeName: userData['displayName'],
                                        ),
                                      ),
                                    );
                                  }
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "This contact is not registered on ClearPay"),
                                    backgroundColor: Colors.orange[400],
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

class ContactPaymentScreen extends StatefulWidget {
  final Contact contact;
  const ContactPaymentScreen({super.key, required this.contact});
  @override
  State<ContactPaymentScreen> createState() =>
      _ContactPaymentScreenState(contact);
}

class _ContactPaymentScreenState extends State<ContactPaymentScreen> {
  bool isExpanded = false;
  final Contact contact;
  _ContactPaymentScreenState(this.contact);
  void toggleContainer() {
    setState(
      () {
        isExpanded = !isExpanded;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      FontAwesomeIcons.xmark,
                    ),
                  ),
                  PopupMenuButton<Choice>(
                    onSelected: (d) {
                      if (d.title == "Get Help") {
                      } else if (d.title == "Send FeedBack") {}
                    },
                    itemBuilder: (BuildContext context) {
                      return choices.map(
                        (Choice choice) {
                          return PopupMenuItem<Choice>(
                            value: choice,
                            child: Text(
                              choice.title,
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 15,
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
              SizedBox(height: 10),
              (contact.avatar != null && contact.avatar!.isNotEmpty)
                  ? CircleAvatar(
                      radius: 25,
                      backgroundImage: MemoryImage(contact.avatar!),
                    )
                  : CircleAvatar(
                      radius: 25,
                      child: Text(
                        contact.initials(),
                        style: GoogleFonts.montserrat(),
                      ),
                    ),
              SizedBox(height: 10),
              Text(
                "Paying ${contact.displayName ?? ''}",
                style: GoogleFonts.montserrat(fontSize: 20),
              ),
              SizedBox(height: 5),
              Text(
                "Phone: ${contact.phones!.elementAt(0).value ?? ''}",
                style: GoogleFonts.montserrat(fontSize: 16.5),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    child: Text(
                      "₹",
                      style: GoogleFonts.montserrat(fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: TextField(
                      style: GoogleFonts.montserrat(fontSize: 35),
                      cursorHeight: 35,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "0",
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 35,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 20,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.5),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Proceed to Pay",
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              AnimatedContainer(
                duration: Duration(milliseconds: 250),
                height: isExpanded ? 200 : 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: Text(
                        "Select Payment Method",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      height: 75,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blue[700],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              Text(
                                "Bank 1",
                                style: GoogleFonts.montserrat(fontSize: 20),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              setState(
                                () {
                                  isExpanded = !isExpanded;
                                },
                              );
                            },
                            icon: Icon(
                              isExpanded
                                  ? FontAwesomeIcons.chevronDown
                                  : FontAwesomeIcons.chevronUp,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    isExpanded
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            height: 75,
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.blue[700],
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Text(
                                      "Bank 2",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class Choice {
  const Choice({
    required this.icon,
    required this.title,
    this.isEnable = false,
  });
  final bool isEnable;
  final IconData icon;
  final String title;
}

List<Choice> choices = <Choice>[
  Choice(title: 'Get Help', icon: Icons.directions_car, isEnable: true),
  Choice(
      title: 'Send FeedBack', icon: Icons.directions_railway, isEnable: true),
];
