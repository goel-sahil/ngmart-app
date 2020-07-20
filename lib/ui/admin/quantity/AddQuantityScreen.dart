import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/CustomTextStyle.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/model/admin/brand/AddBrandRequest.dart';
import 'package:ngmartflutter/model/admin/brand/AddBrandResponse.dart';
import 'package:ngmartflutter/notifier_provide_model/admin_provider.dart';
import 'package:provider/provider.dart';

class AddQuantityScreen extends StatefulWidget {
  var title;
  var fromBrandScreen;
  var brandId;

  AddQuantityScreen({this.title, this.fromBrandScreen, this.brandId});

  @override
  _AddQuantityScreenState createState() => _AddQuantityScreenState();
}

class _AddQuantityScreenState extends State<AddQuantityScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKeys = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();
  TextEditingController _titleController = new TextEditingController();
  FocusNode _titleField = new FocusNode();
  AdminProvider provider;

  Future<void> _hitApi() async {
    provider.setLoading();
    var request = AddBrandRequest(title: _titleController.text);

    var response = await provider.addQuantity(context, request);
    if (response is APIError) {
      showInSnackBar(response.error);
    } else {
      AddBrandResponse forgotPasswordResponse = response;
      showInSnackBar(forgotPasswordResponse.message);
      Timer(Duration(milliseconds: 500), () {
        Navigator.pop(context, true);
      });
    }
  }

  Future<void> _hitUpdateBrandApi() async {
    provider.setLoading();
    var request = AddBrandRequest(title: _titleController.text);

    var response = await provider.updateQuantity(context, request, widget.brandId);
    if (response is APIError) {
      showInSnackBar(response.error);
    } else {
      AddBrandResponse forgotPasswordResponse = response;
      showInSnackBar(forgotPasswordResponse.message);
      Timer(Duration(milliseconds: 500), () {
        Navigator.pop(context, true);
      });
    }
  }

  @override
  void initState() {
    if (widget.fromBrandScreen) {
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
              title:
                  Text(widget.fromBrandScreen ? "Update Quantity" : "Add Quantity"),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _fieldKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      getSpacer(height: 80),
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
                      Container(
                        width: getScreenSize(context: context).width,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: RaisedButton(
                          onPressed: () {
                            if (_fieldKey.currentState.validate()) {
                              if (widget.fromBrandScreen) {
                                _hitUpdateBrandApi();
                              } else {
                                _hitApi();
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
                              borderRadius: BorderRadius.all(Radius.circular(4))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          new Center(
            child: getHalfScreenProviderLoader(
              status: provider.getLoading(),
              context: context,
            ),
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
}
