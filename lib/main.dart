import 'package:dwrandaz/MainApp.dart';
import 'package:dwrandaz/Siginin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        //  theme: ThemeData.dark(),
        home: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences sharedPreferences;

  bool isLogin;

  getShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
    isLogin = sharedPreferences.getBool("login") ?? false;
    print(isLogin);
    return isLogin;
  }

  @override
  void initState() {
    // TODO: implement initState
    getShared();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      body: FutureBuilder(
        future: getShared(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            if (snapshot.data == false) {
              return Signin();
            } else {
              return MainApp();
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
