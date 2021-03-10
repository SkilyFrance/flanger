import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flanger_app/navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SignInPage extends StatefulWidget {
  @override
  SignInPageState createState() => SignInPageState();
}


class SignInPageState extends State<SignInPage> {


  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _passwordEditingController = new TextEditingController();

  bool userNotFound = false;
  bool wrongPassword = false;

@override
  void initState() {
    _emailEditingController = new TextEditingController();
    _passwordEditingController = new TextEditingController();
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
              previousPageTitle: '',
              automaticallyImplyTitle: true,
              automaticallyImplyLeading: true,
              transitionBetweenRoutes: true,
              backgroundColor: Colors.black.withOpacity(0.7),
              largeTitle: new Text('Sign in',
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
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.13,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                new Container(
                  child: new Center(
                    child: new Text('Email.',
                    style: new TextStyle(color: Colors.grey[800], fontSize: 22.0, fontWeight: FontWeight.bold),
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
                  width: MediaQuery.of(context).size.width*0.80,
                  decoration: new BoxDecoration(
                    color: Colors.grey[900].withOpacity(0.5),
                    borderRadius: new BorderRadius.circular(5.0),
                  ),
                  child: new Center(
                    child: new CupertinoTextField(
                      textAlign: TextAlign.justify,
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
                      controller: _emailEditingController,
                      decoration: new BoxDecoration(
                      ),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.10,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                new Container(
                  child: new Center(
                    child: new Text('Password.',
                    style: new TextStyle(color: Colors.grey[800], fontSize: 22.0, fontWeight: FontWeight.bold),
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
                  width: MediaQuery.of(context).size.width*0.80,
                  decoration: new BoxDecoration(
                    color: Colors.grey[900].withOpacity(0.5),
                    borderRadius: new BorderRadius.circular(5.0),
                  ),
                  child: new Center(
                    child: new CupertinoTextField(
                      obscureText: true,
                      textAlign: TextAlign.justify,
                      padding: EdgeInsets.all(10.0),
                      maxLength: 170,
                      style: new TextStyle(color: Colors.white, fontSize: 18.0),
                      keyboardType: TextInputType.text,
                      scrollPhysics: new ScrollPhysics(),
                      keyboardAppearance: Brightness.dark,
                      placeholder: '*****',
                      placeholderStyle: new TextStyle(color: Colors.grey, fontSize: 15.0),
                      minLines: 1,
                      maxLines: 1,
                      controller: _passwordEditingController,
                      decoration: new BoxDecoration(
                      ),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.15,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                new CupertinoButton(
                  color: Colors.deepPurpleAccent[400],
                  child: new Text('CONNECT',
                  style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ), 
                  onPressed: () {
                     if(_emailEditingController.value.text.length > 4 && _passwordEditingController.value.text.length > 3) {
                       FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                          email: _emailEditingController.value.text.toString(), 
                          password: _passwordEditingController.value.text.toString())
                        .then((authResult) {
                          FirebaseFirestore.instance
                            .collection('users')
                            .doc(authResult.user.uid)
                            .get()
                            .then((value) {
                              if(value.exists) {
                                  Navigator.pushAndRemoveUntil(context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
                                  new NavigationPage(
                                  currentUser: authResult.user.uid, 
                                  currentUserUsername: value.data()['username'],
                                  currentUserPhoto: value.data()['profilePhoto'],
                                  notificationsToken: value.data()['notificationsToken']
                                  )), 
                                  (route) => false);
                              } else {
                              }
                            });
                        }).catchError((error){
                              print(error.code);
                              switch (error.code) {
                                case 'user-not-found': setState(() {userNotFound = true;});
                                  break;
                                case 'error_wrong_password': setState(() {wrongPassword = true;});
                              }
                            
                            });
                       
                     } else {

                     }

                  }
                ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}