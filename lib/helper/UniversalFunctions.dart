import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ngmartflutter/helper/styles.dart';
import 'package:ngmartflutter/ui/drawer/HomeScreen.dart';
import 'package:ngmartflutter/ui/splash_screen.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AppColors.dart';
import 'AssetStrings.dart';
import 'Messages.dart';
import 'UniversalProperties.dart';
import 'memory_management.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

// Todo: actual

// Returns screen size
Size getScreenSize({@required BuildContext context}) {
  return MediaQuery.of(context).size;
}

// Returns status bar height
double getStatusBarHeight({@required BuildContext context}) {
  return MediaQuery.of(context).padding.top;
}

bool isAndroidPlatform({@required BuildContext context}) {
  if (Platform.isAndroid) {
    return true;
  } else {
    return false;
  }
}

// Returns bottom padding for round edge screens
double getSafeAreaBottomPadding({@required BuildContext context}) {
  return MediaQuery.of(context).padding.bottom;
}

// Returns Keyboard size
bool isKeyboardOpen({@required BuildContext context}) {
  return MediaQuery.of(context).viewInsets.bottom > 0.0;
}

// Returns spacer
Widget getSpacer({double height, double width}) {
  return new SizedBox(
    height: height ?? 0.0,
    width: width ?? 0.0,
  );
}

// Clears memory on logout success
void onLogoutSuccess({
  @required BuildContext context,
}) {
  MemoryManagement.clearMemory();
  customPushAndRemoveUntilSplash(
    context: context,
  );
}

// Custom Push And Remove Until Splash
void customPushAndRemoveUntilSplash({
  @required BuildContext context,
}) {
  Navigator.pushAndRemoveUntil(
    context,
    new CupertinoPageRoute(builder: (BuildContext context) {
      return new SplashScreen();
    }),
    (route) => false,
  );
}

// Logs out user
void logoutUser({
  @required BuildContext context,
}) {
//  UniversalAPI.logout(
//      context: context,
//      mounted: null,
//      requestBody: {},
//      onSuccess: () {
//        print("success");
//        onLogoutSuccess(context: context);
//      });
}

// Returns datetime parsing string of format "MM/dd/yy"
DateTime getDateFromString({
  @required String dateString,
}) {
  try {
    return DateTime.parse(dateString);
  } catch (e) {
    return DateTime.now();
  }
}

// CONVERTS DOUBLE INTO RADIANS
num getRadians({@required double value}) {
  return value * (3.14 / 180);
}

class ParentDashboard {}

// Checks target platform
bool isAndroid() {
  return defaultTargetPlatform == TargetPlatform.android;
}

// Asks for exit
Future<bool> askForExit() async {
//  if (canExitApp) {
//    exit(0);
//    return Future.value(true);
//  } else {
//    canExitApp = true;
//    Fluttertoast.showToast(
//      msg: "Please click BACK again to exit",
//      toastLength: Toast.LENGTH_LONG,
//      gravity: ToastGravity.BOTTOM,
//    );
//    new Future.delayed(
//        const Duration(
//          seconds: 2,
//        ), () {
//      canExitApp = false;
//    });
//    return Future.value(false);
//  }
}

// Returns no data view
Widget getNoDataView({
  @required String msg,
  TextStyle messageTextStyle,
  @required VoidCallback onRetry,
}) {
  return new Center(
    child: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text(msg ?? "No data found", style: h6),
      ],
    ),
  );
}

// Returns platform specific back button icon
IconData getPlatformSpecificBackIcon() {
  return defaultTargetPlatform == TargetPlatform.iOS
      ? Icons.arrow_back_ios
      : Icons.arrow_back;
}

// Sets name fields
String setName({
  @required String firstName,
  @required String lastName,
}) {
  return (getFirstLetterCapitalized(source: (firstName ?? "")) +
          " " +
          getFirstLetterCapitalized(source: (lastName ?? "")))
      .trim();
}

// Returns first letter capitalized of the string
String getFirstLetterCapitalized({@required String source}) {
  if (source == null && (source?.isNotEmpty ?? true)) {
    return "";
  } else {
    print("source: $source");
    String result = source.toUpperCase().substring(0, 1);
    if (source.length > 1) {
      result = result + source.toLowerCase().substring(1, source.length);
    }
    return result;
  }
}

Widget getCachedNetworkImage(
    {@required String url,
    BoxFit fit,
    double width = 500,
    double height = 300}) {
  return ProgressiveImage(
    placeholder: AssetImage(AssetStrings.logoImage),
    thumbnail: NetworkImage(url),
    // size: 1.29MB
    image: NetworkImage(url),
    height: height,
    width: width,
    fit: BoxFit.contain,
  );
}

Widget getFullScreenLoader({
  @required Stream<bool> stream,
  @required BuildContext context,
  Color bgColor,
  Color color,
  double strokeWidth,
}) {
  return new StreamBuilder<bool>(
    stream: stream,
    initialData: false,
    builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
      bool status = snapshot.data;
      return status
          ? getAppThemedLoader(
              context: context,
            )
          : new Container();
    },
  );
}

Widget getHalfScreenLoader({
  @required Stream<bool> stream,
  @required BuildContext context,
  Color bgColor,
  Color color,
  double strokeWidth,
}) {
  return new StreamBuilder<bool>(
    stream: stream,
    initialData: false,
    builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
      bool status = snapshot.data;
      return status
          ? getHalfAppThemedLoader(
              context: context,
            )
          : new Container();
    },
  );
}

Widget getHalfAppThemedLoader({
  @required BuildContext context,
  Color bgColor,
  Color color,
  double strokeWidth,
}) {
  return new Container(
    height: 50,
    width: getScreenSize(context: context).width,
    child: getChildLoader(
      color: color ?? AppColors.kPrimaryBlue,
      strokeWidth: strokeWidth,
    ),
  );
}

// Returns app themed loader
Widget getAppThemedLoader({
  @required BuildContext context,
  Color bgColor,
  Color color,
  double strokeWidth,
}) {
  return new Container(
    color: bgColor ?? const Color.fromRGBO(1, 1, 1, 0.6),
    height: getScreenSize(context: context).height,
    width: getScreenSize(context: context).width,
    child: getChildLoader(
      color: color ?? AppColors.kPrimaryBlue,
      strokeWidth: strokeWidth,
    ),
  );
}

// Returns app themed list view loader
Widget getChildLoader({
  Color color,
  double strokeWidth,
}) {
  return new Center(
    child: new CircularProgressIndicator(
      backgroundColor: Colors.transparent,
      valueColor: new AlwaysStoppedAnimation<Color>(
        color ?? Colors.white,
      ),
      strokeWidth: strokeWidth ?? 6.0,
    ),
  );
}

// Checks Internet connection
Future<bool> hasInternetConnection({
  @required BuildContext context,
  bool mounted,
  @required Function onSuccess,
  @required Function onFail,
  bool canShowAlert = true,
}) async {
  try {
    final result = await InternetAddress.lookup('www.google.com')
        .timeout(const Duration(seconds: 5));
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      onSuccess();
      return true;
    } else {
      if (canShowAlert) {
        onFail();
        showAlert(
          context: context,
          titleText: "ERROR",
          message: Messages.noInternetError,
          actionCallbacks: {},
        );
      }
    }
  } catch (_) {
    onFail();
    showAlert(
      context: context,
      titleText: "ERROR",
      message: Messages.noInternetError,
      actionCallbacks: {},
    );
  }
  return false;
}

// Show alert dialog
void showAlert(
    {@required BuildContext context,
    String titleText,
    Widget title,
    String message,
    Widget content,
    Map<String, VoidCallback> actionCallbacks}) {
  Widget titleWidget = titleText == null
      ? title
      : new Text(
          titleText.toUpperCase(),
          textAlign: TextAlign.center,
          style: new TextStyle(
            color: dialogContentColor,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        );
  Widget contentWidget = message == null
      ? content != null ? content : new Container()
      : new Text(
          message,
          textAlign: TextAlign.center,
          style: new TextStyle(
            color: dialogContentColor,
            fontWeight: FontWeight.w400,
//            fontFamily: Constants.contentFontFamily,
          ),
        );

  OverlayEntry alertDialog;
  // Returns alert actions
  List<Widget> _getAlertActions(Map<String, VoidCallback> actionCallbacks) {
    List<Widget> actions = [];
    actionCallbacks.forEach((String title, VoidCallback action) {
      actions.add(
        new ButtonTheme(
          minWidth: 0.0,
          child: new CupertinoDialogAction(
            child: new Text(title,
                style: new TextStyle(
                  color: dialogContentColor,
                  fontSize: 16.0,
//                        fontFamily: Constants.contentFontFamily,
                )),
            onPressed: () {
              action();
              alertDialog?.remove();
              alertAlreadyActive = false;
            },
          ),
//          child: defaultTargetPlatform != TargetPlatform.iOS
//              ? new FlatButton(
//                  child: new Text(
//                    title,
//                    style: new TextStyle(
//                      color: IfincaColors.kPrimaryBlue,
////                      fontFamily: Constants.contentFontFamily,
//                    ),
//                    maxLines: 2,
//                  ),
//                  onPressed: () {
//                    action();
//                  },
//                )
//              :
// new CupertinoDialogAction(
//                  child: new Text(title,
//                      style: new TextStyle(
//                        color: IfincaColors.kPrimaryBlue,
//                        fontSize: 16.0,
////                        fontFamily: Constants.contentFontFamily,
//                      )),
//                  onPressed: () {
//                    action();
//                  },
//                ),
        ),
      );
    });
    return actions;
  }

  List<Widget> actions =
      actionCallbacks != null ? _getAlertActions(actionCallbacks) : [];

  OverlayState overlayState;
  overlayState = Overlay.of(context);

  alertDialog = new OverlayEntry(builder: (BuildContext context) {
    return new Positioned.fill(
      child: new Container(
        color: Colors.black.withOpacity(0.7),
        alignment: Alignment.center,
        child: new WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: new Dialog(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),
            ),
            child: new Material(
              borderRadius: new BorderRadius.circular(10.0),
              color: AppColors.kWhite,
              child: new Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                            ),
                            child: titleWidget,
                          ),
                          contentWidget,
                        ],
                      ),
                    ),
                    new Container(
                      height: 0.6,
                      margin: new EdgeInsets.only(
                        top: 24.0,
                      ),
                      color: dialogContentColor,
                    ),
                    new Row(
                      children: <Widget>[]..addAll(
                          new List.generate(
                            actions.length +
                                (actions.length > 1 ? (actions.length - 1) : 0),
                            (int index) {
                              return index.isOdd
                                  ? new Container(
                                      width: 0.6,
                                      height: 30.0,
                                      color: dialogContentColor,
                                    )
                                  : new Expanded(
                                      child: actions[index ~/ 2],
                                    );
                            },
                          ),
                        ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  });

  if (!alertAlreadyActive) {
    alertAlreadyActive = true;
    overlayState.insert(alertDialog);
  }
}

// Closes keyboard by clicking any where on screen
void closeKeyboard({
  @required BuildContext context,
  @required VoidCallback onClose,
}) {
  if (isKeyboardOpen(context: context)) {
    FocusScope.of(context).requestFocus(new FocusNode());
    try {
      onClose();
    } catch (e) {}
  }
}

void launchUrl(String url) async {
  print("launch url $url");
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Could not launch $url');
  }
}

String readTimestamp(String timestamp) {
  var now = new DateTime.now();
  var format = new DateFormat('hh:mm a');
  var date =
      new DateTime.fromMicrosecondsSinceEpoch(int.parse(timestamp) * 1000);
  var diff = date.difference(now);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + 'DAY AGO';
    } else {
      time = diff.inDays.toString() + 'DAYS AGO';
    }
  }

  return time;
}

// Sets focus node
void setFocusNode({
  @required BuildContext context,
  @required FocusNode focusNode,
}) {
  FocusScope.of(context).requestFocus(focusNode);
}

// Returns formatted date string
String getFormattedDateString({
  String format,
  @required DateTime dateTime,
  bool localize = true,
}) {
  return dateTime != null
      ? new DateFormat(format ?? "MMMM dd, y").format(dateTime)
      : "-";
}

String formatAmount(String amount) {
  try {
    var price = double.parse(amount);
    return price.toStringAsFixed(2).toString();
  } catch (e) {
    return "";
  }
}


String getFormattedCurrency(double amount) {
  FlutterMoneyFormatter fmf = new FlutterMoneyFormatter(
      amount: amount,
      settings: MoneyFormatterSettings(
        symbol: '₹',
        thousandSeparator: ',',
        decimalSeparator: '.',
        symbolAndNumberSeparator: ' ',
      ));

  return fmf.output.symbolOnLeft;
}
