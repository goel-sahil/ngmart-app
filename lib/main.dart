import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ngmartflutter/notifier_provide_model/admin_provider.dart';
import 'package:notifier/notifier.dart';
import 'package:provider/provider.dart';

import 'helper/AppColors.dart';
import 'notifier_provide_model/dashboard_provider.dart';
import 'notifier_provide_model/login_provider.dart';
import 'ui/splash_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.kPrimaryBlue
  ));
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<DashboardProvider>(
          create: (context) => DashboardProvider()),
      ChangeNotifierProvider<LoginProvider>(
          create: (context) => LoginProvider()),
      ChangeNotifierProvider<AdminProvider>(
          create: (context) => AdminProvider()),
    ],
    child: NotifierProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NGMart',
        theme: ThemeData(
          // Define the default brightness and colors.
          primarySwatch: Colors.green,
          hintColor: AppColors.kGrey,
        ),
        home: new SplashScreen(),
      ),
    ),
  ));
}
