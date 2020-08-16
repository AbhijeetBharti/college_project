import 'package:collegeproject/colors.dart';
import 'package:collegeproject/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List Polelists = [];
  List Statuslists = [];
  final dbRef = FirebaseDatabase.instance.reference().child("poles");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () async {
              await FirebaseAuth.instance.signOut().then((onValue) {
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => FirstPage(),
                );
                Navigator.of(context).pushReplacement(route);
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: dbRef.once(),
            builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
              if (snapshot.hasData) {
                Map<dynamic, dynamic> values = snapshot.data.value;
                Polelists.clear();
                Statuslists.clear();
                values.forEach((key, values) {
                  Polelists.add(key);
                  Statuslists.add(values);
                });
                return Column(
                  children: <Widget>[
                    ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: Statuslists.length - 1,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                buildRow(
                                    Polelists[index].toString(),
                                    Statuslists[index]["switchStatus"]
                                        ? 'lib/assets/icons8-light-on-64.png'
                                        : 'lib/assets/icons8-light-40.png',
                                    Statuslists[index]["switchStatus"],
                                    index),
                              ],
                            ),
                          );
                        }),
                    Spacer(),
                    Container(
                      height: 50,
                      child: Card(
                        color: Colors.purple[900],
                        child: Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Cherrlight Status :".toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              LiteRollingSwitch(
                                //initial value
                                value: Statuslists[Statuslists.length - 1],
                                textOn: 'ON',
                                textOff: 'OFF',
                                colorOn: purple,
                                colorOff: purple,
                                iconOn: Icons.done,
                                iconOff: Icons.clear,
                                textSize: 15.0,
                                onChanged: (bool state) {
                                  //Use it to manage the different states
                                  //print('Current State of SWITCH IS: $state');
                                  dbRef.update({"cheerlights": state});
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  Row buildRow(String poleNo, String path, bool switchStatus, int index) {
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
          poleNo.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 40,
          child: LiteRollingSwitch(
            //initial value
            value: switchStatus,
            textOn: 'ON',
            textOff: 'OFF',
            colorOn: purple,
            colorOff: purple,
            iconOn: Icons.done,
            iconOff: Icons.clear,
            textSize: 15.0,
            onChanged: (bool state) {
              //Use it to manage the different states
              dbRef.update({poleNo + '/switchStatus': state});
            },
            onTap: () {
              setState(() {
                Statuslists[index]["switchStatus"] =
                    !Statuslists[index]["switchStatus"];
              });
            },
          ),
        ),
      ],
    );
  }
}
