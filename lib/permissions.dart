import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';

class PermissionDemandClass {

   iosDialogImage(BuildContext context) {
    return showDialog(
      context: context, 
      builder: (_) => new CupertinoAlertDialog(
        content: new Text("Choose an image ?",
        style: new TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          new CupertinoDialogAction(
            onPressed: (){
              Navigator.pop(context);
            },
            child: new Text('No.',
            ),
            ),
            new CupertinoDialogAction(
              onPressed: (){
                openAppSettings();
              },
              child: new Text('Yes, thanks.',
              ),
              ),
        ],
      ),
    );
  }


   iosDialogNotifications(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => 
      new CupertinoAlertDialog(
        title: new Text("Notifications",
        style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold,
        height: 1.3,
        ),
        ),
        content: new Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: new Text("You will be redirected to your settings. Think to push again on Notifications button.",
          style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.normal,
          height: 1.3,
          ),
        )),
        actions: <Widget>[
          new CupertinoDialogAction(
            child: Text("OK", style: new TextStyle(fontSize: 14.0, color: Colors.blue, fontWeight: FontWeight.bold)),
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
              },
          )
        ],
      )
      );
    }

   iosDialogFile(BuildContext context) {
    return showDialog(
      context: context, 
      builder: (_) => new CupertinoAlertDialog(
        content: new Text("Choose an audio ?",
        style: new TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          new CupertinoDialogAction(
            onPressed: (){
              Navigator.pop(context);
            },
            child: new Text('No.',
            ),
            ),
            new CupertinoDialogAction(
              onPressed: (){
                openAppSettings();
              },
              child: new Text('Yes, thanks.',
              ),
              ),
        ],
      ),
    );
  }


   iosDialogMicro(BuildContext context) {
    return showDialog(
      context: context, 
      builder: (_) => new CupertinoAlertDialog(
        content: new Text("Create a story ?",
        style: new TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          new CupertinoDialogAction(
            onPressed: (){
              Navigator.pop(context);
            },
            child: new Text('No.',
            ),
            ),
            new CupertinoDialogAction(
              onPressed: (){
                openAppSettings();
              },
              child: new Text('Yes, thanks.',
              ),
              ),
        ],
      ),
    );
  }


  androidDialogImage(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        content: new Text("Choose an image ?",
        style: new TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: new Text('No.'),
            ),
          new FlatButton(
            onPressed: (){
              openAppSettings();
            }, 
            child: new Text('Yes, thanks',
            ),
            ),
        ],
      ),
      );
  }
  androidDialogFile(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        content: new Text("Choose an audio ?",
        style: new TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: new Text('No.'),
            ),
          new FlatButton(
            onPressed: (){
              openAppSettings();
            }, 
            child: new Text('Yes, thanks',
            ),
            ),
        ],
      ),
      );
  }

  androidDialogMicro(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        content: new Text("Create a story ?",
        style: new TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: new Text('No.'),
            ),
          new FlatButton(
            onPressed: (){
              openAppSettings();
            }, 
            child: new Text('Yes, thanks',
            ),
            ),
        ],
      ),
      );
  }

}