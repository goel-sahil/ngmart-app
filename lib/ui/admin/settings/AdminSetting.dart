import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ngmartflutter/Network/APIs.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/helper/memory_management.dart';
import 'package:ngmartflutter/model/cms/CmsResponse.dart';
import 'package:ngmartflutter/notifier_provide_model/dashboard_provider.dart';
import 'package:ngmartflutter/ui/changePassword/ChangePasswordScreen.dart';
import 'package:ngmartflutter/ui/changePhone/ChangePhone.dart';
import 'package:ngmartflutter/ui/cmsPage/CmsPageScreen.dart';
import 'package:ngmartflutter/ui/profile/ProfileScreen.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminSettingScreen extends StatefulWidget {
  @override
  _AdminSettingScreenState createState() => _AdminSettingScreenState();
}

class _AdminSettingScreenState extends State<AdminSettingScreen> {
  DashboardProvider provider;
  bool isLoggedIn = false;

  @override
  void initState() {
    MemoryManagement.init();
    isLoggedIn = MemoryManagement.getLoggedInStatus() ?? false;
    super.initState();
  }

  Future<void> _hitApi({String url}) async {
    provider.setLoading();
    var response = await provider.cmsData(context, url);
    if (response is APIError) {
      if (response.status == 401) {
        showAlert(
          context: context,
          titleText: "Error",
          message: response.error,
          actionCallbacks: {
            "OK": () {
              onLogoutSuccess(context: context);
            }
          },
        );
      }
    } else if (response is CmsResponse) {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => CmsPageScreen(
                    title: response.data.title,
                    text: response.data.description,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<DashboardProvider>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          new SingleChildScrollView(
            child: Container(
              child: new Column(
                children: <Widget>[
                  getView("Review Us", 1),
                  getView("Rate Our App", 2),
                  getView("Profile", 9),
                  isLoggedIn ? getView("Change Mobile Number", 3) : Container(),
                  isLoggedIn ? getView("Change Password", 8) : Container(),
                  getView("Terms & Conditions", 4),
                  getView("About Us", 5),
                  getView("Privacy Policy", 6),
                  getView("Share App", 7),
                ],
              ),
            ),
          ),
          Center(
            child: getHalfScreenProviderLoader(
              status: /*provider.getLoading()*/ false,
              context: context,
            ),
          )
        ],
      ),
    );
  }

  Widget getView(String title, int pos) {
    return InkWell(
      onTap: () {
        print(pos);
        switch (pos) {
          case 9:
            {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => ProfileScreen(fromAdmin: true,)));
            }
            break;
          case 3:
            {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => ChangePhoneScreen()));
            }
            break;
          case 4:
            {
              _hitApi(url: APIs.termsCondition);
            }
            break;
          case 5:
            {
              _hitApi(url: APIs.aboutUs);
            }
            break;
          case 6:
            {
              _hitApi(url: APIs.privacyPolicy);
            }
            break;
          case 7:
            {
              Share.share('check out my website https://example.com');
            }
            break;
          case 8:
            {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => ChangePasswordScreen()));
            }
            break;
        }
      },
      child: new Container(
        margin: new EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
        child: Column(
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  title,
                  style: new TextStyle(
                      color: AppColors.kAppBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0),
                ),
                new Icon(
                  Icons.arrow_forward_ios,
                  size: 16.0,
                  color: Colors.black45,
                )
              ],
            ),
            new Container(
              height: 1.0,
              color: Colors.black45,
              margin: new EdgeInsets.only(top: 20.0),
            )
          ],
        ),
      ),
    );
  }

  _launchURL({String url}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
