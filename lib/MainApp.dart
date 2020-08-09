import 'package:dwrandaz/ByDate.dart';
import 'package:dwrandaz/OverAll.dart';
import 'package:flutter/material.dart';


class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {



  List<Widget> pages = [ OverAll() , ByDate() ];


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff1976d2),
          title: Text('Analytics Charts'),
        ),
        body:
        PageView.builder(
            itemBuilder: (context , position) => pages[position],
          itemCount: pages.length,
        )
        ,
      ),
    );
  }
}




