import 'package:dwrandaz/Siginin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SharedPreferences sharedPreferences;

  getShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 50),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.lightBlue,
              radius: 80,
              child: Icon(
                Icons.person,
                size: 140,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "company : dwarandaz",
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30),
            ),
            SizedBox(
              height: 30,
            ),
            Text("email  :  dwrandaz2020@gmail.com"),
            SizedBox(
              height: 200,
            ),
            Container(
              width: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), color: Colors.red),
              child: FlatButton(
                child: Text("Log Out"),
                onPressed: () {
                  showDialog(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  showDialog(context) {
    return Alert(
        context: context,
        title: "logout account",
        desc: "Do you want to logout",
        buttons: [
          DialogButton(
            child: Text("Ok"),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Signin()),
                  (Route<dynamic> route) => false);
              logout();
            },
          ),
          DialogButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ]).show();
  }

  logout() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("login", false);
  }
}
