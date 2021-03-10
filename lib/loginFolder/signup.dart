import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flanger_app/loginFolder/creationProcess.dart';
import 'package:flanger_app/navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() => SignUpPageState();
}


class SignUpPageState extends State<SignUpPage> {


  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _passwordEditingController = new TextEditingController();

  bool mailIsValid = true;
  bool eulaAccepted = false;

  String eula = '''To access some of the public Network features you will need to register for an account as an individual and consent to these Public Network Terms. If you do not consent to these Public Network Terms, Flanger reserves the right to refuse, suspend or terminate your access to the public Network.You are solely responsible for ensuring that your account registration is complete and remains up to date. You have the right to discontinue use of, or terminate, your account whenever you like, and subject to our Privacy Policy, control the use and sharing of your account information. Please note that any content or information you share publicly is governed by the terms described below in the section titled “Content Permissions, Restrictions, and Creative Commons Licensing,” and you should be aware that once you place content in the public sphere, you willingly give up some rights and control over such content. Flanger strongly encourages you to review our Privacy Policy, which explains how we will handle, process, and use your personal data, and with whom, and how we will share this data. Flanger is a community and we expect you to treat each member of the Flanger community with respect. Whether a community member is asking their first question, or is a reputation superstar, we respect you and welcome you, but we also require you to be kind to one another. To prevent bad actors from creating a negative community experience, we have outlined what we believe to be common sense rules for community participation and reserve the right to pause or terminate your account if you engage in disruptive, abusive, or nefarious behavior outside of Flanger’s Acceptable Use Policy, which is hereby incorporated into these Public Network Terms.
You are solely responsible for obtaining and maintaining any equipment or ancillary services needed to connect to or access the Network or otherwise use the Services, including without limitation modems, hardware, software, and long distance or local telephone service. You are solely responsible for ensuring that such equipment or ancillary services are compatible with the Services and Network.
Some premium or additional features of Flanger (including without limitation Flanger for Teams) may require a payment obligation for access and use. You are solely responsible for ensuring that your payment obligations, if any, remain current and not in arrears. In the event Flanger charges for features you will be clearly notified of the terms of any payment obligations and provided the opportunity to refuse such obligations before you incur any charges. Please note, however, that your refusal to accept payment obligations may result in your inability to access or use certain premium or additional features of Flanger.

All materials displayed or performed on the public Network, including but not limited to text, graphics, logos, tools, photographs, images, illustrations, software or source code, audio and video, and animations (collectively “Network Content”) (other than Network Content posted by individual “Subscriber Content”) are the property of Flanger and/or third parties and are protected by United States and international copyright laws (“Flanger Content”).
The Flanger API shall be used solely pursuant to the terms of the API Terms of Use.
All trademarks, service marks, and trade names are proprietary to Flanger and/or third parties and use of the Network means you agree to abide by all copyright notices, information, and restrictions contained in any Network Content accessed through the Services.
The Network is protected by copyright as a collective work and/or compilation, pursuant to U.S. copyright laws, international covenants, and other copyright laws. Other than as expressly set forth in these Public Network Terms, you may not copy, modify, publish, transmit, upload, participate in the transfer or sale of, reproduce (except as provided in this Agreement), create derivative works based on, distribute, perform, display, or in any way exploit any of the Network Content, software, materials, or Services in whole or in part. You may download or copy the public Network Content, and other items displayed on the public Network for download or personal use provided that you maintain all copyright and other notices contained in such Public Content.
From time to time, Flanger may make available compilations of all the Subscriber Content on the public Network (the “Creative Commons Data Dump”). The Creative Commons Data Dump is licensed under the CC BY-SA license. By downloading the Creative Commons Data Dump, you agree to be bound by the terms of that license.
Any other downloading, copying, or storing of any public Network Content (other than Subscriber Content or content made available via the Flanger API) for other than personal, noncommercial use is expressly prohibited without prior written permission from Flanger or from the copyright holder identified in the copyright notice per the Creative Commons License. In the event you download software from the public Network (other than Subscriber Content or content made available by the Flanger API) the software including any files, images incorporated in or generated by the software, the data accompanying the software (collectively, the “Software”) is licensed to you by Flanger or third party licensors for your personal, noncommercial use, and no title to the Software shall transfer to you. Flanger or third party licensors retain full and complete title to the Software and all intellectual property rights therein.

You agree that any and all content, including without limitation any and all text, graphics, logos, tools, photographs, images, illustrations, software or source code, audio and video, animations, and product feedback (collectively, “Content”) that you provide to the public Network (collectively, “Subscriber Content”), is perpetually and irrevocably licensed to Flanger on a worldwide, royalty-free, non-exclusive basis pursuant to Creative Commons licensing terms (CC BY-SA 4.0), and you grant Flanger the perpetual and irrevocable right and license to access, use, process, copy, distribute, export, display and to commercially exploit such Subscriber Content, even if such Subscriber Content has been contributed and subsequently removed by you as reasonably necessary to, for example (without limitation):
Provide, maintain, and update the public Network
Process lawful requests from law enforcement agencies and government agencies
Prevent and address security incidents and data security features, support features, and to provide technical assistance as it may be required
Aggregate data to provide product optimization
This means that you cannot revoke permission for Flanger to publish, distribute, store and use such content and to allow others to have derivative rights to publish, distribute, store and use such content. The CC BY-SA 4.0 license terms are explained in further detail by Creative Commons, and the license terms applicable to content are explained in further detail here. You should be aware that all Public Content you contribute is available for public copy and redistribution, and all such Public Content must have appropriate attribution.
As stated above, by agreeing to these Public Network Terms you also agree to be bound by the terms and conditions of the Acceptable Use Policy incorporated herein, and hereby acknowledge and agree that any and all Public Content you provide to the public Network is governed by the Acceptable Use Policy.''';

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
              largeTitle: new Text('Sign up',
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
                mailIsValid == false
                ? new Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: new Center(
                    child: new Text('This email already in use.',
                    style: new TextStyle(color: Colors.red, fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  )
                : new Container(),
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
                  child: new Text('CREATE',
                  style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ), 
                  onPressed: () {
                    if(eulaAccepted == false) {
                    return showDialog(
                      barrierDismissible: true,
                      context: context, 
                      builder: (_) => new CupertinoAlertDialog(
                        title: new Text("Terms of service",
                        style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold,
                        height: 1.3,
                        ),
                        ),
                        content: new Container(
                          child: new Padding(
                            padding: EdgeInsets.all(8.0),
                            child: new Text(eula,
                            textAlign: TextAlign.justify,
                            style: new TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.normal,
                            height: 1.3,
                            ),
                            ),
                            ),
                        ),
                          actions: <Widget>[
                            new CupertinoDialogAction(
                              onPressed: (){
                                Navigator.pop(context);
                                setState(() {
                                  eulaAccepted = true;
                                });
                              },
                              child: new Text('Accept',
                              style: new TextStyle(color: Colors.blue, fontSize: 14.0),
                              ),
                            ),
                          ],
                      ),
                    );
                    } else {
                      print('ok go');
                     if(_emailEditingController.value.text.length > 4 && _passwordEditingController.value.text.length > 3) {
                      FirebaseAuth.instance
                        .createUserWithEmailAndPassword(email: _emailEditingController.value.text, password: _passwordEditingController.value.text).then((authResult) {
                          print('authResult = $authResult');
                        //Go to creationProcess
                        Navigator.pushAndRemoveUntil(
                        context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
                        new ProfileCreationProcessPage(currentUser: authResult.user.uid, currentUserEmail: _emailEditingController.value.text)),
                        (route) => false);
                        }).catchError((error) {
                          print(error.code);
                          if(error.code == 'email-already-in-use') {
                            setState(() {
                              mailIsValid = false;
                            });
                          }
                        });
                     } else {
                     }
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