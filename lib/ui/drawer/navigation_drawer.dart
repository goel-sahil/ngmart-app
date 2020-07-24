import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/Const.dart';
import 'package:ngmartflutter/helper/Messages.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/helper/memory_management.dart';
import 'package:ngmartflutter/model/CommonResponse.dart';
import 'package:ngmartflutter/model/DeviceTokenRequest.dart';
import 'package:ngmartflutter/model/Login/LoginResponse.dart';
import 'package:ngmartflutter/notifier_provide_model/dashboard_provider.dart';
import 'package:ngmartflutter/ui/cart/CartPage.dart';
import 'package:ngmartflutter/ui/contactUs/Contact_us.dart';
import 'package:ngmartflutter/ui/login/login_screen.dart';
import 'package:ngmartflutter/ui/notification/NotificationScreen.dart';
import 'package:ngmartflutter/ui/orderByParchi/OrderByParchiScreen.dart';
import 'package:ngmartflutter/ui/orderHistory/OrderHistory.dart';
import 'package:ngmartflutter/ui/profile/ProfileScreen.dart';
import 'package:ngmartflutter/ui/search/SearchPage.dart';
import 'package:ngmartflutter/ui/settings/setting.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'drawer_item.dart';
import 'HomeScreen.dart';

class NavigationDrawer extends StatefulWidget {
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer>
    with TickerProviderStateMixin {
  final _pageController = PageController();
  int _selectionIndex = 0;
  bool _isLoggedIn = false;
  bool showSearch = true;
  bool showNotification = true;
  var drawerItems = new List();
  LoginResponse userInfo;
  String _title = "NGMart";
  DateTime currentBackPressTime;
  FirebaseMessaging _firebaseMessaging;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  DashboardProvider provider;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _initialized = false;

  _onSelectItem(int index) {
    Navigator.pop(context);
    if (_isLoggedIn) {
      if (index == 0) {
        _title = "NGMart";
        _pageController.jumpToPage(0);
        showSearch = true;
        showNotification = true;
      } else if (index == 1) {
        //show profile
        _pageController.jumpToPage(1);
        _title = "My Profile";
        showSearch = false;
        showNotification = false;
      } else if (index == 2) {
        //show cart
        _pageController.jumpToPage(2);
        _title = "My Cart";
        showSearch = false;
        showNotification = false;
      } else if (index == 3) {
        //show purchi
        _title = "Order by Parchi";
        _pageController.jumpToPage(3);
        showSearch = false;
        showNotification = false;
      } else if (index == 4) {
        //show order history
        _title = "Order History";
        _pageController.jumpToPage(4);
        showSearch = false;
        showNotification = false;
      } else if (index == 5) {
        //show setting
        _title = "Settings";
        _pageController.jumpToPage(5);
        showSearch = false;
        showNotification = false;
      } else if (index == 6) {
        //show contact us
        _title = "Contact us";
        _pageController.jumpToPage(6);
        showSearch = false;
        showNotification = false;
      } else if (index == 7) {
        onLogoutSuccess(context: context);
        _pageController.jumpToPage(7);
      }
    } else {
      if (index == 0) {
        _pageController.jumpToPage(0);
        _title = "NGMart";
        showSearch = true;
        showNotification = false;
      } else if (index == 1) {
        //Show parchi screen
        _title = "Order by Parchi";
        _pageController.jumpToPage(3);
        showSearch = false;
        showNotification = false;
      } else if (index == 2) {
        //Show Settings
        _title = "Settings";
        _pageController.jumpToPage(5);
        showSearch = false;
        showNotification = false;
      } else if (index == 3) {
        // Contact us
        _title = "Contact us";
        _pageController.jumpToPage(6);
        showSearch = false;
        showNotification = false;
      }
    }

    setState(() {
      _selectionIndex = index;
    });
  }

  @override
  void initState() {
    MemoryManagement.init();
    _firebaseMessaging = FirebaseMessaging();
    _initPushNotification();
    configurePushNotification();
    printPackage();
    _isLoggedIn = MemoryManagement.getLoggedInStatus() ?? false;
    print("Logged In===> $_isLoggedIn");
    if (_isLoggedIn) {
      var infoData = jsonDecode(MemoryManagement.getUserInfo());
      userInfo = LoginResponse.fromJson(infoData);
    }
    drawerItems.add(DrawerItem("Shop Now", FontAwesomeIcons.cartPlus));
    if (_isLoggedIn) {
      drawerItems.add(DrawerItem("My Profile", FontAwesomeIcons.userCircle));
      drawerItems.add(DrawerItem("My Cart", FontAwesomeIcons.shoppingCart));
    }
    drawerItems
        .add(DrawerItem("Order by Parchi", FontAwesomeIcons.luggageCart));
    if (_isLoggedIn) {
      drawerItems.add(DrawerItem("Order History", FontAwesomeIcons.history));
    }
    drawerItems.add(DrawerItem("Settings", FontAwesomeIcons.cogs));
    drawerItems.add(DrawerItem("Contact us", FontAwesomeIcons.mailBulk));
    if (_isLoggedIn) {
      drawerItems.add(DrawerItem("Log out", FontAwesomeIcons.signOutAlt));
    }

    if (_isLoggedIn) {
      showNotification = true;
    } else {
      showNotification = false;
    }
    setState(() {});
    super.initState();
  }

  void configurePushNotification() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        String body = message['notification']['body']?.toString();
        String title = message['notification']['title']?.toString();
        print("body==> $body");
        showNotificationBar(title, body, message);
      },
      onResume: (Map<String, dynamic> message) async {
        String payload = message['data']['type'];

        moveToScreenFromPush(int.tryParse(payload));
      },
      onLaunch: (Map<String, dynamic> message) async {
        int type = int.tryParse(message["data"]["type"]);
        moveToScreenFromPush(type);
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      //printt("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      //printt("DevToken   $token");
      if (token != null) {
        setDeviceToken(token);
        // updateTokenToFirebase(token); //save to firebase
      }
    });
  }

  void setDeviceToken(String token) async {
    bool isConnected = await isConnectedToInternet();
    if (!isConnected) {
      showAlertDialog(
          context: context, title: "Error", message: Messages.noInternetError);
      return;
    }
    print("SET TOKEN==> $token");
    if (isConnected && _isLoggedIn) {
      updateToken(token: token);
    }
  }

  void updateToken({String token}) async {
    provider.setLoading();
    DeviceTokenResponse request = DeviceTokenResponse(deviceToken: token);
    var response = await provider.updateToken(context, request);
    if (response != null && (response is CommonResponse)) {
      print(response.message);
//      showInSnackBar(response.message);
    } else {
      APIError apiError = response;
//      showInSnackBar(apiError.error);
    }
  }

  void _initPushNotification() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void showNotificationBar(
      String title, String body, Map<String, dynamic> data) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        new AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description');
    IOSNotificationDetails iOSPlatformChannelSpecifics =
        new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//    int type = int.tryParse(data["data"]["type"]);
    await flutterLocalNotificationsPlugin.show(
        100, title, body, platformChannelSpecifics,
        payload: 1.toString());
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      ),
    );
  }

  //screen redirection for chat
  moveToScreenFromPush(int type) {
    print("Type==> $type");
//    switch ((type)) {
//      case APPLIED_TO_LENDER_POST:
//        movetoBorrowScreen(0);
//        break;
//      case LENDER_ACCEPT_REQUEST:
//        movetoBorrowScreen(0);
//        break;
//      case LENDER_REJECT_REQUSET:
//        movetoBorrowScreen(0);
//        break;
//      case LENDER_ACCEPT_HIS_POST_REQUEST:
//        movetoBorrowScreen(0);
//        break;
//      case LENDER_REJECT_HIS_POST_REQUEST:
//        movetoBorrowScreen(0);
//        break;
//      case COMPANY_ACCEPT_REQUEST:
//        movetoBorrowScreen(1);
//        break;
//      case COMPANY_REJECT_REQUEST:
//        movetoBorrowScreen(0);
//        break;
//      case LOAN_FUNDED:
//      case LOAN_PAID_OFF:
//      case LOAN_DEFAULTED:
//        movetoBorrowScreen(1);
//        break;
//      case CHAT_MESSAGE:
//        _moveToChatList();
//
//        break;
//    }
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<DashboardProvider>(context);
    List<Widget> drawerOptions = [];
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(ListTile(
        leading: Icon(d.icon),
        title: Text(
          d.title,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
        ),
        selected: i == _selectionIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_title ?? "NGMart"),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: showSearch
                ? IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => SearchPage()));
                    })
                : Container(),
          ),
          showNotification
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: IconButton(
                      icon: Icon(Icons.notifications),
                      onPressed: () {
                        if (!_isLoggedIn) {
                          Navigator.of(context).push(new CupertinoPageRoute(
                              builder: (context) => Login()));
                        } else {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => NotificationScreen()));
                        }
                      }))
              : Container()
        ],
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Container(
                  padding: EdgeInsets.only(right: 20),
                  child: InkWell(
                    onTap: () {
                      if (!_isLoggedIn) {
                        Navigator.of(context).push(new CupertinoPageRoute(
                            builder: (context) => Login()));
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          _isLoggedIn
                              ? "${userInfo.data.user.firstName} ${userInfo.data.user.lastName}"
                              : "LogIn",
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(
                          FontAwesomeIcons.arrowRight,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                accountEmail: Text(_isLoggedIn ? userInfo.data.user.email : ""),
                currentAccountPicture: _isLoggedIn
                    ? CircleAvatar(
                        child: Text(
                          userInfo.data.user.firstName[0] ?? "N",
                          style: TextStyle(fontSize: 40.0),
                        ),
                      )
                    : Container(),
              ),
              Column(
                children: drawerOptions,
              ),
            ],
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: PageView(
            controller: _pageController,
            children: <Widget>[
              HomeScreen(),
              ProfileScreen(
                fromAdmin: false,
              ),
              CartPage(
                fromNavigationDrawer: true,
              ),
              OrderByParchiScreen(
                fromNavigation: true,
              ),
              OrderHistory(),
              Setting(),
              ContactUs(),
            ],
            physics: NeverScrollableScrollPhysics()),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (_pageController.page != 0) {
      _setSelectedZero();
      return Future.value(false);
    } else if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      FlutterToast(context).showToast(
        child: toast,
        toastDuration: Duration(seconds: 1),
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  _setSelectedZero() {
    _title = "NGMart";
    _pageController.jumpToPage(0);
    showSearch = true;
    if (_isLoggedIn) {
      showNotification = true;
    } else {
      showNotification = false;
    }
    setState(() {
      _selectionIndex = 0;
    });
  }

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: AppColors.kPrimaryBlue,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.warning,
          color: Colors.white,
        ),
        SizedBox(
          width: 12.0,
        ),
        Text(
          "Press Back again to exit.",
          style: TextStyle(color: Colors.white),
        ),
      ],
    ),
  );

  Future<void> updateTokenToFirebase(String token) async {
    await handleSignIn(); //annonymous login
    var platForm = "IOS";
    if (Platform.isAndroid) {
      platForm = "ANDROID";
    }

    var userName = "";
    var userId = "";

    try {
      if (MemoryManagement.getUserInfo() != null) {
        var infoData = jsonDecode(MemoryManagement.getUserInfo());
        var userinfo = LoginResponse.fromJson(infoData);
        userName =
            userinfo.data.user.firstName + " " + userinfo.data.user.lastName;
        userId = userinfo.data.user.id.toString();
      }
    } catch (ex) {
      return null;
    }
    //TODO: Update token
    updateToken(token: token);
  }

  Future<void> handleSignIn() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signInAnonymously();
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
      moveToScreenFromPush(int.tryParse(payload)); //when click in push
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  printPackage() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    print("appName===>$appName");
    print("packageName===>$packageName");
    print("version===>$version");
    print("buildNumber===>$buildNumber");
  }

//  Future<bool> updateDeviceToken(
//      {
//        String deviceToken,
//        String userId,
//        @required String deviceType,
//        @required String userName}) async {
//
//    String deviceid = MemoryManagement.getuserId();
//
//    var document =
//    Firestore.instance.collection(FCM_DEVICE_TOKEN).document(userId);
//
//    var documentDevices = Firestore.instance
//        .collection(FCM_DEVICE_TOKEN)
//        .document(userId)
//        .collection(DEVICES)
//        .document(deviceid);
//
//    //save document to collection
//    await document.setData(
//        {"deviceType": deviceType, "userId": userId, "userName": userName});
//    //save token to devices
//    await documentDevices.setData({
//      "fcmTokenId": deviceToken,
//    });
//
//    return true;
//  }
}
