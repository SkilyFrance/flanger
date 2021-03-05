import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flanger_app/notificationsFolder/notificationsDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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
                          child: new InkWell(
                            splashColor: Colors.grey[900],
                            highlightColor: Colors.grey[900],
                            focusColor: Colors.grey[900],
                            onTap: () {
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