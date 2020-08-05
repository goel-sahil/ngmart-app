import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'AppColors.dart';
import 'AssetStrings.dart';
import 'Const.dart';
import 'CustomBorder.dart';
import 'CustomTextStyle.dart';
import 'UniversalFunctions.dart';
import 'UniversalProperties.dart';

Widget getItemDivider() {
  return Padding(
      padding: const EdgeInsets.only(left: 40, top: 3, bottom: 3),
      child: new Container(
        height: ITEM_DIVIDER,
        color: AppColors.kGrey,
      ));
}

Widget getEmptyRefreshWidget(BuildContext context, String message,
    VoidCallback onPressed, bool isEnabled) {
  var screenSize = MediaQuery.of(context).size;
  return new Container(
    height: screenSize.height,
    width: screenSize.width,
    child: new Center(
        child: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Icon(
          Icons.youtube_searched_for,
          size: 50,
          color: AppColors.kAppBlack,
        ),
        SizedBox(
          height: 8,
        ),
        new Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: AppColors.kAppBlack,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
        new FlatButton(
            onPressed: isEnabled ? onPressed : null,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Icon(
                  Icons.refresh,
                  color: AppColors.kAppBlack,
                ),
                new Text(
                  "Refresh",
                  style:
                      new TextStyle(fontSize: 18.0, color: AppColors.kAppBlack),
                ),
              ],
            ))
      ],
    )),
  );
}

// Returns app bar
Widget getAppbar(String title) {
  return new AppBar(
    backgroundColor: AppColors.kAccentGreenColor,
    centerTitle: true,
    title: new Text(
      title,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

getProfileAndCoverPicWidget(String url, File localImage) {
  if (url != null && url.isNotEmpty && localImage == null) {
//    return CachedNetworkImageProvider(
//        (url.contains(FB_IMAGE_URL_PREFIX))
//            ? "$url?width=$FB_G_PHOTO_SIZE&heigth=$FB_G_PHOTO_SIZE"
//            : (url.contains(
//            G_IMAGE_URL_PREFIX)) ? "$url?sz=$FB_G_PHOTO_SIZE" : url
//
//    );
  } else {
    return (localImage == null)
        ? AssetImage(NO_COVER_IMAGE_FOUND)
        : new FileImage(
            localImage,
          );
  }
}

getChatWidget({@required int count, @required Function onClick}) {
  return Stack(
    children: <Widget>[
      Center(
          child: InkWell(
        onTap: () {
          onClick();
        },
        child: new Icon(Icons.chat, size: 25.0, color: Colors.black87),
      )),
      Align(
        alignment: Alignment.topRight,
        child: getNotificationCount(count),
      )
    ],
  );
}

getNotificationCount(int count) {
  return (count > 0)
      ? ClipOval(
          child: Container(
            color: Colors.red,
            height: 22.0, // height of the button
            width: 22.0, // width of the button
            child: Center(
              child: Text(
                (count < 10) ? "$count" : "9+",
                style: TextStyle(fontSize: 10),
              ),
            ),
          ),
        )
      : Container();
}

Widget getHalfScreenProviderLoader({
  @required bool status,
  @required BuildContext context,
}) {
  return status
      ? getHalfAppThemedLoader(
          context: context,
        )
      : new Container();
}

Widget backButton(BuildContext context) {
  return InkWell(
    onTap: () => Navigator.pop(context),
    child: Container(
        margin: new EdgeInsets.only(top: 30.0, left: 5.0),
        padding: new EdgeInsets.all(8.0),
        child: Icon(
          Icons.arrow_back_ios,
          color: AppColors.kBlack,
          size: 30.0,
        )),
  );
}

// Returns "App themed text field" left sided label
Widget getAppThemedTextField({
  @required String label,
  @required TextEditingController controller,
  @required BuildContext context,
  bool obscureText,
  @required FocusNode focusNode,
  TextInputType keyboardType,
  Function(String) validator,
  List<TextInputFormatter> inputFormatters,
  Function(String) onFieldSubmitted,
  bool enabled = true,
  bool autoValidate,
  TextStyle textStyle,
  TextStyle labelStyle,
  Color borderColor,
  int maxLines,
  int maxLength,
  Widget suffix,
  Widget prefix,
  TextInputAction inputAction,
  TextCapitalization textCapitalization,
}) {
  // Defaults
  const TextStyle defaultLabelStyle = const TextStyle(
    color: Colors.black,
    fontSize: 16.0,
  );
  final TextStyle defaultTextStyle = new TextStyle(
    //    fontWeight: FontWeight.w600,
    color: enabled ? Colors.black : Colors.black.withOpacity(0.6),
//    fontSize: 18.0,
  );
  const Color defaultBorderColor = Colors.grey;
  final double _height = getScreenSize(context: context).height * 0.067;
  final double defaultHeight = _height > minimumDefaultButtonHeight
      ? _height
      : minimumDefaultButtonHeight;

  return new Card(
    elevation: 1.0,
    //color: Colors.grey.withOpacity(0.9),
    color: Colors.grey[200],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    child: new Stack(
      children: <Widget>[
        new Container(
          height: defaultHeight,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: new Row(
            children: <Widget>[
              prefix ?? new Container(),
              new SizedBox(
                width: 10,
              ),
              new Expanded(
                child: new TextFormField(
                  textInputAction: inputAction ?? TextInputAction.next,
                  controller: controller,
                  textCapitalization:
                      textCapitalization ?? TextCapitalization.none,
                  obscureText: obscureText ?? false,
                  focusNode: focusNode,
                  keyboardType: keyboardType,
                  validator: validator,
                  autovalidate: autoValidate ?? false,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(maxLength ?? 1000),
                  ]..addAll(inputFormatters ?? []),
                  onFieldSubmitted: onFieldSubmitted,
                  style: textStyle ?? defaultTextStyle,
                  maxLines: maxLines ?? 1,
                  decoration: new InputDecoration(
                    labelText: label,
                    labelStyle: labelStyle ?? defaultLabelStyle,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                      top: 0.0,
                      bottom: 0.0,
                    ),
                    errorStyle: new TextStyle(
                      fontSize: 10.0,
//                      color: labelStyle?.color ?? defaultLabelStyle?.color,
                    ),
                    helperStyle: new TextStyle(
                      fontSize: 0.0,
                      color: Colors.black,
                    ),
                    isDense: true,
                  ),
                ),
              ),
              suffix ?? new Container(),
            ],
          ),
        ),
        new Positioned.fill(
          child: new Offstage(
            offstage: enabled,
            child: new Container(
              color: Colors.cyanAccent.withOpacity(0.0),
            ),
          ),
        ),
      ],
    ),
  );
}

//Custom app Themed Button
Widget getAppThemedButton({@required title, onTap}) {
  return RaisedButton(
    onPressed: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      child: Text(
        title ?? "",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2),
      ),
    ),
    color: AppColors.kGreenPrimaryColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
  );
}

//full Width App Themed Button
Widget appThemedFullWidthButton({@required title, onTap}) {
  return InkWell(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppColors.kGreenPrimaryColor,
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      width: double.infinity,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 2),
          ),
        ),
      ),
    ),
    onTap: onTap,
  );
}

// App Themed AppBar
Widget getAppThemedAppBar(
    {@required context, title, needBack: true, List<Widget> actions}) {
  return AppBar(
    backgroundColor: Colors.white,
    title: Text(
      title ?? "",
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
    ),
    centerTitle: true,
    leading: needBack
        ? IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            })
        : null,
    actions: actions ?? [],
  );
}

//Common Retry View
Widget getRetryView({context, message, onRetry}) {
  return Center(
      child: Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Text("${message ?? ""}"),
      getAppThemedButton(title: "Retry", onTap: onRetry)
    ],
  ));
}

Widget getTextField(
    {BuildContext context,
    String labelText,
    Function validators,
    TextEditingController controller,
    FocusNode focusNodeCurrent,
    FocusNode focusNodeNext,
    bool obsectextType,
    TextInputType textType,
    int length,
      int maxLines=1,
    bool enablefield}) {
  return Container(
    margin: new EdgeInsets.only(left: 10.0, right: 10.0),
    child: new TextFormField(
      validator: validators,
      controller: controller,
      maxLines: maxLines,
      keyboardType: textType,
      obscureText: obsectextType,
      focusNode: focusNodeCurrent,
      enabled: enablefield,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        focusNodeCurrent.unfocus();
        FocusScope.of(context).autofocus(focusNodeNext);
      },
      maxLength: length,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 12),
          border: CustomBorder.enabledBorder,
          labelText: labelText,
          focusedBorder: CustomBorder.focusBorder,
          errorBorder: CustomBorder.errorBorder,
          enabledBorder: CustomBorder.enabledBorder,
          labelStyle: CustomTextStyle.textFormFieldMedium.copyWith(
              fontSize: MediaQuery.of(context).textScaleFactor * 16,
              color: Colors.black)),
    ),
  );
}



Widget getTextFieldWithoutValidation(
    {BuildContext context,
      String labelText,
      TextEditingController controller,
      FocusNode focusNodeCurrent,
      FocusNode focusNodeNext,
      bool obsectextType,
      TextInputType textType,
      int length,
      bool enablefield}) {
  return Container(
    margin: new EdgeInsets.only(left: 10.0, right: 10.0),
    child: new TextFormField(
      controller: controller,
      maxLines: 1,
      keyboardType: textType,
      obscureText: obsectextType,
      focusNode: focusNodeCurrent,
      enabled: enablefield,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        focusNodeCurrent.unfocus();
        FocusScope.of(context).autofocus(focusNodeNext);
      },
      maxLength: length,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 12),
          border: CustomBorder.enabledBorder,
          labelText: labelText,
          focusedBorder: CustomBorder.focusBorder,
          errorBorder: CustomBorder.errorBorder,
          enabledBorder: CustomBorder.enabledBorder,
          labelStyle: CustomTextStyle.textFormFieldMedium.copyWith(
              fontSize: MediaQuery.of(context).textScaleFactor * 16,
              color: Colors.black)),
    ),
  );
}



Widget getImage(File _image, String _profileThumbImage) {
  return new CircleAvatar(
      backgroundColor: Colors.white24,
      child: (_image != null)
          ? new Container(
              width: 100.0,
              height: 100.0,
              child: ClipOval(
                child: new Image.file(
                  _image,
                  fit: BoxFit.cover,
                ),
              ))
          : (_profileThumbImage != null && _profileThumbImage.length > 0)
              ? ClipOval(
                  child: getCachedNetworkImage(
                      url: "${_profileThumbImage ?? ""}", fit: BoxFit.cover),
                )
              : new Image.asset(
                  AssetStrings.logoImage,
                  width: 100.0,
                  height: 100.0,
                ));
}
