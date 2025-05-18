import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clearpay/state/appstate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainNavBar extends StatefulWidget {
  const MainNavBar({super.key});
  @override
  _MainNavBarState createState() => _MainNavBarState();
}

class _MainNavBarState extends State<MainNavBar> {
  @override
  void initState() {
    super.initState();
  }

  Widget iconList() {
    var state = Provider.of<AppState>(context);
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            spreadRadius: 1,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          notchMargin: 10,
          color: Colors.white,
          shape: CircularNotchedRectangle(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _icon(
                  null,
                  0,
                  icon: 0 == state.pageIndex
                      ? FontAwesomeIcons.house
                      : FontAwesomeIcons.house,
                  isCustomIcon: true,
                  "Home",
                ),
                SizedBox(width: 15),
                _icon(
                  null,
                  1,
                  icon: 1 == state.pageIndex
                      ? FontAwesomeIcons.wallet
                      : FontAwesomeIcons.wallet,
                  isCustomIcon: true,
                  "Wallet",
                ),
                SizedBox(width: 15),
                _icon(
                  null,
                  2,
                  icon: FontAwesomeIcons.gift,
                  isCustomIcon: true,
                  "Rewards",
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 15),
                _icon(
                  null,
                  3,
                  icon: 3 == state.pageIndex
                      ? FontAwesomeIcons.solidStar
                      : FontAwesomeIcons.star,
                  isCustomIcon: true,
                  "Transactions",
                  style: GoogleFonts.montserrat(
                    fontSize: 8.25,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _icon(IconData? iconData, int index, String title,
      {bool isCustomIcon = false, IconData? icon, TextStyle? style}) {
    if (isCustomIcon) {
      assert(icon != null);
    } else {
      assert(iconData != null);
    }
    var state = Provider.of<AppState>(context);
    return Expanded(
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: AnimatedAlign(
          curve: Curves.easeIn,
          alignment: Alignment(0, 0),
          duration: Duration(milliseconds: 200),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: 1,
            child: TextButton(
              onPressed: () {
                setState(
                  () {
                    state.setPageIndex = index;
                  },
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    isCustomIcon ? icon : iconData,
                    size: 21,
                    color: index == state.pageIndex
                        ? Color(0xFF334D8F)
                        : Colors.grey[400],
                  ),
                  SizedBox(height: 4),
                  Text(
                    title,
                    style: style ??
                        GoogleFonts.montserrat(
                          fontSize: 11,
                          color: index == state.pageIndex
                              ? Color(0xFF334D8F)
                              : Colors.grey[600],
                          fontWeight: index == state.pageIndex
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return iconList();
  }
}
