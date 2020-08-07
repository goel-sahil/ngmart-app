class APIs {
  APIs._();

  // Base url for testing
  static const String baseUrl = "http://134.209.125.58:63425/api";
//  static const String baseUrl = "http://ngmart.softmax.info/api";
  static const String login = "$baseUrl/login";
  static const String register = "$baseUrl/register";
  static const String profileUpdate = "$baseUrl/profile";
  static const String otpVerify = "$baseUrl/register/verify";
  static const String resendOtp = "$baseUrl/register/otp";
  static const String forgotPassword = "$baseUrl/forget-password";
  static const String changePhone = "$baseUrl/change-phone";
  static const String changePhoneVerify = "$baseUrl/change-phone/verify";
  static const String resetPassword = "$baseUrl/reset-password";
  static const String changePassword = "$baseUrl/change-password";
  static const String forgotPasswordResendOtp = "$baseUrl/forget-password/otp";
  static const String forgotPasswordOtpVerify =
      "$baseUrl/forget-password/verify";
  static const String getCategories = "$baseUrl/categories";
  static const String getProducts = "$baseUrl/products";
  static const String getOrders = "$baseUrl/orders";
  static const String cancelOrder = "$baseUrl/order";
  static const String placeSingleOrder = "$baseUrl/single-order";
  static const String addToCart = "$baseUrl/cart";
  static const String placeOrder = "$baseUrl/order";
  static const String contactUs = "$baseUrl/contact-us";
  static const String termsCondition = "$baseUrl/cms-page/terms-conditions";
  static const String privacyPolicy = "$baseUrl/cms-page/privacy";
  static const String aboutUs = "$baseUrl/cms-page/about-us";
  static const String orderByParchi = "$baseUrl/order-by-parchi";
  static const String banners = "$baseUrl/banners";
  static const String notification = "$baseUrl/notifications";
  static const String token = "$baseUrl/device-token";
  static const String getNotifications = "$baseUrl/notifications";

  //admin
  static const String getBrands = "$baseUrl/admin/brands";
  static const String getBanners = "$baseUrl/admin/banners";
  static const String getQuantity = "$baseUrl/admin/quantity-units";
  static const String category = "$baseUrl/admin/categories";
  static const String getCategoryList = "$baseUrl/admin/categories/list";
  static const String getSelectBrandList = "$baseUrl/admin/brands/list";
  static const String getQuantityUnitList = "$baseUrl/admin/quantity-units/list";
  static const String products = "$baseUrl/admin/products/list";
  static const String product = "$baseUrl/admin/products";
  static const String addBrand = "$baseUrl/admin/brands";
  static const String adminOrders = "$baseUrl/admin/orders";
  static const String cms = "$baseUrl/admin/cms-pages";
  static const String contacts = "$baseUrl/admin/contact-requests";

}
