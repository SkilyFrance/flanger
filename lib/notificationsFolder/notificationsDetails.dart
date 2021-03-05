import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flanger_app/homeFolder/requestList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:webview_flutter/webview_flutter.dart';



class NotificationsDetails extends StatefulWidget {

  //CurrentUser datas
  String currentUser;
  String currentUserUsername;
  String currentUserPhoto;
  String currentSoundCloud;
  //HeroTag
  final String heroTag;
  //Post datas
  String postID;


  NotificationsDetails({
    Key key, 
    this.currentUser, 
    this.currentUserUsername,
    this.currentUserPhoto,
    this.currentSoundCloud,
    this.heroTag,
    this.postID,
    }) : super(key: key);



  @override
  NotificationsDetailsState createState() => NotificationsDetailsState();
}


class NotificationsDetailsState extends State<NotificationsDetails> {

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



  ScrollController _listOfComments = new ScrollController();
  TextEditingController _commentTextController = new TextEditingController();
  FocusNode _textFieldFocusNode = new FocusNode();
  bool _textFieldOnChanged = false;
  
  final Set<Factory> gestureRecognizers = [Factory(() => EagerGestureRecognizer())].toSet();
  UniqueKey _key = UniqueKey();

@override
  void initState() {
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
                  child: new StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('posts').doc(widget.postID).snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if(snapshot.hasError || !snapshot.hasData) {
                        return new Container(
                          height: MediaQuery.of(context).size.height*0.20,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              new CupertinoActivityIndicator(
                                animating: true,
                                radius: 10.0,
                              ),
                            ],
                          ),
                        );
                      }
                      List<dynamic> arrayOfLikes = snapshot.data['likedBy'];
                      List<dynamic> arrayOfDislikes = snapshot.data['dislikedBy'];
                      return new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [        
                      new Container(
                      color: Colors.transparent,
                      child: new Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
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
                                      child: new InkWell(
                                    onTap: () {
                                      if(snapshot.data.documents.data['adminSoundCloud'] == 'null') {
                                        _scaffoldKey.currentState.showSnackBar(noSoundCloudSnackBar);
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
                                                    initialUrl: snapshot.data['adminSoundCloud'],
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
                                      child: snapshot.data['adminProfilephoto'] != null
                                      ? new Image.network(snapshot.data['adminProfilephoto'], fit: BoxFit.cover)
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
                                          child: new Text(snapshot.data['adminUsername'] != null
                                          ? snapshot.data['adminUsername']
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
                                            child: new Text(snapshot.data['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(snapshot.data['timestamp'])).inMinutes < 1
                                              ? 'few sec ago'
                                              : snapshot.data['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(snapshot.data['timestamp'])).inMinutes < 60
                                              ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(snapshot.data['timestamp'])).inMinutes.toString() + ' min ago'
                                              : snapshot.data['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(snapshot.data['timestamp'])).inMinutes >= 60
                                              ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(snapshot.data['timestamp'])).inHours.toString() + ' hours ago'
                                              : snapshot.data['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(snapshot.data['timestamp'])).inHours >= 24
                                              ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(snapshot.data['timestamp'])).inDays.toString() + ' days ago'
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
                                        child: snapshot.data['typeOfPost'] != null && snapshot.data['typeOfPost'] == 'issue'
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
                                        : snapshot.data['typeOfPost'] != null && snapshot.data['typeOfPost'] == 'tip'
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
                                      text: snapshot.data['subject'] != null
                                      ? snapshot.data['subject']
                                      : '(error on this title)',
                                      style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold,
                                      height: 1.1,
                                      ),
                                      children: [
                                        new TextSpan(
                                          text: snapshot.data['body'] != null
                                           ? '  ' + snapshot.data['body']
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
                                                _scaffoldKey.currentState.showSnackBar(alreadyLiked);
                                              } else {
                                                if(arrayOfDislikes.contains(widget.currentUser)) {
                                                //Update in local
                                                //////////////////
                                                likeRequest(
                                                  snapshot.data['postID'], 
                                                  snapshot.data['likes'], 
                                                  widget.currentUser, 
                                                  snapshot.data['likedBy']);
                                                deleteDislikeRequest(
                                                  snapshot.data['postID'], 
                                                  snapshot.data['dislikes'],
                                                  widget.currentUser, 
                                                  snapshot.data['dislikedBy']);
                                                _scaffoldKey.currentState.showSnackBar(likedSnackBar);
                                                } else {
                                                likeRequest(
                                                  snapshot.data['postID'], 
                                                  snapshot.data['likes'], 
                                                  widget.currentUser, 
                                                  snapshot.data['likedBy']);
                                                _scaffoldKey.currentState.showSnackBar(likedSnackBar);
                                                }
                                              }
                                            },
                                            ),
                                        ),
                                        new Padding(
                                          padding: EdgeInsets.only(left: 0.0),
                                          child: new Text(snapshot.data['likes'] != null
                                          ? snapshot.data['likes'].toString()
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
                                            color: arrayOfDislikes.contains(widget.currentUser) ? Colors.redAccent : Colors.grey,
                                            ), 
                                            onPressed: () {
                                              if(arrayOfDislikes.contains(widget.currentUser)) {
                                                _scaffoldKey.currentState.showSnackBar(alreadydislikedSnackBar);
                                              } else {
                                                if(arrayOfLikes.contains(widget.currentUser)) {
                                                  dislikeRequest(
                                                  snapshot.data['postID'], 
                                                  snapshot.data['dislikes'], 
                                                  widget.currentUser, 
                                                  snapshot.data['dislikedBy']);
                                                  deletelikeRequest(
                                                  snapshot.data['postID'], 
                                                  snapshot.data['likes'], 
                                                  widget.currentUser, 
                                                  snapshot.data['likedBy']);
                                                  _scaffoldKey.currentState.showSnackBar(dislikedSnackBar);
                                                } else {
                                                  dislikeRequest(
                                                  snapshot.data['postID'], 
                                                  snapshot.data['dislikes'], 
                                                  widget.currentUser, 
                                                  snapshot.data['dislikedBy']);
                                                  _scaffoldKey.currentState.showSnackBar(dislikedSnackBar);
                                                }
                                              }
                                            },
                                            ),
                                        ),
                                        new Padding(
                                          padding: EdgeInsets.only(left: 0.0),
                                          child: new Text(snapshot.data['dislikes'] != null
                                          ? snapshot.data['dislikes'].toString()
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
                                          child: new Text(snapshot.data['comments'] != null
                                          ? snapshot.data['comments'].toString()
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
                                            commentRequest(
                                              _commentTextController,
                                              snapshot.data['postID'],
                                              snapshot.data['comments'],
                                              snapshot.data['commentedBy'],
                                              snapshot.data['subject'],
                                              widget.currentUser, 
                                              widget.currentUserUsername, 
                                              widget.currentUserPhoto,
                                              widget.currentSoundCloud, 
                                              _commentTextController.value.text.toString(), 
                                              snapshot.data['adminUID'], 
                                              snapshot.data['adminNotificationsToken']);
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
                                        commentRequest(
                                          _commentTextController,
                                          snapshot.data['postID'],
                                          snapshot.data['comments'],
                                          snapshot.data['commentedBy'],
                                          snapshot.data['subject'],
                                          widget.currentUser, 
                                          widget.currentUserUsername, 
                                          widget.currentUserPhoto,
                                          widget.currentSoundCloud, 
                                          _commentTextController.value.text.toString(), 
                                          snapshot.data['adminUID'], 
                                          snapshot.data['adminNotificationsToken']);
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
                        ],
                      );
                    },
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
                                     padding: EdgeInsets.only(bottom: 8.0),
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
                                        child: new InkWell(
                                      onTap: () {
                                        if(ds['commentatorSoundCloud'] == 'null') {
                                          _scaffoldKey.currentState.showSnackBar(noSoundCloudSnackBar);
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
                                      ],
                                    ),
                                    subtitle: new Padding(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: new Text(
                                        ds['content'] != null
                                        ? ds['content']
                                        : '(error on this comment)',
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