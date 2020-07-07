import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/CustomTextStyle.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/model/Login/LoginRequest.dart';
import 'package:ngmartflutter/model/forgotPassword/ForgotPassword.dart';
import 'package:ngmartflutter/notifier_provide_model/login_provider.dart';
import 'package:ngmartflutter/ui/otp/otp_verification.dart';
import 'package:provider/provider.dart';

class ChangePhoneScreen extends StatefulWidget {
  @override
  _ChangePhoneScreenState createState() => _ChangePhoneScreenState();
}

class _ChangePhoneScreenState extends State<ChangePhoneScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKeys = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();
  TextEditingController _mobileNumberController = new TextEditingController();
  FocusNode _mobileNumberField = new FocusNode();
  LoginProvider provider;

  Future<void> _hitApi() async {
    provider.setLoading();
    var mobileNumber = _mobileNumberController.text;
    var request = LoginRequest(phoneNumber: mobileNumber);

    var response = await provider.changePhoneNumber(request, context);
    if (response is APIError) {
      showInSnackBar(response.error);
    } else {
      ForgotPasswordResponse forgotPasswordResponse = response;
      showInSnackBar(forgotPasswordResponse.message);
      Navigator.of(context).push(new CupertinoPageRoute(
          builder: (context) => Otpverification(
                phone: _mobileNumberController.text,
                id: forgotPasswordResponse.data.userId,
                otpType: OTPType.CHANGE_PHONE,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LoginProvider>(context);
    return Scaffold(
      key: _scaffoldKeys,
      appBar: AppBar(
        title: Text("Change Mobile Number"),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
              key: _fieldKey,
              child: Column(
                children: <Widget>[
                  getSpacer(height: 80),
                  getTextField(
                    context: context,
                    labelText: "Mobile Number",
                    obsectextType: false,
                    textType: TextInputType.number,
                    focusNodeNext: _mobileNumberField,
                    focusNodeCurrent: _mobileNumberField,
                    enablefield: true,
                    controller: _mobileNumberController,
                    validators: (val) => emptyValidator(
                        value: val, txtMsg: "Please enter mobile number."),
                  ),
                  getSpacer(height: 20),
                  Container(
                    width: getScreenSize(context: context).width,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: RaisedButton(
                      onPressed: () {
                        if (_fieldKey.currentState.validate()) {
                          _hitApi();
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
