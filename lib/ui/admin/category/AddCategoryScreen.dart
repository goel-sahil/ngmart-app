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
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/helper/memory_management.dart';
import 'package:ngmartflutter/model/admin/brand/AddBrandRequest.dart';
import 'package:ngmartflutter/model/admin/brand/AddBrandResponse.dart';
import 'package:ngmartflutter/notifier_provide_model/admin_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AddCategoryScreen extends StatefulWidget {
  var title;
  var fromCategoryScreen;
  var brandId;

  AddCategoryScreen({this.title, this.fromCategoryScreen, this.brandId});

  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKeys = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();
  TextEditingController _titleController = new TextEditingController();
  FocusNode _titleField = new FocusNode();
  AdminProvider provider;
  String _myActivity;
  final StreamController<bool> _loaderStreamController =
      new StreamController<bool>();
  final picker = ImagePicker();
  File _image;

  Future<void> _hitUpdateBrandApi() async {
    provider.setLoading();
    var request = AddBrandRequest(title: _titleController.text);

    var response = await provider.updateBrand(context, request, widget.brandId);
    if (response is APIError) {
      showInSnackBar(response.error);
    } else {
      AddBrandResponse forgotPasswordResponse = response;
      showInSnackBar(forgotPasswordResponse.message);
      Navigator.pop(context, true);
    }
  }

  @override
  void initState() {
    if (widget.fromCategoryScreen) {
      _titleController.text = widget.title;
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
              title: Text(widget.fromCategoryScreen
                  ? "Update Category"
                  : "Add Category"),
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
                      InkWell(
                        onTap: () {
                          _openActionSheet();
                        },
                        child: CircleAvatar(
                            backgroundColor: Colors.blue.shade50,
                            radius: 60.0,
                            backgroundImage: FileImage(
                              _image ?? File(""),
                            )),
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
                            value: val, txtMsg: "Please enter brand title."),
                      ),
                      getSpacer(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: DropDownFormField(
                          titleText: "Category id",
                          hintText: 'Please choose Category id.',
                          required: true,
                          filled: false,
                          errorText: "Please choose Category id. ",
                          value: _myActivity,
                          onSaved: (value) {
                            setState(() {
                              _myActivity = value;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _myActivity = value;
                            });
                          },
                          dataSource: [
                            {
                              "display": "Running",
                              "value": "Running",
                            },
                            {
                              "display": "Climbing",
                              "value": "Climbing",
                            },
                            {
                              "display": "Walking",
                              "value": "Walking",
                            },
                            {
                              "display": "Swimming",
                              "value": "Swimming",
                            },
                            {
                              "display": "Soccer Practice",
                              "value": "Soccer Practice",
                            },
                            {
                              "display": "Baseball Practice",
                              "value": "Baseball Practice",
                            },
                            {
                              "display": "Football Practice",
                              "value": "Football Practice",
                            },
                          ],
                          textField: 'display',
                          valueField: 'value',
                        ),
                      ),
                      getSpacer(height: 20),
                      Container(
                        width: getScreenSize(context: context).width,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: RaisedButton(
                          onPressed: () {
                            if (_fieldKey.currentState.validate()) {
                              if (widget.fromCategoryScreen) {
                                _hitUpdateBrandApi();
                              } else {
                                if (_image != null) {
                                  addCategory();
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

  Future<http.StreamedResponse> addCategory() async {
    _loaderStreamController.add(true); //show loader
    var url = Uri.parse(APIs.category);

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

      request.fields['title'] = "title";
      request.fields['category_id'] = "id";

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
    } else {
      final respStr = await response.stream.bytesToString();
      Map data = jsonDecode(respStr);
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
