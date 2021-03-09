import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flanger_app/loginFolder/landing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';


class ProfilePage extends StatefulWidget {

  String currentUser;
  String currentUserUsername;
  String currentUserPhoto;
  String notificationsToken;

  ProfilePage({
    Key key, 
    this.currentUser, 
    this.currentUserUsername,
    this.currentUserPhoto,
    this.notificationsToken,
    }) : super(key: key);


  @override
  ProfilePageState createState() => ProfilePageState();
}


class ProfilePageState extends State<ProfilePage> {

  final noSoundCloudSnackBar = new SnackBar(
    backgroundColor: Colors.deepPurpleAccent,
    content: new Text('No SoundCloud linked 🥺',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
    ));
  final soundCloudModifySuccessfully = new SnackBar(
    backgroundColor: Color(0xFF5CE1E6),
    content: new Text('link successfully modified 👍',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
    ));

final Email email = Email(
  subject: 'Flanger feedback / Questions',
  recipients: ['guillaume.goutin@gmail.com'],
  isHTML: false,
);

  final Set<Factory> gestureRecognizers = [Factory(() => EagerGestureRecognizer())].toSet();
  UniqueKey _key = UniqueKey();

  TextEditingController _soundCloudTextEditingController = new TextEditingController();

  bool _viewToModifySoundCloud = false;
 

@override
  void initState() {
    _soundCloudTextEditingController = new TextEditingController();
    super.initState();
  }


    signOut() {
    FirebaseAuth.instance.signOut().then((value) =>
        Navigator.pushAndRemoveUntil(
            context,
            new MaterialPageRoute(builder: (context) => new LandingPage()),
            (_) => false));
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
              largeTitle: new Text('My profile',
                  style: new TextStyle(color: Colors.white),
                  ),
                  trailing: new Material(
                    color: Colors.transparent,
                    child: new IconButton(
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                    icon: new Icon(Icons.logout, color: Colors.grey, size: 25.0),
                    onPressed: () {
                      return showDialog(
                        context: context, 
                        builder: (_) => new CupertinoAlertDialog(
                          content: new Text("Are you sure to log out ?",
                          style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          actions: <Widget>[
                            new CupertinoDialogAction(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: new Text('No, thanks',
                              ),
                              ),
                              new CupertinoDialogAction(
                                onPressed: (){
                                  signOut();
                                },
                                child: new Text('Yes',
                                style: new TextStyle(color: Colors.red),
                                ),
                                ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ),
          ];
        }, 
        body: new Container(
          child: new SingleChildScrollView(
            child: new StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').doc(widget.currentUser).snapshots(),
              builder: (BuildContext context, snapshot) {
                if(snapshot.hasError || !snapshot.hasData) {
                return new Container(
                  height: MediaQuery.of(context).size.height*0.70,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                  child: new Center(
                    child: new CupertinoActivityIndicator(
                      animating: true,
                      radius: 10.0,
                    ),
                  ),
                );
                }
                return new Container(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new Container(
                      height: MediaQuery.of(context).size.height*0.08,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                    ),
                    new Container(
                      height: 120.0,
                      width: 120.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[900],
                      ),
                      child: snapshot.data['profilePhoto'] != null
                      ? new ClipOval(
                        child: new Image.network(snapshot.data['profilePhoto'], fit: BoxFit.cover),
                      )
                      : new Container()
                    ),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.03,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                  ),
                  new Container(
                    child: new Text(
                      snapshot.data['username'] != null
                      ? snapshot.data['username']
                      : 'Your username',
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.03,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                  ),
                  new InkWell(
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                    if(snapshot.data['soundCloud'] == 'null') {
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
                                  initialUrl: snapshot.data['soundCloud'],
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
                      decoration: new BoxDecoration(
                        color: Colors.orange,
                        borderRadius: new BorderRadius.circular(5.0)
                      ),
                    child: new Padding(
                      padding: EdgeInsets.all(12.0),
                      child: new Text('SoundCloud',
                      style: new TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    )),
                  ),
                  _viewToModifySoundCloud == true
                  ? new Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  child: new Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: new BoxDecoration(
                        color: Colors.grey[900].withOpacity(0.5),
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      child: new Center(
                        child: new CupertinoTextField(
                          textAlign: TextAlign.center,
                          padding: EdgeInsets.all(10.0),
                          maxLength: 170,
                          style: new TextStyle(color: Colors.white, fontSize: 18.0),
                          keyboardType: TextInputType.text,
                          scrollPhysics: new ScrollPhysics(),
                          keyboardAppearance: Brightness.dark,
                          placeholder: snapshot.data['soundCloud'],
                          placeholderStyle: new TextStyle(color: Colors.grey[700], fontSize: 15.0),
                          minLines: 1,
                          maxLines: 1,
                          controller: _soundCloudTextEditingController,
                          decoration: new BoxDecoration(
                          ),
                        ),
                      ),
                    ))
                    : new Container(),
                  new Container(
                    child: new FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                        if(_viewToModifySoundCloud == true) {
                          if(_soundCloudTextEditingController.value.text.length > 10) {
                            FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.currentUser)
                              .update({
                                'soundCloud': _soundCloudTextEditingController.value.text.toString(),
                              }).whenComplete(() => print('SoundCloud link updated successfully'));
                            Scaffold.of(context).showSnackBar(soundCloudModifySuccessfully);
                          } else {
                            Scaffold.of(context).showSnackBar(soundCloudModifySuccessfully);
                          }
                        setState(() {
                          _viewToModifySoundCloud = false;
                        });
                        } else {
                        setState(() {
                          _viewToModifySoundCloud = true;
                        });
                        }
                      }, 
                      child: new Text(_viewToModifySoundCloud == true ? 'Press to modify ': 'Modify this link',
                      style: new TextStyle(color: Colors.grey[700], fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  //Divider
                  new Container(
                    height: MediaQuery.of(context).size.height*0.06,
                    width: MediaQuery.of(context).size.width,
                  ),
                  new Container(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        new Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                        child: new Container(
                          color: Colors.transparent,
                        child: new ListTile(
                          onTap: () {
                           final RenderBox box = context.findRenderObject();
                           Share.share(
                             "Hey, Join me on Flanger. it's a collaborative Q&A between electronic music producers. Download it here : . Hope to see you 🚀",
                             sharePositionOrigin: box.localToGlobal(Offset.zero)&box.size).whenComplete(() {
                               print('Ok');
                             });
                          },
                          leading: new Text('🎉', style: new TextStyle(fontSize: 25.0)),
                          title: new Center(child: new Text('Send invitations to join Flanger', 
                          style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500))),
                          trailing: new Icon(Icons.more_horiz_rounded, color: Colors.grey),
                        ))),
                        new Divider(height: 1.0,color: Colors.grey[900]),
                        new Padding(
                          padding: EdgeInsets.only(top: 10.0),
                        child: new Container(
                          color: Colors.transparent,
                        child: new ListTile(
                          onTap: () async {
                            await FlutterEmailSender.send(email);
                          },
                          leading: new Text('☎️', style: new TextStyle(fontSize: 25.0)),
                          title: new Center(child: new Text('Contact us', 
                          style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500))),
                          trailing: new Icon(Icons.more_horiz_rounded, color: Colors.grey),
                        ))),
                      ],
                    ),
                  ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}