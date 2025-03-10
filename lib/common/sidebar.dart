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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          ListTile(
            onTap: () {},
            title: FutureBuilder<String>(
              future: getName(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    snapshot.data ?? 'No name available',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  );
                }
              },
            ),
            subtitle: FutureBuilder<String>(
              future: getEmail(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    snapshot.data ?? 'No name available',
                    style: GoogleFonts.montserrat(
                      fontSize: 12.5,
                      color: Colors.black,
                    ),
                  );
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: GestureDetector(
              onTap: () {
                var app = Provider.of<AppState>(context, listen: false);
                app.setPageIndex = 4;
              },
              child: Row(
                children: [
                  Text(
                    "View Profile",
                    style: GoogleFonts.montserrat(fontSize: 17),
                  ),
                  Icon(size: 15, FontAwesomeIcons.chevronRight)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListTile _menuListRowButton(String title,
      {Function? onPressed, IconData? icon, bool isEnable = false}) {
    return ListTile(
      onTap: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      leading: icon == null
          ? null
          : Padding(
              padding: EdgeInsets.only(top: 5),
              child: Icon(
                icon,
                size: 25,
                color: isEnable ? Colors.black : Colors.grey,
              ),
            ),
      title: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 20,
          color: isEnable ? Colors.black : Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                menuHeader(),
                Column(
                  children: [
                    _menuListRowButton(
                      'Help Center',
                      isEnable: true,
                      onPressed: () {},
                      icon: FontAwesomeIcons.handshake,
                    ),
                    _menuListRowButton(
                      isEnable: true,
                      onPressed: () {
                        final app =
                            Provider.of<AppState>(context, listen: false);
                        app.toggleDarkMode();
                      },
                      'Toggle Dark Mode',
                      icon: FontAwesomeIcons.moon,
                    ),
                    _menuListRowButton(
                      isEnable: true,
                      onPressed: () {},
                      'Settings and privacy',
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
                Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
