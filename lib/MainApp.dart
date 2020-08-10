import 'package:dwrandaz/ByDate.dart';
import 'package:dwrandaz/OverAll.dart';
import 'package:dwrandaz/Siginin.dart';
import 'package:flutter/material.dart';
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xff1976d2),
          title: Text('Analytics Charts'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Signin()),
                    (Route<dynamic> route) => false);
                sharedPreferences.setBool("login", false);
              },
            )
          ],
        ),
        body:
        PageView.builder(
          itemBuilder: (context, position) => pages[position],
          itemCount: pages.length,
        )
        ,
      ),
    );
  }

  _sampleForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: <Widget>[
            Form(
              child: Column(
                children: <Widget>[
                  ListTile(title: Text("title", textAlign: TextAlign.center)),
                  for (int i = 0; i < 10; i++) TextFormField(
                    decoration: InputDecoration(hintText: "field ${i + 1}"),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




