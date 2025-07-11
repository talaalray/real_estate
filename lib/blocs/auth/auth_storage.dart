// import 'package:shared_preferences/shared_preferences.dart';

// class AuthStorage {
//   static const _tokenKey = 'user_token';
//   static const _idKey = 'user_id';
//   static const _nameKey = 'user_name';
//   static const _emailKey = 'user_email';
//   static const _phoneKey = 'user_phone';

//   /// حفظ بيانات المستخدم والتوكن
//   static Future<void> saveUserData(Map<String, dynamic> user, String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_tokenKey, token);
//     await prefs.setString(_idKey, user['id'].toString());
//     await prefs.setString(_nameKey, user['name'] ?? '');
//     await prefs.setString(_emailKey, user['email'] ?? '');
//     await prefs.setString(_phoneKey, user['phone_number'] ?? '');
//   }

//   /// استرجاع بيانات المستخدم كخريطة
//   static Future<Map<String, String>> getUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     return {
//       'token': prefs.getString(_tokenKey) ?? '',
//       'id': prefs.getString(_idKey) ?? '',
//       'name': prefs.getString(_nameKey) ?? '',
//       'email': prefs.getString(_emailKey) ?? '',
//       'phone': prefs.getString(_phoneKey) ?? '',
//     };
//   }

//   /// حذف بيانات المستخدم (مثلاً عند تسجيل الخروج)
//   static Future<void> clearUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_tokenKey);
//     await prefs.remove(_idKey);
//     await prefs.remove(_nameKey);
//     await prefs.remove(_emailKey);
//     await prefs.remove(_phoneKey);
//   }
// }

import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _tokenKey = 'user_token';
  static const _idKey = 'user_id';
  static const _nameKey = 'user_name';
  static const _emailKey = 'user_email';
  static const _phoneKey = 'user_phone';

  static Future<void> saveUserData(Map<String, dynamic> user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_idKey, user['id'].toString());
    await prefs.setString(_nameKey, user['name'] ?? '');
    await prefs.setString(_emailKey, user['email'] ?? '');
    await prefs.setString(_phoneKey, user['phone_number'] ?? '');
  }

  static Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'token': prefs.getString(_tokenKey) ?? '',
      'id': prefs.getString(_idKey) ?? '',
      'name': prefs.getString(_nameKey) ?? '',
      'email': prefs.getString(_emailKey) ?? '',
      'phone': prefs.getString(_phoneKey) ?? '',
    };
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_idKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_phoneKey);
  }
}