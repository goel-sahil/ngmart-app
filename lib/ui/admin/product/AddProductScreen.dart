import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ngmartflutter/Network/APIs.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/Const.dart';
import 'package:ngmartflutter/helper/CustomTextStyle.dart';
import 'package:ngmartflutter/helper/Messages.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/helper/memory_management.dart';
import 'package:ngmartflutter/model/CategoryModel.dart';
import 'package:ngmartflutter/model/admin/brand/AddBrandRequest.dart';
import 'package:ngmartflutter/model/admin/brand/AddBrandResponse.dart';
import 'package:ngmartflutter/model/admin/category/AdminCategoryResponse.dart';
import 'package:ngmartflutter/model/admin/category/CategoryListResponse.dart';
import 'package:ngmartflutter/notifier_provide_model/admin_provider.dart';
import 'package:ngmartflutter/ui/admin/category/SelectCategorySecreen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_dropdown/searchable_dropdown.dart';

class AddProductScreen extends StatefulWidget {
  var fromProductScreen;
  DataCategory dataCategory;

  AddProductScreen({this.fromProductScreen, this.dataCategory});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKeys = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _categoryController = new TextEditingController();
  TextEditingController _brandController = new TextEditingController();
  TextEditingController _quantityIdController = new TextEditingController();
  TextEditingController _priceController = new TextEditingController();
  TextEditingController _quantityIncController = new TextEditingController();
  FocusNode _titleField = new FocusNode();
  FocusNode _categoryField = new FocusNode();
  FocusNode _brandField = new FocusNode();
  FocusNode _quantityIdField = new FocusNode();
  FocusNode _priceField = new FocusNode();
  FocusNode _quantityIncField = new FocusNode();
  AdminProvider provider;
  String catId = "";
  final StreamController<bool> _loaderStreamController =
      new StreamController<bool>();
  final picker = ImagePicker();
  File _image;

  @override
  void initState() {
    if (widget.fromProductScreen) {
      _titleController.text = widget.dataCategory.title;
      if (widget.dataCategory.category != null) {
        _categoryController.text = widget.dataCategory.category.title;
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
                  widget.fromProductScreen ? "Update Product" : "Add Product"),
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
                                              widget.dataCategory.imageUrl)
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
                          CategoryModel catModel = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      SelectCategoryScreen()));
                          if (catModel != null) {
                            _categoryController.text = catModel.title;
                            catId = catModel.id;
                          }
                        },
                        child: getTextFieldWithoutValidation(
                          context: context,
                          labelText: "Category Id",
                          obsectextType: false,
                          textType: TextInputType.text,
                          focusNodeNext: _categoryField,
                          focusNodeCurrent: _categoryField,
                          enablefield: false,
                          controller: _categoryController,
                        ),
                      ),
                      getSpacer(height: 20),
                      InkWell(
                        onTap: () async {
                          CategoryModel catModel = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      SelectCategoryScreen()));
                          if (catModel != null) {
                            _brandController.text = catModel.title;
                            catId = catModel.id;
                          }
                        },
                        child: getTextFieldWithoutValidation(
                          context: context,
                          labelText: "Brand Id",
                          obsectextType: false,
                          textType: TextInputType.text,
                          focusNodeNext: _brandField,
                          focusNodeCurrent: _quantityIdField,
                          enablefield: false,
                          controller: _brandController,
                        ),
                      ),
                      getSpacer(height: 20),
                      InkWell(
                        onTap: () async {
                          CategoryModel catModel = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      SelectCategoryScreen()));
                          if (catModel != null) {
                            _categoryController.text = catModel.title;
                            catId = catModel.id;
                          }
                        },
                        child: getTextFieldWithoutValidation(
                  context: context,
                  labelText: "Quantity Id",
                  obsectextType: false,
                  textType: TextInputType.text,
                  focusNodeNext: _quantityIdField,
                  focusNodeCurrent: _quantityIdField,
                  enablefield: false,
                  controller: _quantityIdController,
                ),
                ),
                getSpacer(height: 20),
                      getTextField(
                        context: context,
                        labelText: "Price",
                        obsectextType: false,
                        textType: TextInputType.number,
                        focusNodeNext: _quantityIncField,
                        focusNodeCurrent: _priceField,
                        enablefield: true,
                        controller: _priceController,
                        validators: (val) => emptyValidator(
                            value: val, txtMsg: "Please enter product price."),
                      ),
                      getSpacer(height: 20),
                      getSpacer(height: 20),
                      getTextField(
                        context: context,
                        labelText: "Quantity Increment",
                        obsectextType: false,
                        textType: TextInputType.number,
                        focusNodeNext: _quantityIncField,
                        focusNodeCurrent: _quantityIncField,
                        enablefield: true,
                        controller: _quantityIncController,
                        validators: (val) => emptyValidator(
                            value: val, txtMsg: "Please enter quantity increment."),
                      ),
                      getSpacer(height: 20),
                      Container(
                        width: getScreenSize(context: context).width,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: RaisedButton(
                          onPressed: () {
                            if (_fieldKey.currentState.validate()) {
                              if (widget.fromProductScreen) {
                                addCategory(true);
                              } else {
                                if (_image != null) {
                                  addCategory(false);
                                } else {
                                  showInSnackBar("Please add category image.");
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

  Future<http.StreamedResponse> addCategory(bool forUpdate) async {
    _loaderStreamController.add(true); //show loader
    var url;
    if (forUpdate) {
      url = Uri.parse("${APIs.category}/${widget.dataCategory.id}");
    } else {
      url = Uri.parse(APIs.category);
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

    if (_image != null) {
      final fileName = _image.path;

      var bytes = await _image.readAsBytes();

      request.fields['title'] = _titleController.text;
      request.fields['category_id'] = catId;
      request.fields['status'] = "1";

      request.files.add(new http.MultipartFile.fromBytes(
        "image",
        bytes,
        filename: fileName,
      ));
    } else {
      request.fields['title'] = _titleController.text;
      request.fields['category_id'] = catId;
      request.fields['status'] = "1";
    }

    print("${request.fields.toString()}");

    http.StreamedResponse response = await request.send();
    _loaderStreamController.add(false); //show loader
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      Map data = jsonDecode(respStr);
      print("Data==> $data");
      showInSnackBar("${data["message"]}");
      Navigator.pop(context, true);
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
