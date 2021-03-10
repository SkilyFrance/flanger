import 'dart:async';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  CollectionReference reference = FirebaseFirestore.instance.collection('users');


  bool newNotification = false;
  newNotificationsListener() {
    return new StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(widget.currentUser).collection('notifications').snapshots(),
      builder: (BuildContext context, snapshot) {
        if(snapshot.data.documents['alreadySeen'] == false) {
          setState(() {
            newNotification = true;
          });
        } else {
          setState(() {
            newNotification = false;
          });
        }
      });
  }
 

  @override 
  void initState() {
    reference.doc(widget.currentUser).collection('notifications').snapshots().listen((event) {
      event.docChanges.forEach((element) {
        if(element.doc['alreadySeen'] == false) {
          setState(() {
            newNotification = true;
          });
        } else {
          setState(() {
            newNotification = false;
          });
        }
       });
    });
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
            new BottomNavigationBarItem(label: 'Home', icon: new Badge(shape: BadgeShape.circle,badgeColor: Colors.transparent, position: BadgePosition.topEnd(top: 0, end: -10), padding: EdgeInsets.all(6),
            child: new Icon(CupertinoIcons.house))),
            new BottomNavigationBarItem(label: 'Notifications', icon: new Badge(shape: BadgeShape.circle,badgeColor: newNotification == true ? Colors.red : Colors.transparent, position: BadgePosition.topEnd(top: 0, end: -10), padding: EdgeInsets.all(6),
            child: new Icon(CupertinoIcons.bell))),
            new BottomNavigationBarItem(label: 'Profile', icon: new Badge(shape: BadgeShape.circle,badgeColor: Colors.transparent, position: BadgePosition.topEnd(top: 0, end: -10), padding: EdgeInsets.all(6),
            child: new Icon(CupertinoIcons.profile_circled))),
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