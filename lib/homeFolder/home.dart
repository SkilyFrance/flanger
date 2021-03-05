import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flanger_app/homeFolder/postDetails.dart';
import 'package:flanger_app/homeFolder/publication.dart';
import 'package:flanger_app/homeFolder/requestList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:webview_flutter/webview_flutter.dart';


class HomePage extends StatefulWidget {

  String currentUser;
  String currentUserUsername;
  String currentUserPhoto;
  String notificationsToken;
  bool premiumVersion;

  HomePage({
    Key key, 
    this.currentUser, 
    this.currentUserUsername,
    this.currentUserPhoto,
    this.premiumVersion,
    this.notificationsToken,
    }) : super(key: key);


  @override
  HomePageState createState() => HomePageState();
}


class HomePageState extends State<HomePage> {

  ScrollController _listIssuesController = new ScrollController();


  //SnackBar 
  final likedSnackBar = new SnackBar(
    backgroundColor: Color(0xFF5CE1E6),
    content: new Text('+1 for this post 🚀',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
    ));

  final alreadyLiked = new SnackBar(
  backgroundColor: Color(0xFF5CE1E6),
  content: new Text('Already liked 🚀',
  textAlign: TextAlign.center,
  style: new TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
  ));

  final dislikedSnackBar = new SnackBar(
    backgroundColor: Colors.deepPurpleAccent,
    content: new Text('-1 for this post 😭 ',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
    ));

  final alreadydislikedSnackBar = new SnackBar(
    backgroundColor: Colors.deepPurpleAccent,
    content: new Text('Already disliked 😭 ',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
    ));

  final noSoundCloudSnackBar = new SnackBar(
    backgroundColor: Colors.deepPurpleAccent,
    content: new Text('No SoundCloud linked 🥺',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
    ));

  //

  int tabChoosen = 0;
  int categoryPosted = 0;
  bool _expandModalBottomSheet = false;

  final Set<Factory> gestureRecognizers = [Factory(() => EagerGestureRecognizer())].toSet();
  UniqueKey _key = UniqueKey();

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
    _listIssuesController = new ScrollController();
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
              backgroundColor: Colors.black,
              largeTitle: new Text('Home',
                  style: new TextStyle(color: Colors.white),
              ),
              trailing: new Material(
                color: Colors.transparent,
                child: new IconButton(
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                icon: new Icon(Icons.add_circle_outline_rounded, color: Color(0xFF5CE1E6), size: 25.0),
                onPressed: () {
                  Navigator.push(context, 
                  new CupertinoPageRoute(
                    builder: (context) => new PublicationPage(
                      currentUser: widget.currentUser,
                      currentUserUsername: widget.currentUserUsername,
                      currentUserPhoto: widget.currentUserPhoto,
                      currentSoundCloud: currentSoundCloud,
                      currentNotificationsToken: currentNotificationsToken,
                    )));
                },
              ),
                ),
            ),
          ];
        }, 
        body: new Container(
          child: new SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 150.0),
            scrollDirection: Axis.vertical,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.04,
                  width: MediaQuery.of(context).size.width,
                ),
                new CupertinoSegmentedControl(
                  unselectedColor: Colors.transparent,
                  borderColor: Colors.grey[900],
                  selectedColor: Colors.deepPurpleAccent,
                  children: <int, Widget>{
                    0: new Padding(
                      padding: EdgeInsets.all(8.0),
                    child: new Container(
                      child: new Text("NEW",
                      style: new TextStyle(color: tabChoosen == 0 ? Colors.white : Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w700),
                      ),
                    ),
                    ),
                    1: new Padding(
                      padding: EdgeInsets.all(8.0),
                      child: new Container(
                      child:  new Text("TREND",
                      style: new TextStyle(color: tabChoosen == 1 ? Colors.white : Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w700),
                      ),
                    ),
                    ),
                  },
                  groupValue: tabChoosen,
                  onValueChanged: (value) {
                    setState(() {
                    tabChoosen = value;
                    });
                }),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.05,
                  width: MediaQuery.of(context).size.width,
                ),
                new StreamBuilder(
                  stream: 
                  FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy(tabChoosen == 0 ? 'timestamp' : 'likes', descending: tabChoosen == 0 ? true : true)
                    .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if(snapshot.hasError) {
                      return  new Container(
                        height: MediaQuery.of(context).size.height*0.40,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: new Center(
                          child: new Text('No data, please restart.',
                          style: new TextStyle(color: Colors.grey[700], fontSize: 18.0, fontWeight: FontWeight.bold,
                          ),
                        ),
                      ));}
                      if(!snapshot.hasData || snapshot.data.docs.isEmpty) {
                      return  new Container(
                        height: MediaQuery.of(context).size.height*0.40,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: new Center(
                          child: new Text('No data, post now.',
                          style: new TextStyle(color: Colors.grey[700], fontSize: 18.0, fontWeight: FontWeight.bold,
                          ),
                        ),
                      ));
                      }
                      return new Container(
                      child: new ListView.builder(
                        shrinkWrap: true,
                        physics: new NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(top: 10.0),
                        controller: _listIssuesController,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          var ds = snapshot.data.docs[index];
                          List<dynamic> arrayOfLikes = ds['likedBy'];
                          List<dynamic> arrayOfDislikes = ds['dislikedBy'];
                          return new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          new Padding(
                            padding: EdgeInsets.only(top: 20.0),
                          child: new InkWell(
                            splashColor: Colors.grey[900],
                            highlightColor: Colors.grey[900],
                            focusColor: Colors.grey[900],
                            onTap: () {
                              Navigator.push(context, 
                              new CupertinoPageRoute(
                                builder: (context) => new PostDetailsPage(
                                  heroTag: ds['postID'],
                                  //CurrentUser datas
                                  currentUser: widget.currentUser,
                                  currentUserPhoto: widget.currentUserPhoto,
                                  currentUserUsername: widget.currentUserUsername,
                                  currentSoundCloud: currentSoundCloud,
                                  //PostData
                                  postID: ds['postID'],
                                  postSubject: ds['subject'],
                                  postBody: ds['body'],
                                  typeOfPost: ds['typeOfPost'],
                                  postTimestamp: ds['timestamp'],
                                  postLikes: ds['likes'],
                                  postDislikes: ds['dislikes'],
                                  postComments: ds['comments'],
                                  arrayOfLikes: ds['likedBy'],
                                  arrayOfDislikes: ds['dislikedBy'],
                                  arrayOfComments: ds['commentedBy'],
                                  //AdminData
                                  adminSoundCloud: ds['adminSoundCloud'],
                                  adminUsername: ds['adminUsername'],
                                  adminProfilephoto: ds['adminProfilephoto'],
                                  adminUID: ds['adminUID'],
                                  adminNotificationsToken: ds['adminNotificationsToken'],
                                )));
                            },
                          child: new Container(
                            color: Colors.transparent,
                            child: new Padding(
                              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                              new ListTile(
                                  title: new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      new Container(
                                        color: Colors.transparent,
                                        child: new Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                      new Padding(
                                        padding: EdgeInsets.only(bottom: 10.0),
                                      child: new InkWell(
                                    onTap: () {
                                      if(ds['adminSoundCloud'] == 'null') {
                                        Scaffold.of(context).showSnackBar(noSoundCloudSnackBar);
                                      } else {
                                    showBarModalBottomSheet(
                                      shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(0.0)
                                      ),
                                      context: context, 
                                      builder: (context){
                                        return StatefulBuilder(
                                          builder: (BuildContext context, StateSetter modalSetState) {
                                          return new Container(
                                          height: MediaQuery.of(context).size.height*0.80,
                                          width: MediaQuery.of(context).size.width,
                                          color: Color(0xFF181818),
                                          child: new Stack(
                                          children: [
                                            new Positioned(
                                              top: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 0.0,
                                            child: new Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                new Container(
                                                  height: MediaQuery.of(context).size.height*0.06,
                                                  width: MediaQuery.of(context).size.width,
                                                  color: Colors.white,
                                                  child: new Center(
                                                    child: new Text('SoundCloud',
                                                    style: new TextStyle(color: Colors.grey[700], fontSize: 16.0, fontWeight: FontWeight.bold),
                                                    )
                                                  ),
                                                ),
                                                new Container(
                                                  height: MediaQuery.of(context).size.height*0.74,
                                                  width: MediaQuery.of(context).size.width,
                                                  child: new WebView(
                                                    key: _key,
                                                    javascriptMode: JavascriptMode.unrestricted,
                                                    initialUrl: ds['adminSoundCloud'],
                                                    gestureRecognizers: gestureRecognizers,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ),
                                            ],
                                          ),
                                          );
                                          },
                                        );
                                      });
                                      }
                                    },
                                  child: new Container(
                                    height: 40.0,
                                    width: 40.0,
                                    decoration: new BoxDecoration(
                                    color: Colors.grey[900],
                                    shape: BoxShape.circle,
                                    ),
                                    child: new ClipOval(
                                      child: ds['adminProfilephoto'] != null
                                      ? new Image.network(ds['adminProfilephoto'], fit: BoxFit.cover)
                                      : new Container(),
                                    ),
                                  ))),
                                  new Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        new Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                        new Padding(
                                          padding: EdgeInsets.only(bottom: 0.0),
                                          child: new Text(ds['adminUsername'] != null
                                          ? ds['adminUsername']
                                          : 'Unknown',
                                          style: new TextStyle(color: Color(0xFF5CE1E6), fontSize: 14.0, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                          ],
                                        ),
                                        new Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                          new Padding(
                                            padding: EdgeInsets.only(top: 2.0, bottom: 5.0),
                                            child: new Text(ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inMinutes < 1
                                              ? 'few sec ago'
                                              : ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inMinutes < 60
                                              ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inMinutes.toString() + ' min ago'
                                              : ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inMinutes >= 60
                                              ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inHours.toString() + ' hours ago'
                                              : ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inHours >= 24
                                              ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inDays.toString() + ' days ago'
                                              : '',
                                              textAlign: TextAlign.left,
                                              style: new TextStyle(color: Colors.grey, fontSize: 10.0, fontWeight: FontWeight.bold),
                                            ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                        ),
                                        ],
                                        ),
                                      ),
                                      new Padding(
                                        padding: EdgeInsets.only(right: 20.0),
                                      child: new Container(
                                        child: ds['typeOfPost'] != null && ds['typeOfPost'] == 'issue'
                                        ? new RichText(
                                          text: new TextSpan(
                                            text: 'Issue',
                                            style: new TextStyle(color: Colors.grey[800], fontSize: 14.0, fontWeight: FontWeight.bold,
                                          ),
                                          children: [
                                            new TextSpan(
                                              text: ' 💥',
                                            style: new TextStyle(fontSize: 16.0)
                                            ),
                                          ]
                                          ))
                                        : ds['typeOfPost'] != null && ds['typeOfPost'] == 'tip'
                                        ? new RichText(
                                          text: new TextSpan(
                                            text: 'Tip',
                                            style: new TextStyle(color: Colors.grey[800], fontSize: 14.0, fontWeight: FontWeight.bold,
                                          ),
                                          children: [
                                            new TextSpan(
                                              text: ' 💡',
                                            style: new TextStyle(fontSize: 16.0)
                                            ),
                                          ]
                                          ))
                                        : new Text(''),
                                      )),
                                    ],
                                  ),
                                  subtitle: new Padding(
                                    padding: EdgeInsets.only(top: 5.0),
                                    child: new RichText(
                                      textAlign: TextAlign.justify,
                                    text: new TextSpan(
                                      text: ds['subject'] != null
                                      ? ds['subject'] + ' -'
                                      : '(error on this title)',
                                      style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold,
                                      height: 1.1,
                                      ),
                                      children: [
                                        new TextSpan(
                                          text: ds['body'] != null
                                           ? '  ' + ds['body']
                                           : '   ' + ' (Error on this message)',
                                          style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.normal,
                                          height: 1.3,
                                          ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ),
                                  ),
                                  //Comments //Likes //Dislikes //Report
                                  new Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                  child: new Container(
                                    height: MediaQuery.of(context).size.height*0.05,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.transparent,
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        new Container(
                                          height: MediaQuery.of(context).size.height*0.05,
                                          //width: MediaQuery.of(context).size.width,
                                          color: Colors.transparent,
                                          child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                        //Divider
                                      new Container(
                                          height: MediaQuery.of(context).size.height*0.05,
                                          width: MediaQuery.of(context).size.width*0.04,
                                        ),
                                        new Container(
                                          child: new IconButton(
                                            icon: Icon(Icons.arrow_upward,
                                            size: 20.0,
                                            color: arrayOfLikes.contains(widget.currentUser) ? Colors.greenAccent : Colors.grey,
                                            ), 
                                            onPressed: () {
                                              if(arrayOfLikes.contains(widget.currentUser)) {
                                                Scaffold.of(context).showSnackBar(alreadyLiked);
                                              } else {
                                                if(arrayOfDislikes.contains(widget.currentUser)) {
                                                likeRequest(
                                                  ds['postID'], 
                                                  ds['likes'], 
                                                  widget.currentUser, 
                                                  ds['likedBy']);
                                                deleteDislikeRequest(
                                                  ds['postID'], 
                                                  ds['dislikes'], 
                                                  widget.currentUser, 
                                                  ds['dislikedBy']);
                                                Scaffold.of(context).showSnackBar(likedSnackBar);
                                                } else {
                                                likeRequest(
                                                  ds['postID'], 
                                                  ds['likes'], 
                                                  widget.currentUser, 
                                                  ds['likedBy']);
                                                Scaffold.of(context).showSnackBar(likedSnackBar);
                                                }
                                              }
                                            },
                                            ),
                                        ),
                                        new Padding(
                                          padding: EdgeInsets.only(left: 0.0),
                                          child: new Text(ds['likes'] != null
                                          ? ds['likes'].toString()
                                          : '',
                                          style: new TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.bold),
                                          ),
                                          ),
                                        //Divider
                                        new Container(
                                          height: MediaQuery.of(context).size.height*0.05,
                                          width: MediaQuery.of(context).size.width*0.03,
                                        ),
                                        new Container(
                                          child: new IconButton(
                                            icon: Icon(Icons.arrow_downward,
                                            size: 20.0,
                                            color: arrayOfDislikes.contains(widget.currentUser) ? Colors.redAccent : Colors.grey
                                            ), 
                                            onPressed: () {
                                              if(arrayOfDislikes.contains(widget.currentUser)) {
                                                Scaffold.of(context).showSnackBar(alreadydislikedSnackBar);
                                              } else {
                                                if(arrayOfLikes.contains(widget.currentUser)) {
                                                  dislikeRequest(
                                                  ds['postID'], 
                                                  ds['dislikes'], 
                                                  widget.currentUser, 
                                                  ds['dislikedBy']);
                                                  deletelikeRequest(
                                                  ds['postID'], 
                                                  ds['likes'], 
                                                  widget.currentUser, 
                                                  ds['likedBy']);
                                                  Scaffold.of(context).showSnackBar(dislikedSnackBar);
                                                } else {
                                                  dislikeRequest(
                                                  ds['postID'], 
                                                  ds['dislikes'], 
                                                  widget.currentUser, 
                                                  ds['dislikedBy']);
                                                  Scaffold.of(context).showSnackBar(dislikedSnackBar);
                                                }
                                              }
                                            },
                                            ),
                                        ),
                                        new Padding(
                                          padding: EdgeInsets.only(left: 0.0),
                                          child: new Text(ds['dislikes'] != null
                                          ? ds['dislikes'].toString()
                                          : '',
                                          style: new TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.bold),
                                          ),
                                          ),
                                        //Divider
                                        new Container(
                                          height: MediaQuery.of(context).size.height*0.05,
                                          width: MediaQuery.of(context).size.width*0.03,
                                        ),
                                        new Container(
                                          child: new IconButton(
                                            icon: Icon(Icons.chat_rounded,
                                            size: 20.0,
                                            color: Colors.white,
                                            ), 
                                            onPressed: () {},
                                            ),
                                        ),
                                        new Padding(
                                          padding: EdgeInsets.only(left: 0.0),
                                          child: new Text(ds['comments'] != null
                                          ? ds['comments'].toString()
                                          : '',
                                          style: new TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.bold),
                                          ),
                                          ),
                                            ],
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ),
                          ),
                        ),
                        new Divider(
                          height: 3.0,
                          color: Colors.grey[900],
                        ),
                          ],
                          );
                      })
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}