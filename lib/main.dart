import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:dwrandaz/MainApp.dart';
import 'package:dwrandaz/Siginin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 1 - bage navigator  /
// 2 - pichart desgin and top team /
// 3 - click date
// 4 - color list
// 5 - profile
// 6 - number formate

void main() {
  runApp(
    ConnectivityAppWrapper(
      app: MaterialApp(
          debugShowCheckedModeBanner: false,
          //  theme: ThemeData.dark(),
          home: MyApp()),
    ),
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
      body: ConnectivityWidgetWrapper(
        decoration: BoxDecoration(
          color: Colors.purple,
          gradient: new LinearGradient(
            colors: [Colors.red, Colors.cyan],
          ),
        ),
        message: 'you are offline',
        child: FutureBuilder(
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
      ),
    );
  }
}
