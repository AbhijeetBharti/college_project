import 'package:collegeproject/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await FirebaseAuth.instance.signOut();
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding:
                EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                buildRow('Pole 1', 'lib/assets/icons8-light-on-64.png'),
                buildRow('Pole 2', 'lib/assets/icons8-light-on-64.png'),
                buildRow('Pole 3', 'lib/assets/icons8-light-40.png'),
                buildRow('Pole 4', 'lib/assets/icons8-light-40.png'),
                buildRow('Pole 5', 'lib/assets/icons8-light-on-64.png'),
                buildRow('Pole 6', 'lib/assets/icons8-light-40.png'),
                buildRow('Pole 7', 'lib/assets/icons8-light-on-64.png'),
                buildRow('Pole 8', 'lib/assets/icons8-light-40.png'),
                buildRow('Pole 9', 'lib/assets/icons8-light-40.png'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildRow(String poleNo, String path) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        SizedBox(
          height: 70,
          width: 70,
          child: Image.asset(
            path,
          ),
        ),
        Text(
          poleNo,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 40,
          child: LiteRollingSwitch(
            //initial value
            value: true,
            textOn: 'ON',
            textOff: 'OFF',
            colorOn: purple,
            colorOff: purple,
            iconOn: Icons.done,
            iconOff: Icons.clear,
            textSize: 15.0,
            onChanged: (bool state) {
              //Use it to manage the different states
              print('Current State of SWITCH IS: $state');
            },
          ),
        ),
      ],
    );
  }
}
