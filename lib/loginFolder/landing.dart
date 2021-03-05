import 'package:flanger_app/loginFolder/signin.dart';
import 'package:flanger_app/loginFolder/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: new Container(
        color: Colors.black,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Divider
            new Container(
              height: MediaQuery.of(context).size.height*0.15,
              width: MediaQuery.of(context).size.width,
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.06,
                  width: MediaQuery.of(context).size.width*0.07,
                ),
                new Container(
                  child: new Text('The collaborative',
                  style: new TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                )
                ],
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.06,
                  width: MediaQuery.of(context).size.width*0.07,
                ),
                new Container(
                  child: new Text('Q & A between',
                  style: new TextStyle(color:  Colors.deepPurpleAccent, fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                ),
                new Container(
                  child: new Text('',
                  style: new TextStyle(color: Color(0xFF5CE1E6), fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                  ),
                ],
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.06,
                  width: MediaQuery.of(context).size.width*0.07,
                ),
                new Container(
                  child: new Text('electronic music',
                  style: new TextStyle(color: Color(0xFF5CE1E6), fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                ),
                ],
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.06,
                  width: MediaQuery.of(context).size.width*0.07,
                ),
                new Container(
                  child: new Text('producers.',
                  style: new TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                ),
                ],
              ),
            ),
            //Divider
            new Container(
              height: MediaQuery.of(context).size.height*0.30,
              width: MediaQuery.of(context).size.width,
            ),
            new CupertinoButton(
              color: Colors.deepPurpleAccent[400],
              child: new Text('SIGN UP',
              style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ), 
              onPressed: (){
               Navigator.push(
                 context, 
                 new CupertinoPageRoute(
                   builder: (context) => new SignUpPage()));
              }
              ),
            //Divider
            new Container(
              height: MediaQuery.of(context).size.height*0.05,
              width: MediaQuery.of(context).size.width,
            ),
            new CupertinoButton(
              color: Colors.transparent,
              child: new Text('SIGN IN',
              style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ), 
              onPressed: (){
               Navigator.push(
                 context, 
                 new CupertinoPageRoute(
                   builder: (context) => new SignInPage()));
              }
              ),
          ],
        ),
      ),
    );
  }
}