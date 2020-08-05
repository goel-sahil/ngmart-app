import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/CustomTextStyle.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/model/admin/cms/CmsRequest.dart';
import 'package:ngmartflutter/model/admin/cms/CmsResponse.dart';
import 'package:ngmartflutter/notifier_provide_model/admin_provider.dart';
import 'package:provider/provider.dart';
import 'package:html_editor/html_editor.dart';

class UpdateCmsScreen extends StatefulWidget {
  CmsData cmsResponse;
  var desc;

  UpdateCmsScreen({this.cmsResponse});

  @override
  _UpdateCmsScreenState createState() => _UpdateCmsScreenState();
}

class _UpdateCmsScreenState extends State<UpdateCmsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKeys = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _descController = new TextEditingController();
  FocusNode _titleField = new FocusNode();
  FocusNode _descField = new FocusNode();
  AdminProvider provider;
  GlobalKey<HtmlEditorState> keyEditor = GlobalKey();
  String result = "";
  int status = 1;

  Future<void> _hitUpdateCmsApi({int id}) async {
    provider.setLoading();
    final txt = await keyEditor.currentState.getText();
    setState(() {
      result = txt;
    });
    var request = CmsRequest(title: _titleController.text, description: result);

    var response = await provider.updateCms(context, request, id);
    if (response is APIError) {
      showInSnackBar(response.error);
    } else {
      //AddBrandResponse forgotPasswordResponse = response;
      //showInSnackBar(forgotPasswordResponse.message);
      Timer(Duration(milliseconds: 500), () {
        Navigator.pop(context, true);
      });
    }
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() {
    _titleController.text = widget.cmsResponse.title;
    _descController.text = widget.cmsResponse.description;
    result = widget.cmsResponse.description;
    setState(() {});
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
              title: Text("Update "),
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
                        focusNodeNext: _descField,
                        focusNodeCurrent: _titleField,
                        enablefield: true,
                        controller: _titleController,
                        validators: (val) => emptyValidator(
                            value: val, txtMsg: "Please enter brand title."),
                      ),
                      getSpacer(height: 20),
                      HtmlEditor(
                        value: result,
                        key: keyEditor,
                        height: 400,
                      ),
//                      getTextField(
//                        context: context,
//                        labelText: "Description",
//                        obsectextType: false,
//                        textType: TextInputType.text,
//                        focusNodeNext: _descField,
//                        focusNodeCurrent: _descField,
//                        enablefield: true,
//                        maxLines: 4,
//                        controller: _descController,
//                        validators: (val) => emptyValidator(
//                            value: val, txtMsg: "Please enter description."),
//                      ),

//                      getSpacer(height: 20),
//                      Padding(
//                        padding: EdgeInsets.symmetric(horizontal: 10),
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Text(
//                              "Status",
//                              style: TextStyle(
//                                  color: Colors.black,
//                                  fontWeight: FontWeight.bold),
//                            ),
//                            ToggleWidget(
//                              activeBgColor: Colors.green,
//                              activeTextColor: Colors.white,
//                              inactiveBgColor: Colors.white,
//                              inactiveTextColor: Colors.black,
//                              labels: [
//                                'INACTIVE',
//                                'ACTIVE',
//                              ],
//                              initialLabel: status,
//                              onToggle: (index) {
//                                print("Index $index");
//                                status = index;
//                              },
//                            ),
//                          ],
//                        ),
//                      ),
                      getSpacer(height: 20),
                      Container(
                        width: getScreenSize(context: context).width,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: RaisedButton(
                          onPressed: () {
                            if (_fieldKey.currentState.validate()) {
                              _hitUpdateCmsApi(id: widget.cmsResponse.id);
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
