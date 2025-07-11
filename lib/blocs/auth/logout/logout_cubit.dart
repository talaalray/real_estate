import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate/blocs/auth/auth_storage.dart';
import 'package:real_estate/blocs/auth/logout/logout_state.dart';
import 'package:real_estate/constans/links_api.dart';
import 'package:real_estate/crud.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final Crud crud;

  LogoutCubit(this.crud) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      final user = await AuthStorage.getUserData();
      final token = user['token'] ?? '';
      if (token.isEmpty) throw Exception("التوكن مفقود");

      final response = await crud.getRequest(AppLink.logout, token: token);

      if (response != null &&
          response['message']?.toString().toLowerCase().contains(
                "logged out",
              ) ==
              true) {
        await AuthStorage.clearUserData();
        emit(LogoutSuccess());
      } else {
        emit(LogoutFailure(response?['message'] ?? 'فشل تسجيل الخروج'));
      }
    } catch (e) {
      emit(LogoutFailure('حدث خطأ أثناء تسجيل الخروج: $e'));
    }
  }
}
