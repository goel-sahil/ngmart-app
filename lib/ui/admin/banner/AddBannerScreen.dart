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
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/helper/memory_management.dart';
import 'package:ngmartflutter/model/admin/banner/BannerResponse.dart';
import 'package:ngmartflutter/model/admin/product/AdminProductResponse.dart';
import 'package:ngmartflutter/notifier_provide_model/admin_provider.dart';
import 'package:ngmartflutter/ui/ToggleWidget.dart';
import 'package:ngmartflutter/ui/admin/banner/SelectProductScreen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AddBannerScreen extends StatefulWidget {
  var fromProductScreen;
  BannerData adminProductItem;

  AddBannerScreen({this.fromProductScreen, this.adminProductItem});

  @override
  _AddBannerScreenState createState() => _AddBannerScreenState();
}

class _AddBannerScreenState extends State<AddBannerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKeys = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _productController = new TextEditingController();
  TextEditingController _descController = new TextEditingController();
  FocusNode _titleField = new FocusNode();
  FocusNode _descField = new FocusNode();
  FocusNode _productField = new FocusNode();
  AdminProvider provider;
  String status = "1";
  final StreamController<bool> _loaderStreamController =
      new StreamController<bool>();
  final picker = ImagePicker();
  File _image;
  List<Products> selectedProductList = new List();

  @override
  void initState() {
    if (widget.fromProductScreen) {
      _titleController.text = widget.adminProductItem.title;
      _descController.text = widget.adminProductItem.description;
      if (widget?.adminProductItem?.products?.isNotEmpty == true) {
        var productString = List();
        for (int i = 0; i < widget.adminProductItem.products.length; i++) {
          productString.add(widget.adminProductItem.products[i].title);
        }
        _productController.text = productString.join(", ");
        selectedProductList.addAll(widget?.adminProductItem?.products);
      }
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AdminProvider>(context);
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
            key: _scaffoldKeys,
            appBar: AppBar(
              title: Text(
                  widget.fromProductScreen ? "Update Banner" : "Add Banner"),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _fieldKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      getSpacer(height: 40),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child:
                            new Stack(fit: StackFit.loose, children: <Widget>[
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                  width: 140.0,
                                  height: 140.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue.shade50,
                                    image: new DecorationImage(
                                      image: widget.fromProductScreen
                                          ? NetworkImage(
                                              widget.adminProductItem.imageUrl)
                                          : new FileImage(
                                              _image ?? File(""),
                                            ),
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 90.0, right: 100.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      _openActionSheet();
                                    },
                                    child: new CircleAvatar(
                                      backgroundColor: Colors.green,
                                      radius: 20.0,
                                      child: new Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ]),
                      ),
                      getSpacer(height: 40),
                      getTextField(
                        context: context,
                        labelText: "Title",
                        obsectextType: false,
                        textType: TextInputType.text,
                        focusNodeNext: _titleField,
                        focusNodeCurrent: _titleField,
                        enablefield: true,
                        controller: _titleController,
                        validators: (val) => emptyValidator(
                            value: val, txtMsg: "Please enter product title."),
                      ),
                      getSpacer(height: 20),
                      InkWell(
                        onTap: () async {
                          selectedProductList = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => SelectProductScreen(
                                        selectedProductList:
                                            selectedProductList,
                                      )));
                          if (selectedProductList != null) {
                            print(
                                "Add banner screen==> ${selectedProductList.length}");
                            List<String> mproductName = new List();
                            for (int i = 0;
                                i < selectedProductList.length;
                                i++) {
                              mproductName.add(selectedProductList[i].title);
                            }
                            _productController.text = mproductName.join(',   ');
                          }
                        },
                        child: getTextFieldWithoutValidation(
                          context: context,
                          labelText: "Products",
                          obsectextType: false,
                          textType: TextInputType.text,
                          focusNodeNext: _descField,
                          focusNodeCurrent: _productField,
                          enablefield: false,
                          controller: _productController,
                        ),
                      ),
                      getSpacer(height: 20),
                      getTextField(
                        context: context,
                        labelText: "Description",
                        obsectextType: false,
                        textType: TextInputType.text,
                        focusNodeNext: _descField,
                        focusNodeCurrent: _descField,
                        enablefield: true,
                        maxLines: 4,
                        controller: _descController,
                        validators: (val) => emptyValidator(
                            value: val, txtMsg: "Please enter description."),
                      ),
                      getSpacer(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Status",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            ToggleWidget(
                              activeBgColor: Colors.green,
                              activeTextColor: Colors.white,
                              inactiveBgColor: Colors.white,
                              inactiveTextColor: Colors.black,
                              labels: [
                                'INACTIVE',
                                'ACTIVE',
                              ],
                              initialLabel: 1,
                              onToggle: (index) {
                                print("Index $index");
                                status = index.toString();
                              },
                            ),
                          ],
                        ),
                      ),
                      getSpacer(height: 20),
                      Container(
                        width: getScreenSize(context: context).width,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: RaisedButton(
                          onPressed: () {
                            if (_fieldKey.currentState.validate()) {
                              if (widget.fromProductScreen) {
                                addBanner(true);
                              } else {
                                if (_image != null) {
                                  addBanner(false);
                                } else {
                                  showInSnackBar("Please add banner image.");
                                }
                              }
                            }
                          },
                          child: Text(
                            "SUBMIT",
                            style: CustomTextStyle.textFormFieldRegular
                                .copyWith(color: Colors.white, fontSize: 14),
                          ),
                          color: AppColors.kPrimaryBlue,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                        ),
                      ),
                      getSpacer(height: 50),
                    ],
                  ),
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

  String emptyValidator({String value, String txtMsg}) {
    if (value.isEmpty) {
      return txtMsg;
    }
    return null;
  }

  void showInSnackBar(String value) {
    _scaffoldKeys.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future<http.StreamedResponse> addBanner(bool forUpdate) async {
    _loaderStreamController.add(true); //show loader
    var url;
    if (forUpdate) {
      url = Uri.parse("${APIs.getBanners}/${widget.adminProductItem.id}");
    } else {
      url = Uri.parse(APIs.getBanners);
    }

    print("$url");

    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Accept": "application/json",
      "Authorization": "Bearer ${MemoryManagement.getAccessToken()}"
    };

    http.MultipartRequest request =
        new http.MultipartRequest("POST", url); //changed

    request.headers.addAll(headers);
    List<int> selectedIds = List();
    if (selectedProductList?.isNotEmpty == true) {
      for (int i = 0; i < selectedProductList?.length; i++) {
        selectedIds.add(selectedProductList[i].id);
      }
    }

    if (_image != null) {
      final fileName = _image.path;

      var bytes = await _image.readAsBytes();

      request.fields['title'] = _titleController.text;
      request.fields['description'] = _descController.text;
      request.fields['product_ids'] = '$selectedIds';
      request.fields['status'] = status;
      request.files.add(new http.MultipartFile.fromBytes(
        "image",
        bytes,
        filename: fileName,
      ));
    } else {
      request.fields['title'] = _titleController.text;
      request.fields['description'] = _descController.text;
      request.fields['product_ids'] = '$selectedIds';
      request.fields['status'] = status;
    }

    print("${request.fields.toString()}");

    http.StreamedResponse response = await request.send();
    _loaderStreamController.add(false); //show loader
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      Map data = jsonDecode(respStr);
      print("Data==> $data");
      showInSnackBar("${data["message"]}");
      Timer(Duration(milliseconds: 500), () {
        Navigator.pop(context, true);
      });
    } else {
      final respStr = await response.stream.bytesToString();
      Map data = jsonDecode(respStr);
      print("Response==> $data");
      showInSnackBar("${data["message"]}");
    }
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
  }

  Future _getCameraImage() async {
    var imageFileSelect = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: maxWidth, maxHeight: maxHeight);
    _image = imageFileSelect;
    setState(() {});
  }

  get _getLoader {
    return getHalfScreenLoader(
      stream: _loaderStreamController.stream,
      context: context,
    );
  }
}
