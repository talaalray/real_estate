// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../crud.dart';
// import 'verify_state.dart';
// import '../../../constans/links_api.dart';

// class VerifyCubit extends Cubit<VerifyState> {
//   final Crud crud;

//   VerifyCubit(this.crud) : super(VerifyInitial());

//   Future<void> verifyCode(String email, String code) async {
//     if (code.length != 4) {
//       emit(const VerifyFailure("يجب أن يتكون الكود من 4 أرقام"));
//       return;
//     }

//     emit(VerifyLoading());

//     try {
//       final response = await crud.postRequest(
//         AppLink.verify,
//         {
//           "email": email,
//           "otp": code,
//         },
//       );

//       print("Verify Response: $response");

//       if (response == null) {
//         emit(const VerifyFailure("لا توجد استجابة من الخادم"));
//         return;
//       }

//       if (response['status'] == "success" ||
//           response['success'] == true ||
//           response['verified'] == true) {
//         emit(VerifySuccess());
//       } else {
//         final errorMsg = response['message'] ??
//             response['error'] ??
//             "فشل التحقق من الكود";
//         emit(VerifyFailure(errorMsg.toString()));
//       }
//     } catch (e) {
//       print("Verify Error: $e");
//       emit(VerifyFailure("حدث خطأ في الاتصال: ${e.toString()}"));
//     }
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate/blocs/auth/verify/verify_state.dart';
import 'package:real_estate/constans/links_api.dart';
import '../../../crud.dart';

class VerifyCubit extends Cubit<VerifyState> {
  final Crud _crud;

  VerifyCubit(this._crud) : super(VerifyInitial());

  Future<void> verifyCode(String email, String otp) async {
    emit(VerifyLoading());

    try {
      print("Verification data: {email: $email, otp: $otp}");

      final response = await _crud.postRequest(
        AppLink.verify, // Replace with your actual endpoint
        {
          'email': email,
          'otp': otp,
        },
      );

      if (response == null) {
        emit(VerifyFailure('Failed to connect to server'));
        return;
      }

      if (response['message'] == 'verified successfully') {
        emit(VerifySuccess());
      } else {
        final error = response['message'] ?? 'Verification failed';
        emit(VerifyFailure(error));
      }
    } catch (e) {
      emit(VerifyFailure('An unexpected error occurred'));
    }
  }
}