import 'package:flutter/cupertino.dart';
import 'package:real_estate/screens/auth/forget_password/forget_password.dart';
import 'package:real_estate/screens/auth/forget_password/resetpassword.dart';
import '../screens/auth/login.dart';
import '../screens/auth/signup.dart';
import '../screens/auth/verify.dart';
import '../screens/home.dart';
import '../screens/onboarding/splash.dart';

class AppRoute {
  static const String splash = "/splash";
  static const String login = "/login";
  static const String signUp = "/signup";
  static const String verify = "/verify";
  static const String home = '/home';
  static const String forgetPassword = "/forgetPassword";
  static const String resetPassword = "/resetPassword";
  
}

Map<String, Widget Function(BuildContext)> routes = {
  AppRoute.splash: (context) => const SplashOrOnboarding(),
  AppRoute.login: (context) => const Login(),
  AppRoute.signUp: (context) => const Signup(),

AppRoute.verify: (context) {
  final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  return Verification(
    email: args['email'],
    fromReset: args['fromReset'] ?? false,
  );
},

  AppRoute.home: (context) => const Home(),

  AppRoute.forgetPassword: (context) => const ForgetPassword(),
  AppRoute.resetPassword: (context) {
    final email = ModalRoute.of(context)!.settings.arguments as String;
    return ResetPassword(email: email);
  },
};
