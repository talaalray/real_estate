import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate/blocs/auth/reset_password/reset_password_state.dart';
import 'package:real_estate/constans/links_api.dart';
import 'package:real_estate/crud.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final Crud crud;
  String otp = "", password = "", confirmPassword = "";

  ResetPasswordCubit(this.crud) : super(ResetPasswordInitial());

  Future<void> resetPassword(String email) async {
    if (password != confirmPassword) {
      emit(ResetPasswordFailure("كلمة المرور وتأكيدها غير متطابقين"));
      return;
    }

    emit(ResetPasswordLoading());

    try {
      final response = await crud.postRequest(AppLink.resetPassword, {
        "email": email,
        "otp": otp,
        "password": password,
        "password_confirmation": confirmPassword,
      });

      if (response == null || response['status'] != "success") {
        emit(ResetPasswordFailure(response?['message'] ?? "فشل في إعادة تعيين كلمة المرور"));
        return;
      }

      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(ResetPasswordFailure("خطأ في الاتصال: ${e.toString()}"));
    }
  }
}