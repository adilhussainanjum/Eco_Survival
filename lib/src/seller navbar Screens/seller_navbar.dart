import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/seller%20navbar%20Screens/Home/seller_home.dart';
import 'package:bmind/src/views/nav_bar_screens/Home/community.dart';
import 'package:bmind/src/views/nav_bar_screens/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class SellerNavBar extends StatefulWidget {
  SellerNavBar({Key key, this.initIndex}) : super(key: key);
  int initIndex;
  @override
  _SellerNavBarState createState() => _SellerNavBarState();
}

class _SellerNavBarState extends State<SellerNavBar> {
  PersistentTabController _controller;
  Widget wid = CommunityScreen();
  List<Widget> _buildScreens = [
    SellerHomeScreen(),
    CommunityScreen(),
    ProfileScreen()
  ];

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: widget.initIndex ?? 0);
    super.initState();
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: AppColor.primaryColor,
        inactiveColorPrimary: AppColor.navBarGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person_3),
        title: ("Community"),
        activeColorPrimary: AppColor.primaryColor,
        inactiveColorPrimary: AppColor.navBarGrey,
      ),
      // PersistentBottomNavBarItem(
      //   icon: Icon(CupertinoIcons.chat_bubble),
      //   title: ("Community"),
      //   activeColorPrimary: AppColor.primaryColor,
      //   inactiveColorPrimary: AppColor.navBarGrey,
      // ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person),
        title: ("Profile"),
        activeColorPrimary: AppColor.primaryColor,
        inactiveColorPrimary: AppColor.navBarGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens,
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: AppColor.navBarWhite,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: false,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        colorBehindNavBar: AppColor.navBarWhite,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 700),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 500),
      ),
      navBarStyle: NavBarStyle.style3,
    );
  }
}
