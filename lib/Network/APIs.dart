class APIs {
  APIs._();

  // Base url for testing
  static const String baseUrl = "http://134.209.125.58:63425/api";
  static const String login = "$baseUrl/login";
  static const String register = "$baseUrl/register";
  static const String profileUpdate = "$baseUrl/profile";
  static const String otpVerify = "$baseUrl/register/verify";
  static const String resendOtp = "$baseUrl/register/otp";
  static const String forgotPassword = "$baseUrl/forget-password";
  static const String resetPassword = "$baseUrl/reset-password";
  static const String forgotPasswordResendOtp = "$baseUrl/forget-password/otp";
  static const String forgotPasswordOtpVerify =
      "$baseUrl/forget-password/verify";
  static const String getCategories = "$baseUrl/categories";
  static const String getProducts = "$baseUrl/products";
  static const String addToCart = "$baseUrl/cart";
  static const String placeOrder = "$baseUrl/order";
}
