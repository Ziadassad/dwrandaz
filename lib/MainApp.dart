import 'package:dwrandaz/ByDate.dart';
import 'package:dwrandaz/OverAll.dart';
import 'package:dwrandaz/Profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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

  final controller = PageController(viewportFraction: 1);

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
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: PageView.builder(
              controller: controller,
              itemBuilder: (context, position) => pages[position],
              itemCount: pages.length,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 640, horizontal: 180),
            child: SmoothPageIndicator(
              controller: controller,
              count: 2,
              effect: WormEffect(),
            ),
          ),
        ],
      ),
    );
  }

}




