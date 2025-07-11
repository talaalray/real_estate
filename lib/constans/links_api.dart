class AppLink {
  static const String _baseUrl = "http://10.0.2.2:8000";
  static const String api = "$_baseUrl/api";

  static const String signup = "$api/register";
  static const String login = "$api/login";
  static const String verify = "$api/verifyotp";
  static const String sendOtp = "$api/forgetpassword";
  static const String resetPassword = "$api/resetpassword";
  static const String logout = "$api/logout";
}