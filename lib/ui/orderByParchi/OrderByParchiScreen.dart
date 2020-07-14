import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ngmartflutter/Network/APIs.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/Const.dart';
import 'package:ngmartflutter/helper/CustomTextStyle.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:http/http.dart' as http;
import 'package:ngmartflutter/helper/memory_management.dart';
import 'package:ngmartflutter/helper/styles.dart';
import 'package:ngmartflutter/model/Login/LoginResponse.dart';
import 'package:ngmartflutter/ui/drawer/navigation_drawer.dart';
import 'package:ngmartflutter/ui/login/login_screen.dart';
import 'package:ngmartflutter/ui/search/SearchPage.dart';

class OrderByParchiScreen extends StatefulWidget {
  bool fromNavigation;

  OrderByParchiScreen({this.fromNavigation});

  @override
  _OrderByParchiScreenState createState() => _OrderByParchiScreenState();
}

class _OrderByParchiScreenState extends State<OrderByParchiScreen> {
  final picker = ImagePicker();
  File _image;
  LoginResponse userInfo;
  final StreamController<bool> _loaderStreamController =
      new StreamController<bool>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    MemoryManagement.init();
    if (MemoryManagement.getLoggedInStatus() != null &&
        MemoryManagement.getLoggedInStatus() == true) {
      var info = MemoryManagement.getUserInfo();
      userInfo = LoginResponse.fromJson(jsonDecode(info));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
            key: _scaffoldKey,
            appBar: !widget.fromNavigation
                ? AppBar(
                    title: Text("Order By Parchi"),
                    centerTitle: true,
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => SearchPage()));
                            }),
                      )
                    ],
                  )
                : null,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    getSpacer(height: 60),
                    Image.asset(
                      "images/ui.png",
                      height: 100,
                      width: 120,
                      color: AppColors.kPrimaryBlue,
                    ),
                    Center(
                        child: Text(
                      "You need to upload your",
                      style: h5,
                    )),
                    Center(
                        child: Text(
                      "Parchi here.",
                      style: h4,
                    )),
                    getSpacer(height: 40),
                    new OutlineButton(
                        child: new Text("Upload Image"),
                        onPressed: () {
                          if (userInfo != null) {
                            _openActionSheet();
                          } else {
                            showDialog(
                                context: context,
                                // return object of type AlertDialog
                                child: new CupertinoAlertDialog(
                                  title: new Text(
                                    "Error",
                                    style: h4,
                                  ),
                                  content: new Text(
                                      "Please login first to place order."),
                                  actions: <Widget>[
                                    new FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      Login()));
                                        },
                                        child: new Text("OK"))
                                  ],
                                ));
                          }
                        },
                        borderSide: BorderSide(
                          color: AppColors.kPrimaryBlue, //Color of the border
                        ),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0))),
                    getSpacer(height: 30),
                    Image.file(
                      _image ?? File(""),
                    ),
                    getSpacer(height: 30),
                  ],
                ),
              ),
            ),
          ),
          new Center(
            child: _getLoader,
          ),
        ],
      ),
    );
  }

  Future<void> _openActionSheet() async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  CAMERA,
                  style: CustomTextStyle.robotoMediumStyle5,
                ),
                onPressed: () {
                  _getCameraImage();
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  GALLARY,
                  style: CustomTextStyle.robotoMediumStyle5,
                ),
                onPressed: () {
                  _getGalleryImage();
                  Navigator.pop(context);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(CANCEL, style: CustomTextStyle.amountStyle),
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
            ));
      },
    );
  }

  Future _getGalleryImage() async {
    var imageFileSelect = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: maxWidth, maxHeight: maxHeight);
    _image = imageFileSelect;
    setState(() {});
    if (_image != null) _hitAPi();
  }

  Future _getCameraImage() async {
    var imageFileSelect = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: maxWidth, maxHeight: maxHeight);
    _image = imageFileSelect;
    setState(() {});
    if (_image != null) _hitAPi();
  }

  Future<http.StreamedResponse> _hitAPi() async {
    _loaderStreamController.add(true); //show loader
    var url = Uri.parse(APIs.orderByParchi);

    print("$url");

    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };

    http.MultipartRequest request =
        new http.MultipartRequest("POST", url); //changed

    request.headers.addAll(headers);

    if (_image != null) {
      final fileName = _image.path;

      var bytes = await _image.readAsBytes();

      request.fields['address_id'] =
          userInfo.data.user.userAddresses.first.id.toString();

      request.files.add(new http.MultipartFile.fromBytes(
        "image",
        bytes,
        filename: fileName,
      ));
    }

    http.StreamedResponse response = await request.send();
    _loaderStreamController.add(false); //show loader
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      Map data = jsonDecode(respStr); // Parse data from JSON string
      showThankYouBottomSheet(context);
    } else {
      final respStr = await response.stream.bytesToString();
      Map data = jsonDecode(respStr); // Parse data from JSON string
      showAlert(
        context: context,
        titleText: "Error",
        message: data["message"],
        actionCallbacks: {
          "OK": () {
            if (response.statusCode == 401) {
              onLogoutSuccess(
                context: context,
              );
            }
          }
        },
      );
    }
    return response;
  }

  get _getLoader {
    return getHalfScreenLoader(
      stream: _loaderStreamController.stream,
      context: context,
    );
  }

  showThankYouBottomSheet(BuildContext context) {
    return _scaffoldKey.currentState.showBottomSheet((context) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200, width: 2),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image(
                    image: AssetImage("images/ic_thank_you.png"),
                    width: 300,
                  ),
                ),
              ),
              flex: 5,
            ),
            //Your order has been placed. We we reach out to you shortly with your order.
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: <Widget>[
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                            text:
                                "\n\nThank you for your purchase. Our company values each and every customer."
                                " We strive to provide state-of-the-art devices that respond to our clients’ individual needs. "
                                "If you have any questions or feedback, please don’t hesitate to reach out.",
                            style: CustomTextStyle.textFormFieldMedium.copyWith(
                                fontSize: 14, color: Colors.grey.shade800),
                          )
                        ])),
                    SizedBox(
                      height: 24,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          new CupertinoPageRoute(
                              builder: (BuildContext context) {
                            return new NavigationDrawer();
                          }),
                          (route) => false,
                        );
                      },
                      padding: EdgeInsets.only(left: 48, right: 48),
                      child: Text(
                        "Close",
                        style: CustomTextStyle.textFormFieldMedium
                            .copyWith(color: Colors.white),
                      ),
                      color: AppColors.kPrimaryBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                    )
                  ],
                ),
              ),
              flex: 5,
            )
          ],
        ),
      );
    },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        backgroundColor: Colors.white,
        elevation: 2);
  }
}
