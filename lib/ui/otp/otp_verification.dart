import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ngmartflutter/Network/APIs.dart';
import 'package:ngmartflutter/Network/api_error.dart';
import 'package:ngmartflutter/helper/AppColors.dart';
import 'package:ngmartflutter/helper/CustomTextStyle.dart';
import 'package:ngmartflutter/helper/ReusableWidgets.dart';
import 'package:ngmartflutter/helper/UniversalFunctions.dart';
import 'package:ngmartflutter/model/CommonResponse.dart';
import 'package:ngmartflutter/model/Login/LoginResponse.dart';
import 'package:ngmartflutter/model/otp/otp_request.dart';
import 'package:ngmartflutter/notifier_provide_model/login_provider.dart';
import 'package:ngmartflutter/ui/drawer/navigation_drawer.dart';
import 'package:ngmartflutter/ui/resetPassword/ResetPasswordScreen.dart';
import 'package:ngmartflutter/ui/signUp/SignUpScreen.dart';
import 'package:pin_view/pin_view.dart';
import 'package:provider/provider.dart';
import 'package:quiver/async.dart';

enum OTPType { RESET, REGISTER, CHANGE_PHONE_EMAIL, LOGIN, CHNAGE_EMAIL }

class Otpverification extends StatefulWidget {
  final OTPType otpType;
  final int id;

  final String phone;

  const Otpverification({Key key, @required this.otpType, this.id, this.phone})
      : super(key: key);

  @override
  _OtpverificationState createState() => _OtpverificationState();
}

class _OtpverificationState extends State<Otpverification> {
  int _start = 60;
  int _current = 0;

  double offstage = 1.0;
  CountdownTimer countDownTimer;
  String pinText;
  Color colorResend = Colors.black.withOpacity(0.4);

  bool offstageResend = false;

  String emails = "";
  LoginProvider provider;
  final GlobalKey<ScaffoldState> _scaffoldKeys = new GlobalKey<ScaffoldState>();

  _verifyOtp() {
    switch (widget.otpType) {
      case OTPType.REGISTER:
        // verifySignUpOtp();
        break;
      case OTPType.RESET:
        //  verifyForgotOtp();
        break;
      case OTPType.CHANGE_PHONE_EMAIL:
        // verifyChangePhoneEmailOtp();
        break;
      case OTPType.LOGIN:
        // verifySignUpOtp();
        // verifyChangePhoneEmailOtp();
        break;
      case OTPType.CHNAGE_EMAIL:
        //  changeEmailPhone();
        // verifyChangePhoneEmailOtp();
        break;
    }
  }

  void startTimer() {
    offstage = 1.0;
    countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds;
        colorResend = Colors.black.withOpacity(0.4);
        print(_current);

        if (_current == 1) {
          timer();
        }
      });
    });

    sub.onDone(() {
      print(countDownTimer.toString());
      sub.cancel();
      colorResend = Colors.black;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    countDownTimer.cancel();
    super.dispose();
  }

  void timer() {
    Timer(Duration(seconds: 1), () {
      offstage = 0.0;
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LoginProvider>(context);
    return Stack(
      children: <Widget>[
        Scaffold(
          key: _scaffoldKeys,
          appBar: AppBar(
            title: Text(
              "OTP Verification",
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: new Container(
              alignment: Alignment.center,
              child: new Column(
                children: <Widget>[
                  new SizedBox(
                    height: 50.0,
                  ),
                  new Text(
                    "Verification Code",
                    style: new TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0),
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: RichText(
                        text: TextSpan(
                          text:
                              'Please enter the verification code we just sent to your mobile no - ',
                          style: new TextStyle(
                              color: Colors.blueGrey, fontSize: 16.0),
                          children: <TextSpan>[
                            TextSpan(
                                text: widget.phone ?? "",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0)),
                          ],
                        ),
                      )),
                  new SizedBox(
                    height: 50.0,
                  ),
                  Container(
                    margin: new EdgeInsets.only(left: 30.0, right: 30.0),
                    child: PinView(
                        count: 6,
                        // describes the field number
                        autoFocusFirstField: false,
                        // defaults to true
                        inputDecoration: new InputDecoration(
                            enabledBorder: new UnderlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.grey, width: 1.5))),
                        margin: EdgeInsets.all(10),
                        // margin between the fields// describes whether the text fields should be obscure or not, defaults to false
                        style: TextStyle(
                            // style for the fields
                            fontSize: 19.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                        dashStyle: TextStyle(
                            // dash style
                            fontSize: 25.0,
                            color: Colors.grey),
                        submit: (String pin) {
                          // when all the fields are filled
                          // submit function runs with the pin
                          FocusScope.of(context).requestFocus(new FocusNode());
                          pinText = pin;
                          print(pin);
                        }),
                  ),
                  new SizedBox(
                    height: 40.0,
                  ),
                  _getSubmitButton,
                  new SizedBox(
                    height: 30.0,
                  ),
                  Offstage(
                    offstage: offstageResend,
                    child: Opacity(
                        opacity: offstage,
                        child: Text(
                          "$_current",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        )),
                  ),
                  new SizedBox(
                    height: 20.0,
                  ),
                  Offstage(
                    offstage: offstageResend,
                    child: InkWell(
                        onTap: () {
                          if (offstage == 0.0) {
                            startTimer();
                            if (widget.otpType == OTPType.REGISTER) {
                              _hitResendApi(url: APIs.resendOtp);
                            } else {
                              _hitResendApi(url: APIs.forgotPasswordResendOtp);
                            }
                          }
                        },
                        child: Icon(
                          FontAwesomeIcons.replyAll,
                          size: 30,
                          color: colorResend,
                        )),
                  ),
                  Offstage(
                    offstage: offstageResend,
                    child: InkWell(
                        onTap: () {
                          if (offstage == 0.0) {
                            startTimer();
                            if (widget.otpType == OTPType.REGISTER) {
                              _hitResendApi(url: APIs.resendOtp);
                            } else {
                              _hitResendApi(url: APIs.forgotPasswordResendOtp);
                            }
                          }
                        },
                        child: new Text(
                          "Resend Otp",
                          style: new TextStyle(
                              color: colorResend,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ],
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
    );
  }

  get _getSubmitButton {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: getScreenSize(context: context).width,
        child: RaisedButton(
          onPressed: () async {
            if (widget.otpType == OTPType.REGISTER) {
              _hitApi(url: APIs.otpVerify, otpType: widget.otpType);
            } else {
              _hitApi(
                  url: APIs.forgotPasswordOtpVerify, otpType: widget.otpType);
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
    );
  }

  Future<void> _hitApi({String url, OTPType otpType}) async {
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        provider.hideLoader(); //hide loader
      },
      onSuccess: () {},
    );

    if (gotInternetConnection) {
      provider.setLoading();
      var request = OtpRequest(
        userId: widget.id,
        code: pinText,
      );
      var response =
          await provider.verifyOtp(request, context, url,otpType);
      if (response is APIError) {
        showInSnackBar(response.error);
      } else {
        LoginResponse commonResponse = response;
        showInSnackBar(commonResponse.message);
        if (widget.otpType == OTPType.REGISTER) {
          Navigator.pushAndRemoveUntil(
            context,
            new CupertinoPageRoute(builder: (BuildContext context) {
              return new NavigationDrawer();
            }),
            (route) => false,
          );
        } else {
          Navigator.of(context).push(new CupertinoPageRoute(
              builder: (context) => ResetPasswordScreen(
                    id: widget.id,
                    code: pinText,
                  )));
        }
      }
    }
  }

  Future<void> _hitResendApi({String url}) async {
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        provider.hideLoader(); //hide loader
      },
      onSuccess: () {},
    );

    if (gotInternetConnection) {
      provider.setLoading();
      var request = OtpRequest(userId: widget.id);
      var response = await provider.resendOtp(request, context, url);
      if (response is APIError) {
        showInSnackBar(response.error);
      } else {
        CommonResponse commonResponse = response;
        showInSnackBar(commonResponse.message);
      }
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKeys.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}
