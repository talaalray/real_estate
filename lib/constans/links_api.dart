class AppLink {
  static const String _baseUrl = "http://10.0.2.2:8000";
  static const String api = "$_baseUrl/api";

  static const String signup = "$api/register";
  static const String login = "$api/login";
  static const String verify = "$api/verifyotp";
  static const String sendOtp = "$api/forgetpassword";
  static const String resetPassword = "$api/resetpassword";
  static const String logout = "$api/logout";


  static const String server = "http://192.168.1.11:8000/api";

  static const String signup = "$server/register";
  static const String login = "$server/login";
  static const String verify = "$server/verifyotp";


}