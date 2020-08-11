import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/Messages.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/helper/UniversalProperties.dart';
import 'package:ngmartflutter/helper/memory_management.dart';
import 'package:ngmartflutter/model/CommonResponse.dart';
import 'package:ngmartflutter/model/DeviceTokenRequest.dart';
import 'package:ngmartflutter/model/Login/LoginResponse.dart';
import 'package:ngmartflutter/model/TotalNotificationResponse.dart';
import 'package:ngmartflutter/notifier_provide_model/dashboard_provider.dart';
import 'package:ngmartflutter/ui/admin/Contact/ContactScreen.dart';
import 'package:ngmartflutter/ui/admin/banner/AddBannerScreen.dart';
import 'package:ngmartflutter/ui/admin/brand/AddBrandScreen.dart';
import 'package:ngmartflutter/ui/admin/cms/CmsScreen.dart';
import 'package:ngmartflutter/ui/admin/product/AddProductScreen.dart';
import 'package:ngmartflutter/ui/admin/product/ProductList.dart';
import 'package:ngmartflutter/ui/admin/quantity/AddQuantityScreen.dart';
import 'package:ngmartflutter/ui/admin/order/OrderScreen.dart';
import 'package:ngmartflutter/ui/admin/quantity/QuantiityScreen.dart';
import 'package:ngmartflutter/ui/admin/settings/AdminSetting.dart';
import 'package:ngmartflutter/ui/drawer/drawer_item.dart';
import 'package:ngmartflutter/ui/login/login_screen.dart';
import 'package:ngmartflutter/ui/notification/NotificationScreen.dart';
import 'package:provider/provider.dart';

import '../CommingSoonScreen.dart';
import 'banner/BannerScreen.dart';
import 'brand/BrandScreen.dart';
import 'category/AddCategoryScreen.dart';
import 'category/CategoryScreen.dart';
import 'package:package_info/package_info.dart';

class AdminNavigationDrawer extends StatefulWidget {
  _AdminNavigationDrawerState createState() => _AdminNavigationDrawerState();
}

class _AdminNavigationDrawerState extends State<AdminNavigationDrawer>
    with TickerProviderStateMixin {
  final _pageController = PageController();
  int _selectionIndex = 0;
  bool _isLoggedIn = false;
  bool showAddIcon = true;
  var drawerItems = new List();
  LoginResponse userInfo;
  Widget _body;
  String _title = "Brands";
  DateTime currentBackPressTime;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  FirebaseMessaging _firebaseMessaging;
  bool showNotification = true;
  DashboardProvider provider;

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

  @override
  void initState() {
    printPackage();
    _body = CommingSoonScreen();
    MemoryManagement.init();
    _firebaseMessaging = FirebaseMessaging();
    _initPushNotification();
    configurePushNotification();
    _isLoggedIn = MemoryManagement.getLoggedInStatus() ?? false;
    print("Logged In===> $_isLoggedIn");
    if (_isLoggedIn) {
      var infoData = jsonDecode(MemoryManagement.getUserInfo());
      userInfo = LoginResponse.fromJson(infoData);
    }
    drawerItems.add(DrawerItem("Brands", FontAwesomeIcons.meetup));
    drawerItems
        .add(DrawerItem("Quantity Units", FontAwesomeIcons.sortAmountUp));
    drawerItems.add(DrawerItem("Category", FontAwesomeIcons.bars));
    drawerItems.add(DrawerItem("Products", FontAwesomeIcons.th));
    drawerItems.add(DrawerItem("Banners", FontAwesomeIcons.firstOrder));
    drawerItems.add(DrawerItem("Orders", FontAwesomeIcons.history));
    drawerItems.add(DrawerItem("Settings", FontAwesomeIcons.cogs));
    drawerItems.add(DrawerItem("CMS", FontAwesomeIcons.userSecret));
    drawerItems.add(DrawerItem("Contact Request", FontAwesomeIcons.compress));
    drawerItems.add(DrawerItem("Log out", FontAwesomeIcons.signOutAlt));

    Timer(Duration(milliseconds: 500), () {
      _hitNotificationApi();
    });

    super.initState();
  }

  _onSelectItem(int index) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
    if (index == 0) {
      //show profile
      _pageController.jumpToPage(0);
      _title = "Brands";
      showAddIcon = true;
      showNotification = true;
    } else if (index == 1) {
      //show profile
      _pageController.jumpToPage(1);
      _title = "Quantity Units";
      showAddIcon = true;
      showNotification = false;
    } else if (index == 2) {
      //show cart
      _pageController.jumpToPage(2);
      _title = "Category";
      showAddIcon = true;
      showNotification = false;
    } else if (index == 3) {
      //show purchi
      _title = "Product";
      _pageController.jumpToPage(3);
      showAddIcon = true;
      showNotification = false;
    } else if (index == 4) {
      //show order history
      _title = "Banners";
      _pageController.jumpToPage(4);
      showAddIcon = true;
      showNotification = false;
    } else if (index == 5) {
      //show setting
      _title = "Orders";
      _pageController.jumpToPage(5);
      showAddIcon = false;
      showNotification = false;
    } else if (index == 6) {
      //show setting
      _title = "Settings";
      _pageController.jumpToPage(6);
      showAddIcon = false;
      showNotification = false;
    } else if (index == 7) {
      //show setting
      _title = "CMS";
      _pageController.jumpToPage(7);
      showAddIcon = false;
      showNotification = false;
    } else if (index == 8) {
      //show setting
      _title = "Contact Request";
      _pageController.jumpToPage(8);
      showAddIcon = false;
      showNotification = false;
    } else if (index == 9) {
      onLogoutSuccess(context: context);
      _pageController.jumpToPage(9);
    }
    setState(() {
      _selectionIndex = index;
    });
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
    } else {
      APIError apiError = response;
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

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
      //moveToScreenFromPush(int.tryParse(payload)); //when click in push
    }
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
    int type = int.tryParse(data["data"]["type"]);
    await flutterLocalNotificationsPlugin.show(
        100, title, body, platformChannelSpecifics,
        payload: type.toString());
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

  Future<void> _hitNotificationApi() async {
    var response = await provider.getNotificationCartItemCount(context);
    if (response is APIError) {
//      showInSnackBar(response.error);
    } else if (response is TotalNotificationResponse) {
      unreadNotificationsCount = response.data.totalNotifications;
//      cartCount = response.data.totalCartItems;
      setState(() {});
    }
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
      appBar: AppBar(
        title: Text(_title ?? "Brands"),
        centerTitle: true,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: showAddIcon
                  ? IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () async {
                        if (_pageController.page == 0) {
                          bool isWOrkDone = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => AddBrandScreen(
                                        fromBrandScreen: false,
                                        title: "",
                                        brandId: 1,
                                      )));
                          print("Page controller==> $isWOrkDone");
                          if (isWOrkDone) {
                            _pageController.jumpToPage(1);
                            Timer(Duration(milliseconds: 300), () {
                              _pageController.jumpToPage(0);
                            });
                          }
                        } else if (_pageController.page == 1) {
                          bool isWOrkDone = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => AddQuantityScreen(
                                        fromBrandScreen: false,
                                        title: "",
                                        brandId: 1,
                                      )));
                          if (isWOrkDone) {
                            _pageController.jumpToPage(2);
                            Timer(Duration(milliseconds: 300), () {
                              _pageController.jumpToPage(1);
                            });
                          }
                        } else if (_pageController.page == 2) {
                          bool isWOrkDone = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => AddCategoryScreen(
                                        fromCategoryScreen: false,
                                      )));
                          if (isWOrkDone != null && isWOrkDone) {
                            _pageController.jumpToPage(3);
                            Timer(Duration(milliseconds: 300), () {
                              _pageController.jumpToPage(2);
                            });
                          }
                        } else if (_pageController.page == 3) {
                          bool isWOrkDone = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => AddProductScreen(
                                        fromProductScreen: false,
                                      )));
                          if (isWOrkDone != null && isWOrkDone) {
                            _pageController.jumpToPage(4);
                            Timer(Duration(milliseconds: 300), () {
                              _pageController.jumpToPage(3);
                            });
                          }
                        } else if (_pageController.page == 4) {
                          bool isWOrkDone = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => AddBannerScreen(
                                        fromProductScreen: false,
                                      )));
                          if (isWOrkDone != null && isWOrkDone) {
                            _pageController.jumpToPage(3);
                            Timer(Duration(milliseconds: 300), () {
                              _pageController.jumpToPage(4);
                            });
                          }
                        }
                      })
                  : Container()),
          showNotification
              ? getNotiWidget(
                  count: unreadNotificationsCount,
                  onClick: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => NotificationScreen(
                                  fromAdmin: true,
                                )));
                  })
              /*Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: IconButton(
                      icon: Icon(Icons.notifications),
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => NotificationScreen(
                                      fromAdmin: true,
                                    )));
                      }))*/
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
                accountEmail:
                    Text(_isLoggedIn ? userInfo?.data?.user?.email ?? "" : ""),
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
              BrandScreen(),
              QuantityScreen(),
              CategoryScreen(),
              ProductScreen(),
              BannerScreen(),
              AdminOrdersScreen(
                fromNotification: false,
              ),
              AdminSettingScreen(),
              CmsScreen(),
              ContactScreen(),
              CommingSoonScreen(),
            ],
            physics: NeverScrollableScrollPhysics()),
      ),
    );
  }

  _setSelectedZero() {
    _title = "Brands";
    _pageController.jumpToPage(0);
    showAddIcon = true;
    showNotification = true;
    setState(() {
      _selectionIndex = 0;
    });
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  moveToScreenFromPush(int type) {
    print("Type==> $type");
    if (MemoryManagement.getUserRole() == 1) {
      if (type == 5) {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => AdminOrdersScreen(
                      fromNotification: true,
                    )));
      }
    }
  }
}
