import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 35, horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
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
                            icon: Icon(FontAwesomeIcons.chevronDown, size: 20),
                          ),
                          Container(),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              size: 20,
                              FontAwesomeIcons.ellipsisVertical,
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2.35,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      Divider(thickness: 0.15),
                      Container(),
                      Container(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
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
                  title: Text(
                    'Title',
                    style: GoogleFonts.montserrat(),
                  ),
                  subtitle: Text(
                    'SubTitle',
                    style: GoogleFonts.montserrat(),
                  ),
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
        ),
      ],
    );
  }
}
