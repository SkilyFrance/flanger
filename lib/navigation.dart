import 'package:flanger_app/messagingFolder/discussions.dart';
import 'package:flanger_app/notificationsFolder/notificationsPage.dart';
import 'package:flanger_app/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'homeFolder/home.dart';



class NavigationPage extends StatefulWidget {

  String currentUser;
  String currentUserUsername;
  String currentUserPhoto;
  String notificationsToken;

  NavigationPage({
    Key key, 
    this.currentUser, 
    this.currentUserUsername,
    this.currentUserPhoto,
    this.notificationsToken,
    }) : super(key: key);

  @override 
  NavigationPageState createState() => NavigationPageState();
}

class NavigationPageState extends State<NavigationPage> {
 

  @override 
  void initState() {
    print('currentUser = '+ widget.currentUser);
    currentScreen = new HomePage(
      currentUser: widget.currentUser,
      currentUserPhoto: widget.currentUserPhoto,
      currentUserUsername: widget.currentUserUsername,
    );
    currentTab = 0;
    super.initState();
  }

  //Active tab initialization
  int currentTab = 0; 
  final List<Widget> screens = [
    new HomePage(),
    new NotificationsPage(),
    new ProfilePage(),
  ];
  final PageStorageBucket bucket = new PageStorageBucket();
  Widget currentScreen;


  @override 
  Widget build(BuildContext context) {
    return new CupertinoTabScaffold(
      tabBar: new CupertinoTabBar(
        activeColor: Colors.white,
        backgroundColor: Colors.black.withOpacity(0.7),
        items: [
            new BottomNavigationBarItem(icon: new Icon(CupertinoIcons.house), label: 'Home'),
            new BottomNavigationBarItem(icon: new Icon(CupertinoIcons.bell), label: 'Notifications'),
            new BottomNavigationBarItem(icon: new Icon(CupertinoIcons.profile_circled), label: 'Profile'),
        ],
        ), 
      tabBuilder: (context, index) {
            switch (index) {
              case 0:
                return HomePage(
                  currentUser: widget.currentUser,
                  currentUserPhoto: widget.currentUserPhoto,
                  currentUserUsername: widget.currentUserUsername,
                );
                break;
              case 1:
                return NotificationsPage(
                  currentUser: widget.currentUser,
                  currentUserPhoto: widget.currentUserPhoto,
                  currentUserUsername: widget.currentUserUsername,
                );
                break;
              default:
                return ProfilePage(
                  currentUser: widget.currentUser,
                  currentUserPhoto: widget.currentUserPhoto,
                  currentUserUsername: widget.currentUserUsername,
                );
                break;
            }
      },
      );
  }
}