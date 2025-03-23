import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fintech_app/state/appstate.dart';
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
    return _iconList();
  }
}

// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({super.key});
//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar>
//     with SingleTickerProviderStateMixin {
//   bool isExpanded = false;
//   OverlayEntry? _overlayEntry;
//   late Animation<double> animation;
//   late AnimationController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 500),
//     );

//     animation = CurvedAnimation(
//       parent: controller,
//       curve: Curves.easeInOutCubic,
//     );
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     _overlayEntry?.remove();
//     super.dispose();
//   }

//   OverlayEntry _createOverlayEntry() {
//     return OverlayEntry(
//       builder: (context) => Stack(
//         children: [
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 isExpanded = false;
//                 controller.reverse().whenComplete(() {
//                   _overlayEntry?.remove();
//                   _overlayEntry = null;
//                 });
//               });
//             },
//             child: Container(
//               color: Colors.black.withOpacity(0.5 * animation.value),
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height,
//             ),
//           ),
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: AnimatedBuilder(
//               animation: animation,
//               builder: (context, child) {
//                 return Container(
//                   height: animation.value * MediaQuery.of(context).size.height +
//                       (1 - animation.value) * 75,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20),
//                       topRight: Radius.circular(20),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         blurRadius: 5,
//                         spreadRadius: 2,
//                         offset: Offset(0, -2),
//                         color: Colors.black.withOpacity(0.2),
//                       ),
//                     ],
//                   ),
//                   child: MediaPlayer(
//                     onPressed: () {
//                       setState(() {
//                         isExpanded = !isExpanded;
//                         if (!isExpanded) {
//                           controller.reverse().whenComplete(() {
//                             _overlayEntry?.remove();
//                             _overlayEntry = null;
//                           });
//                         }
//                       });
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             blurRadius: 5,
//             spreadRadius: 1,
//             offset: Offset(0, 2),
//             color: Colors.black.withOpacity(0.1),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: () {
//               setState(() {
//                 isExpanded = !isExpanded;
//                 if (isExpanded) {
//                   _overlayEntry = _createOverlayEntry();
//                   Overlay.of(context).insert(_overlayEntry!);
//                   controller.forward();
//                 } else {
//                   controller.reverse().whenComplete(() {
//                     _overlayEntry?.remove();
//                     _overlayEntry = null;
//                   });
//                 }
//               });
//             },
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: Colors.blue[100],
//                       borderRadius: BorderRadius.circular(10),
//                       image: DecorationImage(
//                         fit: BoxFit.cover,
//                         image: NetworkImage(
//                           'https://images.pexels.com/photos/1389429/pexels-photo-1389429.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           'Sample Audio',
//                           style: GoogleFonts.montserrat(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.grey[800],
//                           ),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           'Artist Name',
//                           style: GoogleFonts.montserrat(
//                             fontSize: 12,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: Icon(
//                           FontAwesomeIcons.play,
//                           size: 18,
//                           color: Colors.blue[600],
//                         ),
//                         onPressed: () {},
//                       ),
//                       Icon(
//                         FontAwesomeIcons.chevronUp,
//                         size: 16,
//                         color: Colors.grey[600],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
