import 'package:collegeproject/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    isUserSignedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    );
  }

  isUserSignedIn() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      var route = new MaterialPageRoute(
        builder: (BuildContext context) => new HomePage(),
      );
      Navigator.of(context).pushReplacement(route);
    } else {
      var route = new MaterialPageRoute(
        builder: (BuildContext context) => new FirstPage(
            title: 'Electrical Device Surveillance and Control System'),
      );
      Navigator.of(context).pushReplacement(route);
    }
  }
}
