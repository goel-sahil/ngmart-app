
import 'package:flutter/material.dart';
import 'package:notifier/notifier.dart';
import 'package:provider/provider.dart';

import 'helper/AppColors.dart';
import 'notifier_provide_model/dashboard_provider.dart';
import 'notifier_provide_model/login_provider.dart';
import 'ui/splash_screen.dart';

void main() =>
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<DashboardProvider>(
            create: (context) => DashboardProvider()),
        ChangeNotifierProvider<LoginProvider>(
            create: (context) => LoginProvider()),
      ],
      child: NotifierProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'NGMArt',
          theme: ThemeData(
            // Define the default brightness and colors.
            primarySwatch: Colors.green,
            hintColor: AppColors.kGrey,
          ),
          home: new SplashScreen(),
        ),
      ),
    )
    );