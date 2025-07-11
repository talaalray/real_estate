import 'package:http/http.dart' as http;
import 'dart:convert';

class Crud {

  Future<Map<String, dynamic>?> getRequest(String url, {String? token}) async {
    try {
      var headers = {'Accept': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      var response = await http.get(Uri.parse(url), headers: headers);
      print("🔓 GET Logout status: ${response.statusCode}");
      print("🔓 GET Logout body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print("❌ GET Error: $e");
      return null;
    }
  }



//  Future<Map<String, dynamic>?> getRequest(String url, {String? token}) async {
//     try {
//       var headers = {
//         'Accept': 'application/json',
//       };
//       if (token != null && token.isNotEmpty) {
//         headers['Authorization'] = 'Bearer $token'; // ✅ ضروري!
//       } else {
//         print("🚨 تحذير: التوكن فارغ أو غير موجود!");
//       }

//       var response = await http.get(Uri.parse(url), headers: headers);

//       print("🔓 GET Logout status: ${response.statusCode}");
//       print("🔓 GET Logout body: ${response.body}");

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return jsonDecode(response.body);
//       } else {
//         print("❌ خطأ: ${response.statusCode}");
//         return null;
//       }
//     } catch (e) {
//       print("⚠️ خطأ أثناء الاتصال بالسيرفر: $e");
//       return null;
//     }
//   }


  Future<Map<String, dynamic>?> postRequest(String url, Map<String, dynamic> data) async {
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );

      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      print("Error Catch $e");
      return {
        "status": "error",
        "error": e.toString(),
      };
    }
  }


}