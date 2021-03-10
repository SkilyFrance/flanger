import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flanger_app/navigation.dart';
import 'package:flanger_app/permissions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../notificationsService.dart';


class ProfileCreationProcessPage extends StatefulWidget {

  String currentUser;
  String currentUserEmail;

  ProfileCreationProcessPage({Key key,this.currentUser, this.currentUserEmail}) : super(key: key);

  @override
  ProfileCreationProcessPageState createState() => ProfileCreationProcessPageState();
}

class ProfileCreationProcessPageState extends State<ProfileCreationProcessPage> {

  TextEditingController _usernameTextEditingController = new TextEditingController();
  TextEditingController _soundCloudTextEditingController = new TextEditingController();
  PageController _pageController = new PageController(initialPage: 0);
  File _image;
  bool _creationInProgress = false;
  var notificationsToken = 'null';


  @override
  void initState() {
    _usernameTextEditingController = new TextEditingController();
    _soundCloudTextEditingController = new TextEditingController();
    super.initState();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  //GET AND STORE NOTIFICATIONS TOKEN
  notificationsDemand() async {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          new PushNotificationMessage(
            title: message['subject'],
            body: message['body']);
            print(message);
        }, 
        onLaunch: (Map<String, dynamic> message) async {
      if (this.mounted) {
        print(message);
      }
      }, 
      onResume: (Map<String, dynamic> message) async {
      if (this.mounted) {
        print(message);
      }
      });

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {});
     var notificationGetToken = await _firebaseMessaging.getToken();
     setState(() {
       notificationsToken = notificationGetToken;
     });
     print('NotificationsToken = $notificationsToken');
     _firebaseMessaging.subscribeToTopic('sendNotifications').whenComplete(() => print('Notifications topic subscribed'));
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
              largeTitle: new Text('Before start',
                  style: new TextStyle(color: Colors.white),
                  ),
            ),
          ];
        }, 
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
        child: new PageView(
          controller: _pageController,
          physics: new NeverScrollableScrollPhysics(),
          children: [
        //1st page : Datas for cloud firestore
         new Container(
          child: new SingleChildScrollView(
             child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                new Container(
                  height: MediaQuery.of(context).size.height*0.07,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                new Container(
                  child: new Center(
                    child: new Text('Your producer name',
                    style: new TextStyle(color: Colors.grey[800], fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.04,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                //TextField
                new Container(
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
                      placeholder: 'Aa',
                      placeholderStyle: new TextStyle(color: Colors.grey, fontSize: 15.0),
                      minLines: 1,
                      maxLines: 1,
                      controller: _usernameTextEditingController,
                      decoration: new BoxDecoration(
                      ),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.06,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                new Container(
                  child: new Center(
                    child: new Text('Your SoundCloud link',
                    style: new TextStyle(color: Colors.grey[800], fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.04,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                //TextField
                new Container(
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
                      placeholder: 'Paste here (optional)',
                      placeholderStyle: new TextStyle(color: Colors.grey[700], fontSize: 15.0),
                      minLines: 1,
                      maxLines: 1,
                      controller: _soundCloudTextEditingController,
                      decoration: new BoxDecoration(
                      ),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.06,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                new Container(
                  child: new Center(
                    child: new Text('Select a photo',
                    style: new TextStyle(color: Colors.grey[800], fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.04,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                new InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onTap: () async {
                     var photoIOSPermission = await Permission.photos.status;
                     if(photoIOSPermission.isGranted) {
                       print('Accepté');
                       FilePickerResult resultImage  = await FilePicker.platform.pickFiles(type: FileType.image);
                          setState(() {
                           if (resultImage != null) {
                             _image = File(resultImage.files.single.path);
                           } else {
                             print('No image selected.');
                           }
                         });
                     }
                     if(photoIOSPermission.isUndetermined) {
                       await Permission.photos.request();
                       if(await Permission.photos.request().isGranted) {
                       FilePickerResult resultImage  = await FilePicker.platform.pickFiles(type: FileType.image);
                          setState(() {
                           if (resultImage != null) {
                             _image = File(resultImage.files.single.path);
                           } else {
                             print('No image selected.');
                           }
                         });
                       }
                       if(await Permission.photos.request().isDenied) {
                         PermissionDemandClass().iosDialogImage(context);
                       }
                       if(await Permission.photos.request().isPermanentlyDenied) {
                         PermissionDemandClass().iosDialogImage(context);
                       }
                     }
                     if(photoIOSPermission.isDenied || photoIOSPermission.isPermanentlyDenied) {
                       PermissionDemandClass().iosDialogImage(context);
                     }
                  },
                child: new Container(
                  height: MediaQuery.of(context).size.height*0.13,
                  width: MediaQuery.of(context).size.height*0.13,
                  decoration: new BoxDecoration(
                    color: Colors.grey[900],
                    shape: BoxShape.circle,
                  ),
                  child: _image != null
                  ? new ClipOval(child: new Image.file(_image, fit: BoxFit.cover))
                  : new Container(),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.06,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                new CupertinoButton(
                  color: Colors.deepPurpleAccent[400],
                  child: new Text('START',
                  style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ), 
                  onPressed: () async  {
                    if(_usernameTextEditingController.value.text.length >= 2 && _image != null) {
                      _pageController.nextPage(duration: new Duration(microseconds: 1), curve: Curves.ease);
                    } else {
                    }
                  }
                ),
              ],
            ),
          ),
        ),
        //2nd page :
         new Container(
          child: new SingleChildScrollView(
            child: _creationInProgress == false
            ? new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                new Container(
                  height: MediaQuery.of(context).size.height*0.12,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                new Container(
                  child: new Center(
                    child: new Text('NOTIFICATIONS',
                    style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.04,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                new Container(
                  child: new Center(
                    child: new Text('🔔',
                    style: new TextStyle(fontSize: 40.0),
                    ),
                  ),
                ),
                notificationsToken != 'null'
                ? new Column(
                  children: [
                    new Container(
                      height: MediaQuery.of(context).size.height*0.30,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                      child: new Center(
                        child: new Text('Successfully activated',
                        style: new TextStyle(color: Color(0xFF5CE1E6), fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
                : new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.06,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                new Container(
                  child: new Center(
                    child: new Text('Be informed',
                    style: new TextStyle(color: Colors.grey[800], fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.04,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                new Container(
                  child: new Center(
                    child: new Text('about new comment, like ...',
                    style: new TextStyle(color: Colors.grey[800], fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.08,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                new CupertinoButton(
                  color: Colors.deepPurpleAccent[400],
                  child: new Text('Activate',
                  style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ), 
                  onPressed: () {
                    notificationsDemand();
                  }
                ),
                  ],
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.15,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                new CupertinoButton(
                  color: notificationsToken != 'null' ? Colors.deepPurpleAccent : Colors.transparent,
                  child: new Text(notificationsToken != 'null' ? 'START' : 'SKIP',
                  style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ), 
                  onPressed: () async  {
                    if(_usernameTextEditingController.value.text.length >= 2 && _image != null) {
                      setState(() {
                        _creationInProgress = true;
                      });
                      firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance
                        .ref()
                        .child('${widget.currentUser}/profilePhoto');
                        firebase_storage.UploadTask uploadTask = storageReference.putFile(_image);
                        await uploadTask;
                        print('Firebase storage : Photo uploaded.');
                        storageReference.getDownloadURL().then((filePhotoURL) async {
                         FirebaseFirestore.instance
                           .collection('users')
                           .doc(widget.currentUser)
                           .set({
                             'notificationsToken': notificationsToken,
                             'uid': widget.currentUser,
                             'email': widget.currentUserEmail,
                             'username': _usernameTextEditingController.value.text.toString(),
                             'soundCloud': _soundCloudTextEditingController.value.text.length > 10 ?  _soundCloudTextEditingController.value.text.toString() : 'null',
                             'profilePhoto': filePhotoURL,
                           }).whenComplete(() {
                            //Go to creationProcess
                            Navigator.pushAndRemoveUntil(
                            context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
                            new NavigationPage(
                              currentUser: widget.currentUser,
                              currentUserUsername: _usernameTextEditingController.value.text.toString(),
                              currentUserPhoto: filePhotoURL,
                              notificationsToken: notificationsToken,
                            )),
                            (route) => false);
                        });
                        });
                    } else {
                    }
                  }
                ),
              ],
            )
            : new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                new Container(
                  height: MediaQuery.of(context).size.height*0.30,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  height: MediaQuery.of(context).size.height*0.10,
                  width: MediaQuery.of(context).size.width,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    new Text('Profile creation',
                    style: new TextStyle(color: Colors.grey[800], fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: new CupertinoActivityIndicator(
                        animating: true,
                        radius: 10.0,
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
    );
  }
 
}