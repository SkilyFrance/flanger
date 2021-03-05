
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flanger_app/homeFolder/requestList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class PublicationPage extends StatefulWidget {

  String currentUser;
  String currentUserPhoto;
  String currentUserUsername;
  String currentSoundCloud;
  String currentNotificationsToken;

  PublicationPage({
    Key key,
    this.currentUser,
    this.currentUserPhoto,
    this.currentUserUsername,
    this.currentSoundCloud,
    this.currentNotificationsToken,
    }) : super(key: key);

  @override
  PublicationPageState createState() => PublicationPageState();
}

class PublicationPageState extends State<PublicationPage> {

  int categoryPosted = 0;
  bool _publishingInProgress = false;

  TextEditingController _bodyPublicationController = new TextEditingController();
  TextEditingController _subjectPublicationController = new TextEditingController();

  @override
  void initState() {
    _bodyPublicationController = new TextEditingController();
    _subjectPublicationController = new TextEditingController();
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
              previousPageTitle: 'Home',
              automaticallyImplyTitle: true,
              automaticallyImplyLeading: true,
              transitionBetweenRoutes: true,
              backgroundColor: Colors.black.withOpacity(0.7),
              largeTitle: new Text('New post',
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
          child: new SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100.0),
            child: _publishingInProgress == false
            ? new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Divider
              new Container(
                height: MediaQuery.of(context).size.height*0.08,
                width: MediaQuery.of(context).size.width,
              ),
              new Container(
                child: new Text("Your post is about",
                style: new TextStyle(color: Colors.grey[700], fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
              //Divider
              new Container(
                height: MediaQuery.of(context).size.height*0.03,
                width: MediaQuery.of(context).size.width,
              ),
              new Container(
              child: new CupertinoSlidingSegmentedControl(
                backgroundColor: Colors.grey[900],
                children: <int, Widget>{
                  0: new Padding(
                    padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                  child: new Container(
                    child: new Text("Issue 💥",
                    style: new TextStyle(color: categoryPosted == 0 ? Colors.white : Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w700),
                    ),
                  ),
                  ),
                  1: new Padding(
                    padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                    child: new Container(
                    child:  new Text("Tip 💡",
                    style: new TextStyle(color: categoryPosted == 1 ? Colors.white : Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w700),
                    ),
                  ),
                  ),
                },
                groupValue: categoryPosted,
                onValueChanged: (value) {
                  setState(() {
                  categoryPosted = value;
                  });
              }),
              ),
              //Divider
              new Container(
                height: MediaQuery.of(context).size.height*0.07,
                width: MediaQuery.of(context).size.width,
              ),
              new Container(
                child: new Text( 'Subject',
                style: new TextStyle(color: Colors.grey[700], fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
              //Divider
              new Container(
                height: MediaQuery.of(context).size.height*0.03,
                width: MediaQuery.of(context).size.width,
              ),
             //TextField
             new Container(
               width: MediaQuery.of(context).size.width,
               color: Colors.grey[900].withOpacity(0.5),
               child: new Center(
                 child: new CupertinoTextField(
                   textAlign: TextAlign.justify,
                   padding: EdgeInsets.all(10.0),
                   style: new TextStyle(color: Colors.white, fontSize: 18.0),
                   keyboardType: TextInputType.text,
                   scrollPhysics: new ScrollPhysics(),
                   keyboardAppearance: Brightness.dark,
                   placeholder: 'Aa',
                   placeholderStyle: new TextStyle(color: Colors.grey, fontSize: 15.0),
                   minLines: 1,
                   maxLines: 1,
                   controller: _subjectPublicationController,
                   decoration: new BoxDecoration(
                   ),
                 ),
               ),
             ),
              //Divider
              new Container(
                height: MediaQuery.of(context).size.height*0.06,
                width: MediaQuery.of(context).size.width,
              ),
              new Container(
                child: new Text("Body",
                style: new TextStyle(color: Colors.grey[700], fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
              //Divider
              new Container(
                height: MediaQuery.of(context).size.height*0.03,
                width: MediaQuery.of(context).size.width,
              ),
             //TextField
             new Container(
               width: MediaQuery.of(context).size.width,
               color: Colors.grey[900].withOpacity(0.5),
               child: new Center(
                 child: new CupertinoTextField(
                   textAlign: TextAlign.justify,
                   padding: EdgeInsets.all(10.0),
                   style: new TextStyle(color: Colors.white, fontSize: 18.0),
                   keyboardType: TextInputType.text,
                   scrollPhysics: new ScrollPhysics(),
                   keyboardAppearance: Brightness.dark,
                   placeholder: 'Aa',
                   placeholderStyle: new TextStyle(color: Colors.grey, fontSize: 15.0),
                   minLines: 5,
                   maxLines: 5,
                   controller: _bodyPublicationController,
                   decoration: new BoxDecoration(
                   ),
                 ),
               ),
             ),
              //Divider
              new Container(
                height: MediaQuery.of(context).size.height*0.08,
                width: MediaQuery.of(context).size.width,
              ),
              new CupertinoButton(
                color: _bodyPublicationController.value.text.length > 2 && _subjectPublicationController.value.text.length > 2 ? Colors.deepPurpleAccent : Colors.transparent,
                child: new Text('Publish',
                style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                ), 
                onPressed: () {
                  if(_bodyPublicationController.value.text.length > 2 && _subjectPublicationController.value.text.length > 2) {
                    publicationRequest(
                      setState,
                      _publishingInProgress,
                      context, 
                      _subjectPublicationController, 
                      _bodyPublicationController, 
                      widget.currentUser, 
                      widget.currentUserUsername, 
                      widget.currentNotificationsToken, 
                      widget.currentUserPhoto, 
                      widget.currentSoundCloud, 
                      _bodyPublicationController.value.text.toString(), 
                      _subjectPublicationController.value.text.toString(), 
                      categoryPosted);
                  } else {
                  }

                })
            ],
          )
          : new Container(
            child: new Container(
              height: MediaQuery.of(context).size.height*0.70,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Text('Publication in progress',
                  style: new TextStyle(color: Colors.grey[700], fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(top: 22.0),
                    child: new CupertinoActivityIndicator(
                      radius: 12.0,
                      animating: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ),
        ),
      ),
      ),
    );
  }
}
