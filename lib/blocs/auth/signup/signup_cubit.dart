// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:real_estate/blocs/auth/signup/signup_state.dart';
// import 'package:real_estate/constans/links_api.dart';
// import '../../../crud.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SignupCubit extends Cubit<SignupState> {
//   final Crud crud;

//   SignupCubit(this.crud) : super(SignupInitial());

//   Future<void> signUp({
//     required String name,
//     required String email,
//     required String password,
//     required String passwordConfirmation,
//     required String phoneNumber,
//   }) async {
//     emit(SignupLoading());
//     try {
//       final response = await crud.postRequest(AppLink.signup, {
//         "name": name,
//         "email": email,
//         "password": password,
//         "password_confirmation": passwordConfirmation,
//         "phone_number": phoneNumber,
//       });

//       print("📨 Signup response: $response");

//       if (response != null &&
//           (response['status'] == "success" ||
//               response['message']?.toString().contains("User registered") ==
//                   true)) {
//         final token = response['token'];
//         if (token != null) {
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString('user_token', token);
//           print("🔐 تم حفظ التوكن بنجاح: $token");
//         }

//         emit(SignupSuccess(email));
//       } else {
//         String errorMessage = " حدث خطأ أثناء التسجيل.";
//         if (response != null) {
//           if (response.containsKey('message')) {
//             errorMessage = response['message'];
//           } else if (response.containsKey('error')) {
//             errorMessage = response['error'];
//           }
//         }
//         emit(SignupFailure(errorMessage));
//       }
//     } catch (e) {
//       print(" Exception during signup: $e");
//       emit(SignupFailure("خطأ غير متوقع: ${e.toString()}"));
//     }
//   }
// }


// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:real_estate/blocs/auth/auth_storage.dart';
// import 'package:real_estate/blocs/auth/signup/signup_state.dart';
// import 'package:real_estate/constans/links_api.dart';
// import 'package:real_estate/crud.dart';


// class SignupCubit extends Cubit<SignupState> {
//   final Crud crud;

//   SignupCubit(this.crud) : super(SignupInitial());

//   Future<void> signUp({
//     required String name,
//     required String email,
//     required String password,
//     required String passwordConfirmation,
//     required String phoneNumber,
//   }) async {
//     emit(SignupLoading());
//     try {
//       final response = await crud.postRequest(AppLink.signup, {
//         "name": name,
//         "email": email,
//         "password": password,
//         "password_confirmation": passwordConfirmation,
//         "phone_number": phoneNumber,
//       });

//       print("📨 Signup response: $response");

//       if (response != null &&
//           (response['status'] == "success" ||
//               response['message']?.toString().contains("User registered") == true)) {
//         final token = response['token'];
//         final user = response['user'];

//         if (token != null && user != null) {
//           await AuthStorage.saveUserData(user, token); // ✅ حفظ بيانات المستخدم
//           print("🔐 تم حفظ بيانات المستخدم بنجاح");
//         }

//         emit(SignupSuccess(email));
//       } else {
//         String errorMessage = "حدث خطأ أثناء التسجيل.";
//         if (response != null) {
//           errorMessage = response['message'] ?? response['error'] ?? errorMessage;
//         }
//         emit(SignupFailure(errorMessage));
//       }
//     } catch (e) {
//       print("❌ Exception during signup: $e");
//       emit(SignupFailure("خطأ غير متوقع: ${e.toString()}"));
//     }
//   }
// }



import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate/blocs/auth/auth_storage.dart';
import 'package:real_estate/blocs/auth/signup/signup_state.dart';
import 'package:real_estate/constans/links_api.dart';
import 'package:real_estate/crud.dart';


class SignupCubit extends Cubit<SignupState> {
  final Crud crud;

  SignupCubit(this.crud) : super(SignupInitial());

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phoneNumber,
  }) async {
    emit(SignupLoading());
    try {
      final response = await crud.postRequest(AppLink.signup, {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
        "phone_number": phoneNumber,
      });

      if (response != null &&
          (response['status'] == "success" ||
              response['message']?.toString().contains("User registered") == true)) {
        final token = response['token'];
        final user = response['user'];
        if (token != null && user != null) {
          await AuthStorage.saveUserData(user, token);
        }

        emit(SignupSuccess(email));
      } else {
        String error = response?['message'] ?? response?['error'] ?? "حدث خطأ أثناء التسجيل.";
        emit(SignupFailure(error));
      }
    } catch (e) {
      emit(SignupFailure("حدث خطأ غير متوقع: $e"));
    }
  }
}