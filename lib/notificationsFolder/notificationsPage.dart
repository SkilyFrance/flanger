import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flanger_app/notificationsFolder/notificationsDetails.dart';
import 'package:flanger_app/permissions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class NotificationsPage extends StatefulWidget {

  String currentUser;
  String currentUserUsername;
  String currentUserPhoto;
  String notificationsToken;

  NotificationsPage({
    Key key, 
    this.currentUser, 
    this.currentUserUsername,
    this.currentUserPhoto,
    this.notificationsToken,
    }) : super(key: key);


  @override
  NotificationsPageState createState() => NotificationsPageState();
}


class NotificationsPageState extends State<NotificationsPage> {

FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
String notificationsToken;
bool notificationInProgress = false;


  final notificationActivated = new SnackBar(
    backgroundColor: Color(0xFF5CE1E6),
    content: new Text('Successfully activated 🔔',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
    ));

notificationAlertDialog() {
  return showDialog(
    barrierDismissible: false,
    context: context, 
    builder: (_) => new CupertinoAlertDialog(
      title: new Text('Notifications',
      style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold,
      height: 1.3,
      ),
      ),
      content: new Container(
        child: new Padding(
          padding: EdgeInsets.all(8.0),
          child: new CupertinoActivityIndicator(radius: 8.0, animating: true),
          ),
      ),
    ),
  );
}

  String currentSoundCloud;
  String currentNotificationsToken;
  getCurrentSoundCloud() {
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .get().then((value) {
        if(value.exists) {
          setState(() {
            currentSoundCloud = value.data()['soundCloud'];
            currentNotificationsToken = value.data()['notificationsToken'];
          });
        }
      });
  }

@override
  void initState() {
    print(widget.currentUser);
    print(widget.currentUserUsername);
    getCurrentSoundCloud();
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
              transitionBetweenRoutes: false,
              backgroundColor: Colors.black.withOpacity(0.7),
              largeTitle: new Text('Notifications',
                  style: new TextStyle(color: Colors.white),
                  ),
                  trailing: new Material(
                    color: Colors.transparent,
                    child: new IconButton(
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                    icon: new Icon(CupertinoIcons.bell, color: Colors.grey, size: 25.0),
                    onPressed: () async {
                      var notificationPermission = await Permission.notification.status;
                      if(notificationPermission.isGranted) {
                        notificationAlertDialog();
                        var notificationGetToken = await _firebaseMessaging.getToken();
                        setState(() {
                          notificationsToken = notificationGetToken;
                        });
                        FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.currentUser)
                          .update({
                            'notificationsToken': notificationsToken,
                          }).whenComplete(() {
                            print('Cloud Firestore : notificationsToken = $notificationsToken');
                            _firebaseMessaging.subscribeToTopic('sendNotifications').whenComplete(() => print('Notifications topic subscribed'));
                            Navigator.pop(context);
                            Scaffold.of(context).showSnackBar(notificationActivated);
                          });
                      }
                      if(notificationPermission.isUndetermined) {
                        await Permission.notification.request();
                        if(await Permission.notification.request().isGranted) {
                        notificationAlertDialog();
                        var notificationGetToken = await _firebaseMessaging.getToken();
                        setState(() {
                          notificationsToken = notificationGetToken;
                        });
                        FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.currentUser)
                          .update({
                            'notificationsToken': notificationsToken,
                          }).whenComplete(() {
                            print('Cloud Firestore : notificationsToken = $notificationsToken');
                            _firebaseMessaging.subscribeToTopic('sendNotifications').whenComplete(() => print('Notifications topic subscribed'));
                            Navigator.pop(context);
                            Scaffold.of(context).showSnackBar(notificationActivated);
                          });
                        }
                        if(await Permission.notification.request().isDenied || await Permission.notification.request().isRestricted) {
                          PermissionDemandClass().iosDialogNotifications(context);
                        }
                      }
                      if(notificationPermission.isDenied || notificationPermission.isRestricted) {
                        PermissionDemandClass().iosDialogNotifications(context);
                      }
                    },
                  ),
                ),
            ),
          ];
        }, 
        body: new Container(
          child: new StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').doc(widget.currentUser).collection('notifications').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.hasError) {
                return new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new Container(
                      height: MediaQuery.of(context).size.height*0.60,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                      child: new Center(
                        child: new Text('No data, please restart.',
                        style: new TextStyle(color: Colors.grey[700], fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                );
              }
              if(!snapshot.hasData || snapshot.data.docs.isEmpty) {
                return new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new Container(
                      height: MediaQuery.of(context).size.height*0.60,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Text('No notification yet',
                          style: new TextStyle(color: Colors.grey[700], fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: new Text('🔔',
                            style: new TextStyle(fontSize: 30.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return new Container(
                child: new ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var ds = snapshot.data.docs[index];
                    return new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        new Container(
                         color: ds['alreadySeen'] == false ? Colors.deepPurpleAccent.withOpacity(0.2) : Colors.transparent,
                          child: new InkWell(
                            splashColor: Colors.grey[900],
                            highlightColor: Colors.grey[900],
                            focusColor: Colors.grey[900],
                            onTap: () {
                              if(ds['alreadySeen'] == false) {
                                FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.currentUser)
                                  .collection('notifications')
                                  .doc(ds['notificationID'])
                                  .update({
                                    'alreadySeen': true
                                  }).whenComplete(() => print('Cloud Firestore : notificationID, already seen set to true'));
                              } else {}
                              Navigator.push(context, 
                              new CupertinoPageRoute(
                                builder: (context) => new NotificationsDetails(
                                  currentUser: widget.currentUser,
                                  currentUserUsername: widget.currentUserUsername,
                                  currentUserPhoto: widget.currentUserPhoto,
                                  currentSoundCloud: currentSoundCloud,
                                  postID: ds['postID'],
                                  heroTag: ds['postID'],
                                )));
                            },
                        child: new ListTile(
                          focusColor: Colors.grey[900],
                          leading: new Container(
                            height: MediaQuery.of(context).size.height*0.05,
                            width: MediaQuery.of(context).size.height*0.05,
                            decoration: new BoxDecoration(
                              color: Colors.grey[900],
                              shape: BoxShape.circle,
                            ),
                            child: new ClipOval(
                            child: ds['lastUserProfilephoto'] != null
                            ? new Image.network(ds['lastUserProfilephoto'], fit: BoxFit.cover)
                            : new Container(),
                          )),
                          title: new Text(
                            ds['title'] != null
                            ? ds['title']
                            : 'No title',
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(fontSize: 15.0, color: Colors.grey, fontWeight: FontWeight.normal),
                          ),
                          subtitle: new Text(
                            ds['body'] != null
                            ? ds['lastUserUsername'] + ' ' + ds['body']
                            : 'new action on this post',
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: new Text(
                            ds['body'] == 'has commented this post'
                            ? '💬'
                            : ds['body'] == 'has liked this post'
                            ? '👍'
                            : '',
                            style: new TextStyle(fontSize: 25.0),
                          ),
                        ))),
                        new Divider(height: 1.0, color: Colors.grey[900].withOpacity(0.8)),
                      ],
                    );
                  },
                ),
              );
            },
            ),
        ),
      ),
    );
  }
}