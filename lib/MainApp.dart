import 'package:dwrandaz/ByDate.dart';
import 'package:dwrandaz/OverAll.dart';
import 'package:dwrandaz/Siginin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  SharedPreferences sharedPreferences;

  List<Widget> pages = [OverAll(), ByDate()];

  getShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff1976d2),
        title: Text('Analytics Charts'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_pin),
            onPressed: () {
              // showDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              showDialog(context);
            },
          )
        ],
      ),
      body: PageView.builder(
        itemBuilder: (context, position) => pages[position],
        itemCount: pages.length,
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




