import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fintech_app/state/appstate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key, this.scaffoldKey});
  final GlobalKey<ScaffoldState>? scaffoldKey;
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  Future<String> getName() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/users/1'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['firstName'] +
          '' +
          data['maidenName'] +
          '' +
          data['lastName'];
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<String> getEmail() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/users/1'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['email'];
    } else {
      throw Exception('Failed to load user');
    }
  }

  Widget menuHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF334D8F),
                      Color(0xFF4A6FD1),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF334D8F).withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  FontAwesomeIcons.user,
                  size: 24,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<String>(
                      future: getName(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                            'Error loading name',
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          );
                        } else {
                          return Text(
                            snapshot.data ?? 'Loading...',
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                            overflow: TextOverflow.ellipsis,
                          );
                        }
                      },
                    ),
                    SizedBox(height: 4),
                    FutureBuilder<String>(
                      future: getEmail(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                            'Error loading email',
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          );
                        } else {
                          return Text(
                            snapshot.data ?? 'Loading...',
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              var app = Provider.of<AppState>(context, listen: false);
              app.setPageIndex = 4;
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Color(0xFF334D8F).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(0xFF334D8F).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.userPen,
                    size: 14,
                    color: Color(0xFF334D8F),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Edit Profile",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334D8F),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuListRowButton(String title,
      {Function? onPressed, IconData? icon, bool isEnable = false}) {
    return InkWell(
      onTap: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 20,
                color: isEnable ? Color(0xFF334D8F) : Colors.grey[400],
              ),
            SizedBox(width: 15),
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: isEnable ? FontWeight.w500 : FontWeight.w400,
                color: isEnable ? Colors.grey[800] : Colors.grey[400],
              ),
            ),
            Spacer(),
            Icon(
              FontAwesomeIcons.chevronRight,
              size: 14,
              color: isEnable ? Colors.grey[400] : Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            menuHeader(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 1,
              color: Colors.grey[200],
            ),
            SizedBox(height: 10),
            Expanded(
              child: Column(
                children: [
                  _menuListRowButton(
                    'Help Center',
                    isEnable: true,
                    onPressed: () {},
                    icon: FontAwesomeIcons.circleQuestion,
                  ),
                  _menuListRowButton(
                    'Settings and privacy',
                    isEnable: true,
                    onPressed: () {},
                    icon: FontAwesomeIcons.gear,
                  ),
                  _menuListRowButton(
                    'Logout',
                    isEnable: true,
                    onPressed: () {},
                    icon: FontAwesomeIcons.arrowRightFromBracket,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  top: BorderSide(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF334D8F).withOpacity(0.1),
                        ),
                        child: Icon(
                          FontAwesomeIcons.headset,
                          size: 16,
                          color: Color(0xFF334D8F),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Customer Support',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    'App Version 1.0.0',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.grey[500],
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
}
