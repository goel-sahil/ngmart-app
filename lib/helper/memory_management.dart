import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SharedPrefsKeys.dart';


class MemoryManagement {
  static SharedPreferences prefs;

  static Future<bool> init() async {
    prefs = await SharedPreferences.getInstance();
    return true;
  }

  static void setAccessToken({@required String accessToken}) {
    prefs.setString(SharedPrefsKeys.ACCESS_TOKEN, accessToken);
  }

  static String getAccessToken() {
    return prefs.getString(SharedPrefsKeys.ACCESS_TOKEN);
  }


  static void setuserName({@required String username}) {
    prefs.setString(SharedPrefsKeys.NAME, username);
  }

  static String getuserName() {
    return prefs.getString(SharedPrefsKeys.NAME);
  }

  static void setuserId({@required String id}) {
    prefs.setString(SharedPrefsKeys.USERID, id);
  }


  static String getuserId() {
    return prefs.getString(SharedPrefsKeys.USERID);
  }
  static String getPayPalId() {
    return prefs.getString(SharedPrefsKeys.PAYPAL_ID);
  }

  static void setPayPalId({@required String id}) {
    prefs.setString(SharedPrefsKeys.PAYPAL_ID, id);
  }

  static void setImage({@required String image}) {
    prefs.setString(SharedPrefsKeys.IMAGE, image);
  }

  static String getImage() {
    return prefs.getString(SharedPrefsKeys.IMAGE);
  }


  static void setNotificationOnOff({@required bool onoff}) {
    prefs.setBool(SharedPrefsKeys.NOTIFICATION_ONOFF, onoff);
  }

  static bool getNotificationOnOff() {
    return prefs.getBool(SharedPrefsKeys.NOTIFICATION_ONOFF);
  }



  static void setSocialStatus({@required bool status}) {
    prefs.setBool(SharedPrefsKeys.LOGIN_STATUS, status);
  }

  static bool getSocialStatus() {
    return prefs.getBool(SharedPrefsKeys.LOGIN_STATUS);
  }


  static void setFilterData({@required String filter}) {
    prefs.setString(SharedPrefsKeys.FILTER_DATA, filter);
  }

  static String getFilterData() {
    return prefs.getString(SharedPrefsKeys.FILTER_DATA);
  }


  static void setFilterDataStatus({@required bool filterstatus}) {
    prefs.setBool(SharedPrefsKeys.FILTER_DATA_STATUS, filterstatus);
  }


  static void setLoggedInStatus({@required bool logInStatus}) {
    prefs.setBool(SharedPrefsKeys.LOG_IN_STATUS, logInStatus);
  }

  static bool getLoggedInStatus() {
    return prefs.getBool(SharedPrefsKeys.LOG_IN_STATUS);
  }



  static bool getTabDataStatus() {
    return prefs.getBool(SharedPrefsKeys.LOG_IN_STATUS);
  }


  static void setDeviceId({@required String deviceID}) {
    prefs.setString(SharedPrefsKeys.DEVICE_ID, deviceID);
  }

  static String getDeviceId() {
    return prefs?.getString(SharedPrefsKeys.DEVICE_ID);
  }

  static void setUserInfo({@required String userInfo}) {
    prefs.setString(SharedPrefsKeys.USER_INFO, userInfo);
  }

  static String getUserInfo() {
    return prefs.getString(SharedPrefsKeys.USER_INFO);
  }

  static void setUserLoggedIn({@required bool isUserLoggedin}) {
    prefs.setBool(SharedPrefsKeys.IS_USER_LOGGED_IN, isUserLoggedin);
  }

  static bool getUserLoggedIn() {
    return prefs.getBool(SharedPrefsKeys.IS_USER_LOGGED_IN);
  }

  static void setUserType({@required String userType}) {
    prefs.setString(SharedPrefsKeys.USER_TYPE, userType);
  }

  static String getUserType() {
    return prefs?.getString(SharedPrefsKeys.USER_TYPE);
  }

  static void setUserLanguage({@required String languageCode}) {
     prefs.setString(SharedPrefsKeys.LANGUAGE_CODE, languageCode);
  }

  static String getUserLanguage() {
    return prefs?.getString(SharedPrefsKeys.LANGUAGE_CODE);
  }

  static void setUserPushNotificationsStatus({@required int status}) {
     prefs.setInt(SharedPrefsKeys.PUSH_NOTIFICATIONS_STATUS, status);
  }

  static bool getUserPushNotificationsStatus() {
    return prefs?.getInt(SharedPrefsKeys.PUSH_NOTIFICATIONS_STATUS) == 1;
  }

  static void setDeepLinkTimestamp({@required int timestamp}) {
     prefs.setInt(SharedPrefsKeys.DEEPLINK_TIMESTAMP, timestamp);
  }

  static int getDeepLinkTimestamp() {
    return prefs?.getInt(SharedPrefsKeys.DEEPLINK_TIMESTAMP);
  }


  static void setConfirmationUser({@required bool isConfirmUser}) {
    prefs.setBool(SharedPrefsKeys.CONFIRMATION_USER, isConfirmUser);
  }

  static bool getConfirmationUser() {
    return prefs.getBool(SharedPrefsKeys.CONFIRMATION_USER);
  }


  // Paginating list data storage

  // ASSET_MILLS
  static void setAssetMills({@required String millsData}) {
    prefs.setString(SharedPrefsKeys.ASSET_MILLS, millsData);
  }
  static String getAssetMills() {
    return prefs.getString(SharedPrefsKeys.ASSET_MILLS);
  }

  // ASSET_FARMERS
  static void setAssetFarmers({@required String farmersData}) {
    prefs.setString(SharedPrefsKeys.ASSET_FARMERS, farmersData);
  }
  static String getAssetFarmers() {
    return prefs.getString(SharedPrefsKeys.ASSET_FARMERS);
  }

  // ASSET_EXPORTERS
  static void setAssetExporters({@required String exportersData}) {
    prefs.setString(SharedPrefsKeys.ASSET_EXPORTERS, exportersData);
  }
  static String getAssetExporters() {
    return prefs.getString(SharedPrefsKeys.ASSET_EXPORTERS);
  }

  // ASSET_COOPS
  static void setAssetCoops({@required String coopsData}) {
    prefs.setString(SharedPrefsKeys.ASSET_COOPS, coopsData);
  }
  static String getAssetCoops() {
    return prefs.getString(SharedPrefsKeys.ASSET_COOPS);
  }

  // ASSET_IMPORTERS
  static void setAssetImporters({@required String importersData}) {
    prefs.setString(SharedPrefsKeys.ASSET_IMPORTERS, importersData);
  }
  static String getAssetImporters() {
    return prefs.getString(SharedPrefsKeys.ASSET_IMPORTERS);
  }

  // ASSET_CAFE_STORES
  static void setAssetCafeStores({@required String cafeStoresData}) {
    prefs.setString(SharedPrefsKeys.ASSET_CAFE_STORES, cafeStoresData);
  }
  static String getAssetCafeStores() {
    return prefs.getString(SharedPrefsKeys.ASSET_CAFE_STORES);
  }

  // ASSET_ROASTER
  static void setAssetRoasters({@required String roastersData}) {
    prefs.setString(SharedPrefsKeys.ASSET_ROASTERS, roastersData);
  }
  static String getAssetRoasters() {
    return prefs.getString(SharedPrefsKeys.ASSET_ROASTERS);
  }


  //clear all values from shared preferences
  static void clearMemory() {
    prefs.clear();
  }
}
