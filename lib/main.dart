import 'package:dwrandaz/Siginin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
      //  theme: ThemeData.dark(),
          home: MyApp(),
      )
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Signin();
  }
}
