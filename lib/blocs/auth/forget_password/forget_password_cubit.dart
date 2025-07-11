import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../crud.dart';
import '../../../constans/links_api.dart';
import 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final Crud crud;
  String email = "";

  ForgetPasswordCubit(this.crud) : super(ForgetPasswordInitial());

  Future<void> sendOtp() async {
    emit(ForgetPasswordLoading());

    try {
      final response = await crud.postRequest(AppLink.sendOtp, {"email": email});
      print("📨 Response: $response");

      if (response == null) {
        emit(ForgetPasswordFailure("لا توجد استجابة من الخادم"));
        return;
      }

      if (response['status'] == "success" ||
          response['message']?.toString().contains("OTP") == true) {
        emit(ForgetPasswordSuccess()); // ✅ الحالة التي تفعل التنقل
      } else {
        final msg = response['message'] ?? "فشل في إرسال رمز التحقق";
        emit(ForgetPasswordFailure(msg));
      }
    } catch (e) {
      emit(ForgetPasswordFailure("خطأ في الاتصال: ${e.toString()}"));
    }
  }
}