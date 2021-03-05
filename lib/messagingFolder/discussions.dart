import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DiscussionsPage extends StatefulWidget {

  String currentUser;
  String currentUserUsername;
  String currentUserPhoto;
  String notificationsToken;

  DiscussionsPage({
    Key key, 
    this.currentUser, 
    this.currentUserUsername,
    this.currentUserPhoto,
    this.notificationsToken,
    }) : super(key: key);


  @override
  DiscussionsPageState createState() => DiscussionsPageState();
}


class DiscussionsPageState extends State<DiscussionsPage> {


@override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body: new NestedScrollView(
        scrollDirection: Axis.vertical,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget> [
            new CupertinoSliverNavigationBar(
              actionsForegroundColor: Color(0xFF5CE1E6),
              automaticallyImplyTitle: true,
              automaticallyImplyLeading: true,
              transitionBetweenRoutes: true,
              backgroundColor: Colors.black.withOpacity(0.7),
              largeTitle: new Text('Discussions',
                  style: new TextStyle(color: Colors.white),
                  ),
            ),
          ];
        }, 
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
        child: new Container(
        ),
        ),
      ),
    );
  }
}