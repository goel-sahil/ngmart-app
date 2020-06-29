import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ngmartflutter/helper/AssetStrings.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/helper/memory_management.dart';

import 'drawer/navigation_drawer.dart';
import 'login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FadeIn();
}

class FadeIn extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    moveToScreen();
  }

  get _getBG {
    return new Image.asset(
      AssetStrings.logoImage,
      width: 200,
      height: 200,
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: _getBG,
        ),
      ),
    );
  }

  void moveToScreen() async {
    await MemoryManagement.init();
    Timer _timer = new Timer(const Duration(seconds: 2), () {
      var token = MemoryManagement?.getUserLoggedIn() ?? false;
      Navigator.pushAndRemoveUntil(
        context,
        new CupertinoPageRoute(builder: (BuildContext context) {
          return (!token) ? new Login() : new Login();
        }),
        (route) => false,
      );
    });
  }
}
