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

  @override
  void initState() {
    MemoryManagement.init();
    var info = MemoryManagement.getUserInfo();
    userInfo = LoginResponse.fromJson(jsonDecode(info));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: !widget.fromNavigation
                ? AppBar(
                    title: Text("Order By Parchi"),
                    centerTitle: true,
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
                    Center(child: Text("You need to upload your", style: h5,)),
                    Center(child: Text("Parchi here.", style: h4,)),
                    getSpacer(height: 40),
                    new OutlineButton(
                        child: new Text("Upload Image"),
                        onPressed: () {
                          _openActionSheet();
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

      showAlert(
        context: context,
        titleText: "SUCCESS",
        message: data["message"],
        actionCallbacks: {"OK": () {}},
      );
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
}
