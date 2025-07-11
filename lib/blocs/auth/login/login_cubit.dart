import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate/blocs/auth/auth_storage.dart';
import 'package:real_estate/constans/links_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../crud.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final Crud crud;

  LoginCubit(this.crud) : super(LoginInitial());

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      final response = await crud.postRequest(AppLink.login, {
        "identifier": email,
        "password": password,
      });
      print("login response: $response");
      if (response != null &&
          (response['status'] == "success" ||
              response['message']?.contains("success") == true)) {
        final token = response['token'];
final user = response['user'];

if (token != null && user != null) {
  await AuthStorage.saveUserData(user, token);
  print("✅ تم حفظ التوكن وبيانات المستخدم باستخدام AuthStorage");
}

        emit(LoginSuccess());
      } else {
        String errorMessage = "حدث خطأ أثناء تسجيل الدخول";
        if (response != null) {
          if (response.containsKey('message')) {
            errorMessage = response['message'];
          } else if (response.containsKey('error')) {
            errorMessage = response['error'];
          }
        }
        emit(LoginFailure(errorMessage));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
