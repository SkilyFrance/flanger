import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flanger_app/homeFolder/requestList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';



class PostDetailsPage extends StatefulWidget {

  //CurrentUser datas
  String currentUser;
  String currentUserUsername;
  String currentUserPhoto;
  String currentSoundCloud;

  //Post datas
  String postID;
  String postSubject;
  String postBody;
  String typeOfPost;
  int postTimestamp;
  int postLikes;
  int postDislikes;
  int postComments;
  List<dynamic> arrayOfLikes;
  List<dynamic> arrayOfDislikes;
  List<dynamic> arrayOfComments;
  Map reactedBy;
  //AdminData
  String adminSoundCloud;
  String adminProfilephoto;
  String adminUsername;
  String adminUID;
  String adminNotificationsToken;


  //HeroTag
  final String heroTag;


  PostDetailsPage({
    Key key, 
    this.currentUser, 
    this.currentUserUsername,
    this.currentUserPhoto,
    this.currentSoundCloud,
    this.heroTag,
    this.postID,
    this.postSubject,
    this.postBody,
    this.postTimestamp,
    this.postLikes,
    this.postDislikes,
    this.postComments,
    this.typeOfPost,
    this.arrayOfLikes,
    this.arrayOfDislikes,
    this.arrayOfComments,
    this.reactedBy,
    this.adminSoundCloud,
    this.adminProfilephoto,
    this.adminUsername,
    this.adminUID,
    this.adminNotificationsToken,
    }) : super(key: key);



  @override
  PostDetailsPageState createState() => PostDetailsPageState();
}


class PostDetailsPageState extends State<PostDetailsPage> {

  
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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


 launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
 }



  ScrollController _listOfComments = new ScrollController();
  TextEditingController _commentTextController = new TextEditingController();
  FocusNode _textFieldFocusNode = new FocusNode();
  bool _textFieldOnChanged = false;
  
  final Set<Factory> gestureRecognizers = [Factory(() => EagerGestureRecognizer())].toSet();
  UniqueKey _key = UniqueKey();


  // Get current user notification token
  String currentUserNotificationsToken;
  getCurrentUserNotificationsToken() {
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .get().then((value) {
        if(value.exists) {
          setState(() {
            currentUserNotificationsToken = value.data()['notificationsToken'];
          });
        }
      });
  }


@override
  void initState() {
    getCurrentUserNotificationsToken();
    print('Admin notificatinsToken = ' + widget.adminNotificationsToken);
    print('username = ' + widget.currentUserUsername);
    _listOfComments = new ScrollController();
    _commentTextController = new TextEditingController();
    _textFieldFocusNode = new FocusNode();
    print(widget.currentUserUsername);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: new CupertinoNavigationBar(
       // heroTag: ,
        transitionBetweenRoutes: false,
        backgroundColor: Colors.black.withOpacity(0.5),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios_rounded, color: Colors.grey, size: 25.0),
          onPressed: () {Navigator.pop(context);}),
          middle: new Text('Post',
          style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
          ),
            ),
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
        child: new Container(
          child: new Stack(
            children: [
              new Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: new Container(
          child: new SingleChildScrollView(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.04,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                      color: Colors.transparent,
                      child: new Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          new Padding(
                            padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                              child: new Text(widget.postSubject != null
                              ? widget.postSubject
                              : '',
                              textAlign: TextAlign.justify,
                              style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold,
                              height: 1.3,
                              ),
                            ),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(top: 20.0),
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
                                  child: new Container(
                                    height: 40.0,
                                    width: 40.0,
                                    decoration: new BoxDecoration(
                                    color: Colors.grey[900],
                                    shape: BoxShape.circle,
                                    ),
                                    child: new ClipOval(
                                      child: widget.adminProfilephoto != null
                                      ? new Image.network(widget.adminProfilephoto, fit: BoxFit.cover)
                                      : new Container(),
                                    ),
                                  )),
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
                                          child: new Text(widget.adminUsername != null
                                          ? widget.adminUsername
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
                                            child: new Text(widget.postTimestamp != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.postTimestamp)).inMinutes < 1
                                              ? 'few sec ago'
                                              : widget.postTimestamp != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.postTimestamp)).inMinutes < 60
                                              ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.postTimestamp)).inMinutes.toString() + ' min ago'
                                              : widget.postTimestamp != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.postTimestamp)).inMinutes >= 60
                                              ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.postTimestamp)).inHours.toString() + ' hours ago'
                                              : widget.postTimestamp != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.postTimestamp)).inHours >= 24
                                              ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.postTimestamp)).inDays.toString() + ' days ago'
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
                                        child: widget.typeOfPost != null && widget.typeOfPost == 'issue'
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
                                        : widget.typeOfPost != null && widget.typeOfPost == 'tip'
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
                                  subtitle: widget.postBody != null
                                  ? new Padding(
                                    padding: EdgeInsets.only(top: 5.0),
                                    child: new Linkify(
                                      onOpen: (urlToOpen) {
                                        launchURL(urlToOpen.url);
                                      },
                                      text: widget.postBody,
                                      textAlign: TextAlign.justify,
                                        style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.normal,
                                        height: 1.3,
                                        ),
                                      ),
                                    )
                                  : new Padding(
                                   padding: EdgeInsets.only(top: 5.0),
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
                                            color: widget.arrayOfLikes.contains(widget.currentUser) ? Colors.greenAccent : Colors.grey,
                                            ), 
                                            onPressed: () {
                                             if(widget.arrayOfLikes.contains(widget.currentUser)) {
                                                _scaffoldKey.currentState.showSnackBar(alreadyLiked);
                                              } else {
                                                if(widget.arrayOfDislikes.contains(widget.currentUser)) {
                                                //Update in local
                                                //////////////////
                                                likeRequest(
                                                  widget.postID, 
                                                  widget.postLikes,
                                                  widget.postSubject, 
                                                  widget.currentUser, 
                                                  widget.currentUserUsername,
                                                  widget.arrayOfLikes,
                                                  widget.adminUID,
                                                  widget.adminNotificationsToken,
                                                  widget.currentUserPhoto);
                                                deleteDislikeRequest(
                                                  widget.postID, 
                                                  widget.postDislikes,
                                                  widget.currentUser, 
                                                  widget.arrayOfDislikes);
                                                _scaffoldKey.currentState.showSnackBar(likedSnackBar);
                                                setState(() {
                                                  widget.arrayOfLikes.add(widget.currentUser);
                                                  widget.arrayOfDislikes.remove(widget.currentUser);
                                                  widget.postLikes++;
                                                  widget.postDislikes--;
                                                });
                                                } else {
                                                likeRequest(
                                                  widget.postID, 
                                                  widget.postLikes,
                                                  widget.postSubject, 
                                                  widget.currentUser, 
                                                  widget.currentUserUsername,
                                                  widget.arrayOfLikes,
                                                  widget.adminUID,
                                                  widget.adminNotificationsToken,
                                                  widget.currentUserPhoto);
                                                _scaffoldKey.currentState.showSnackBar(likedSnackBar);
                                                setState(() {
                                                  widget.arrayOfLikes.add(widget.currentUser);
                                                  widget.postLikes++;
                                                });
                                                }
                                              }
                                            },
                                            ),
                                        ),
                                        new Padding(
                                          padding: EdgeInsets.only(left: 0.0),
                                          child: new Text(widget.postLikes != null
                                          ? widget.postLikes.toString()
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
                                            color: widget.arrayOfDislikes.contains(widget.currentUser) ? Colors.redAccent : Colors.grey,
                                            ), 
                                            onPressed: () {
                                              if(widget.arrayOfDislikes.contains(widget.currentUser)) {
                                                _scaffoldKey.currentState.showSnackBar(alreadydislikedSnackBar);
                                              } else {
                                                if(widget.arrayOfLikes.contains(widget.currentUser)) {
                                                  dislikeRequest(
                                                  widget.postID, 
                                                  widget.postDislikes, 
                                                  widget.currentUser, 
                                                  widget.arrayOfDislikes);
                                                  deletelikeRequest(
                                                  widget.postID, 
                                                  widget.postLikes, 
                                                  widget.currentUser, 
                                                  widget.arrayOfLikes);
                                                  _scaffoldKey.currentState.showSnackBar(dislikedSnackBar);
                                                setState(() {
                                                  widget.arrayOfDislikes.add(widget.currentUser);
                                                  widget.arrayOfLikes.remove(widget.currentUser);
                                                  widget.postDislikes++;
                                                  widget.postLikes--;
                                                });
                                                } else {
                                                  dislikeRequest(
                                                  widget.postID, 
                                                  widget.postDislikes, 
                                                  widget.currentUser, 
                                                  widget.arrayOfDislikes);
                                                  _scaffoldKey.currentState.showSnackBar(dislikedSnackBar);
                                                setState(() {
                                                  widget.arrayOfDislikes.add(widget.currentUser);
                                                  widget.postDislikes++;
                                                });
                                                }
                                              }
                                            },
                                            ),
                                        ),
                                        new Padding(
                                          padding: EdgeInsets.only(left: 0.0),
                                          child: new Text(widget.postDislikes != null
                                          ? widget.postDislikes.toString()
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
                                          child: new Text(widget.postComments != null
                                          ? widget.postComments.toString()
                                          : '',
                                          style: new TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.bold),
                                          ),
                                          ),
                                            ],
                                          )
                                        ),
                                        new Container(
                                          child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              new Padding(
                                                padding: EdgeInsets.only(right: 35.0),
                                              child: new InkWell(
                                                onTap: () {
                                                if(widget.adminSoundCloud == 'null') {
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
                                                              initialUrl: widget.adminSoundCloud,
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
                                                child: new SvgPicture.asset('lib/assets/soundcloud.svg',
                                                height: 20.0,
                                                ),

                                              ),
                                            ),
                                            ],
                                          ),
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
                          ],
                          ),
                    ),
                    ),
                    new Container(
                     decoration: new BoxDecoration(
                       color: Colors.grey[900].withOpacity(0.3),
                     ),
                     child: new Padding(
                       padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  new Container(
                                    height: 35.0,
                                    width: 35.0,
                                    decoration: new BoxDecoration(
                                      color: Colors.grey[900],
                                      shape: BoxShape.circle,
                                    ),
                                    child: new ClipOval(
                                      child: widget.currentUserPhoto != null
                                      ? new Image.network(widget.currentUserPhoto, fit: BoxFit.cover)
                                      : new Container(),
                                    ),
                                  ),
                                  new Container(
                                    width: MediaQuery.of(context).size.width*0.80,
                                    constraints: new BoxConstraints(
                                      minHeight: MediaQuery.of(context).size.height*0.05,
                                      maxHeight: MediaQuery.of(context).size.height*0.11,
                                    ),
                                    child: new CupertinoTextField(
                                      placeholder: 'Your comment',
                                      placeholderStyle: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.normal),
                                      keyboardAppearance: Brightness.dark,
                                      suffix: new Padding(
                                        padding: EdgeInsets.only(right: 0.0),
                                        child: new InkWell(
                                          onTap: () {
                                            setState(() {
                                              widget.reactedBy[widget.currentUser] = currentUserNotificationsToken;
                                            });
                                            commentRequest(
                                              _commentTextController,
                                              widget.postID,
                                              widget.postComments,
                                              widget.arrayOfComments,
                                              widget.postSubject, 
                                              widget.currentUser, 
                                              widget.currentUserUsername, 
                                              widget.currentUserPhoto,
                                              widget.currentSoundCloud, 
                                              currentUserNotificationsToken,
                                              _commentTextController.value.text.toString(), 
                                              widget.adminUID, 
                                              widget.reactedBy);
                                          setState(() {
                                            widget.postComments++;
                                          });
                                          },
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          child: new Text('SENT',
                                          style: new TextStyle(color: _textFieldOnChanged == true ? Colors.deepPurpleAccent : Colors.grey[800], fontSize: 10.0, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      controller: _commentTextController,
                                      autocorrect: true,
                                      focusNode: _textFieldFocusNode,
                                      scrollPhysics: new ScrollPhysics(),
                                      onSubmitted: (value) {
                                        setState(() {
                                          widget.reactedBy[widget.currentUser] = currentUserNotificationsToken;
                                        });
                                        commentRequest(
                                          _commentTextController,
                                          widget.postID,
                                          widget.postComments,
                                          widget.arrayOfComments,
                                          widget.postSubject, 
                                          widget.currentUser, 
                                          widget.currentUserUsername, 
                                          widget.currentUserPhoto,
                                          widget.currentSoundCloud, 
                                          currentUserNotificationsToken,
                                          _commentTextController.value.text.toString(), 
                                          widget.adminUID,
                                          widget.reactedBy,
                                          );
                                          setState(() {
                                            widget.postComments++;
                                          });
                                      },
                                      onChanged: (value) {
                                        if(_commentTextController.text.length > 0 && _commentTextController.text.length == 1) {
                                          setState(() {
                                            _textFieldOnChanged = true;
                                          });
                                        } else if (_commentTextController.text.length == 0) {
                                          setState(() {
                                            _textFieldOnChanged = false;
                                          });
                                        }
                                      },
                                      expands: true,
                                      cursorColor: Colors.white,
                                      padding: EdgeInsets.fromLTRB(5.0, 15.0, 15.0,15.0),
                                      minLines: null,
                                      maxLines: null,
                                      keyboardType: TextInputType.text,
                                      decoration: new BoxDecoration(
                                        borderRadius: new BorderRadius.circular(30.0),
                                        color: Colors.transparent
                                      ),
                                      style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                     ),
                    ),
                    new Container(
                      height: MediaQuery.of(context).size.height*0.05,
                      width: MediaQuery.of(context).size.width,
                    ),
                    new Container(
                      child: new StreamBuilder(
                        stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.postID)
                          .collection('comments')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if(snapshot.hasError) {
                            return new Container(
                              height: MediaQuery.of(context).size.height*0.30,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.transparent,
                              child: new Center(
                                child: new Text('No data, please restart',
                                style: new TextStyle(color: Colors.grey[800], fontSize: 17.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }
                          if(!snapshot.hasData || snapshot.data.docs.isEmpty) {
                          return new Container(
                            height: MediaQuery.of(context).size.height*0.30,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.transparent,
                            child: new Center(
                              child: new Text('Be first to answer 🤘',
                              style: new TextStyle(color: Colors.grey[800], fontSize: 17.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                          }
                         return new Container(
                           child: new ListView.builder(
                             padding: EdgeInsets.only(bottom: 100.0),
                             shrinkWrap: true,
                             physics: new NeverScrollableScrollPhysics(),
                             controller: _listOfComments,
                             itemCount: snapshot.data.docs.length,
                             itemBuilder: (BuildContext context, int index) {
                               var ds = snapshot.data.docs[index];
                               return new Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children: [
                                   new Padding(
                                     padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
                                     child: new Container(
                                     child: new ListTile(
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
                                    child: new Container(
                                      height: 35.0,
                                      width: 35.0,
                                      decoration: new BoxDecoration(
                                      color: Colors.grey[900],
                                      shape: BoxShape.circle,
                                      ),
                                      child: new ClipOval(
                                        child: ds['commentatorProfilephoto'] != null
                                        ? new Image.network(ds['commentatorProfilephoto'], fit: BoxFit.cover)
                                        : new Container(),
                                      ),
                                    )),
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
                                            child: new Text(ds['commentatorUsername'] != null
                                            ? ds['commentatorUsername']
                                            : 'Unknown',
                                            style: new TextStyle(color: Color(0xFF5CE1E6), fontSize: 12.0, fontWeight: FontWeight.bold),
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
                                                style: new TextStyle(color: Colors.grey, fontSize: 9.0, fontWeight: FontWeight.bold),
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
                                          new Container(
                                          child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              new Padding(
                                                padding: EdgeInsets.only(right: 20.0),
                                              child: new InkWell(
                                                onTap: () {
                                                if(ds['commentatorSoundCloud'] == 'null') {
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
                                                              initialUrl: ds['commentatorSoundCloud'],
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
                                                child: new SvgPicture.asset('lib/assets/soundcloud.svg',
                                                height: 20.0,
                                                ),
                                              ),
                                            ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: new Padding(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: ds['content'] != null
                                      ? new Linkify(
                                      onOpen: (urlToOpen) {
                                        launchURL(urlToOpen.url);
                                      },
                                      text: ds['content'],
                                      textAlign: TextAlign.justify,
                                        style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.normal,
                                        height: 1.3,
                                        ),
                                      )
                                      : new Text('(error on this comment)',
                                        style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.normal),
                                        textAlign: TextAlign.justify,
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
                             },
                           ),
                         );
                      },
                      ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}