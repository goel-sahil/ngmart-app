class APIs {
  APIs._();

  // Base url for testing
  static const String baseUrl = "http://134.209.125.58:63425/api";
  static const String login = "$baseUrl/login";
  static const String register = "$baseUrl/register";
  static const String otpVerify = "$baseUrl/register/verify";
  static const String resendOtp = "$baseUrl/register/otp";
  static const String getCategories = "$baseUrl/categories";
  static const String getProducts = "$baseUrl/products";
}
