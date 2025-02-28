import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fintech_app/state/appstate.dart';
import 'package:fintech_app/common/mediaplayer.dart';
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

  Widget _iconList() {
    var state = Provider.of<AppState>(context);
    return Container(
      height: 75,
      decoration: BoxDecoration(color: Colors.white),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          notchMargin: 10,
          color: Colors.white,
          shape: CircularNotchedRectangle(),
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
                "Tab 4",
                style: GoogleFonts.montserrat(
                  fontSize: 9.8,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    iconData,
                    color: index == state.pageIndex
                        ? Color(0xFF334D8F)
                        : Theme.of(context).textTheme.bodySmall!.color,
                  ),
                  Text(
                    title,
                    style: style ??
                        GoogleFonts.montserrat(
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
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
    return _iconList();
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  OverlayEntry? _overlayEntry;
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Container(
              height: animation.value * MediaQuery.of(context).size.height +
                  (1 - animation.value) * 75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    spreadRadius: 3,
                    offset: Offset(0, 1.5),
                    color: Colors.black.withOpacity(0.15),
                  ),
                ],
              ),
              child: MediaPlayer(
                onPressed: () {
                  setState(
                    () {
                      isExpanded = !isExpanded;
                      if (!isExpanded) {
                        controller.reverse().whenComplete(
                          () {
                            _overlayEntry?.remove();
                            _overlayEntry = null;
                          },
                        );
                      }
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 15,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                spreadRadius: 3,
                offset: Offset(0, 1.5),
                color: Colors.black.withOpacity(0.15),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              title: Text('Title', style: GoogleFonts.montserrat()),
              subtitle: Text('SubTitle', style: GoogleFonts.montserrat()),
              trailing: Icon(size: 15, FontAwesomeIcons.chevronUp),
              onTap: () {
                setState(
                  () {
                    isExpanded = !isExpanded;
                    if (isExpanded) {
                      _overlayEntry = _createOverlayEntry();
                      Overlay.of(context).insert(_overlayEntry!);
                      controller.forward();
                    } else {
                      controller.reverse().whenComplete(
                        () {
                          _overlayEntry?.remove();
                          _overlayEntry = null;
                        },
                      );
                    }
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
