import 'package:flutter/material.dart';

import 'AppColors.dart';

// Keeps record whether user is signed in or not
bool isUserSignedIn = false;

//Keeps record whether user confirm account or not
bool isConfirmedAccount = false;

// Stores auth token got after login
String authAccessToken = "";

// Stores unreadNotification count
int unreadNotificationsCount;
int cartCount;
String userEmail;

// On notification,
bool updateHomeTabOnBuild = false;
bool updateInProgressOrdersTabOnBuild = false;
bool updateCafeStoresTabOnBuild = false;
bool updateCoopsTabOnBuild = false;
bool updateExportersTabOnBuild = false;
bool updateFarmersTabOnBuild = false;
bool updateImportersTabOnBuild = false;
bool updateMillsTabOnBuild = false;
bool updateRoastersTabOnBuild = false;

// Keeps record whether an alert is already active on the screen or not
bool alertAlreadyActive = false;

// Http request timeout duration
const Duration timeoutDuration = const Duration(seconds: 30);

// Minimum default button height
const double minimumDefaultButtonHeight = 55.0;

// Dialog content( text, button title, etc) color
const Color dialogContentColor = AppColors.kAppBlack;

// App bar title text style
const TextStyle appBarTitleTextStyle = const TextStyle(
  fontWeight: FontWeight.w700,
  fontSize: 17.5,
  color: Colors.white,
/*  letterSpacing: appHeadingTitleSpacing,
  fontFamily: appHeadingTitleFont,*/
);

// Tab bar title text style
const TextStyle tabBarTitleTextStyle = const TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w600,
  /* letterSpacing: appHeadingTitleSpacing,
  fontFamily: appHeadingTitleFont,*/
  fontSize: 12.0,
);

// Can Exit app
bool canExitApp = false;
