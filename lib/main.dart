import 'package:collegeproject/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collegeproject/home.dart';
import 'colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'College Project',
      theme: ThemeData(
        primarySwatch: purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

class FirstPage extends StatefulWidget {
  FirstPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final globalKey = GlobalKey<ScaffoldState>();

  bool passwordVisible;
  String _email;
  String _password;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future signIn(String email, String password) async {
    if (email == null || password == null) {
      _showSnackBar(context, "Something went wrong !");
    } else {
      try {
        showDialogue(context, 'Authenticating...');
        FirebaseUser user = (await firebaseAuth.signInWithEmailAndPassword(
                email: email, password: password))
            .user;
        if (user != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          await prefs.setString('uid', user.uid);

          var route = new MaterialPageRoute(
            builder: (BuildContext context) => new HomePage(),
          );
          dialogue.hide();
          Navigator.of(context).pushReplacement(route);
        } else {
          dialogue.hide();
          _showSnackBar(context, "Something went wrong.");
        }
      } on PlatformException catch (loginError) {
        if (loginError.code == "ERROR_USER_NOT_FOUND") {
          dialogue.hide();
          _showSnackBar(context, "User not found.");
        } else {
          dialogue.hide();
          _showSnackBar(context, "Something went wrong.");
        }
      }
    }
  }

  ProgressDialog dialogue;

  void showDialogue(context, text) {
    dialogue = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    dialogue.style(message: text);
    dialogue.show();
  }

  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      dialogue.hide();
      _showSnackBar(context, "Reset link has been sent. Check your email.");
    } on PlatformException catch (e) {
      if (e.code == "ERROR_USER_NOT_FOUND") {
        dialogue.hide();
        _showSnackBar(context, 'Email not registered.');
      } else {
        dialogue.hide();
        _showSnackBar(context, 'Something went wrong. Report on Google Play.');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: globalKey,
      resizeToAvoidBottomPadding: false,
      body: WillPopScope(
        onWillPop: () {
          return SystemNavigator.pop();
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Spacer(flex: 1),
                SvgPicture.asset(
                  'lib/assets/undraw_date_night_bda8.svg',
                  width: screenWidth / 2,
                ),
                Spacer(
                  flex: 2,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.person),
                      ),
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: TextField(
                    obscureText: !passwordVisible,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.vpn_key),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                  ),
                ),
                Spacer(
                  flex: 2,
                ),
                ButtonTheme(
                  minWidth: 300,
                  child: RaisedButton(
                    onPressed: () {
                      signIn(_email, _password);
                    },
                    textColor: Colors.white,
                    color: Colors.purple[900],
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text('SIGN IN', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
                Spacer(
                  flex: 6,
                ),
                Divider(
                  thickness: 1,
                ),
                InkWell(
                  onTap: () {
                    _showDialog();
                  },
                  child: Text(
                    "FORGOT PASSWORD ?",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none),
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: purple,
    );
    globalKey.currentState.showSnackBar(snackBar);
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            height: 320,
            width: 300,
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  margin: const EdgeInsets.only(
                      top: 30, bottom: 10, right: 10, left: 10),
                  child: Icon(
                    Icons.vpn_key,
                    color: Colors.purple[900],
                  ),
                ),
                Text(
                  "Reset Your Password",
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'Whitney', fontSize: 20),
                ),
                Container(
                    margin: const EdgeInsets.all(20),
                    child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: new InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(
                              color: Colors.grey, fontFamily: 'Whitney'),
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        })),
                Container(
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: ButtonTheme(
                    minWidth: 200,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        showDialogue(context, 'Sending...');
                        resetPassword(_email);
                      },
                      textColor: Colors.white,
                      color: Colors.purple[900],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Send',
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
