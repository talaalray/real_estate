// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:real_estate/blocs/auth/forget_password/forget_password_cubit.dart';
// import 'package:real_estate/blocs/auth/forget_password/forget_password_state.dart';
// import 'package:real_estate/constans/routes.dart';
// import 'package:real_estate/crud.dart';

// class ForgetPassword extends StatelessWidget {
//   const ForgetPassword({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final emailController = TextEditingController(); // للتحكم في البريد

//     return BlocProvider(
//       create: (_) => ForgetPasswordCubit(Crud()),
//       child: Scaffold(
//         appBar: AppBar(title: const Text("نسيت كلمة المرور")),
//         body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
//           listener: (context, state) {
//             if (state is ForgetPasswordSuccess) {
//               // ✅ عند نجاح إرسال OTP → الانتقال مباشرة إلى ResetPassword
//               Navigator.pushNamed(
//                 context,
//                 AppRoute.resetPassword,
//                 arguments: emailController.text.trim(),
//               );
//             }

//             if (state is ForgetPasswordFailure) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.error),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             }
//           },
//           builder: (context, state) {
//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   const Text("أدخل بريدك الإلكتروني لإرسال رمز OTP"),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: emailController,
//                     decoration: const InputDecoration(labelText: "البريد الإلكتروني"),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       // حفظ البريد داخل الكيوبت ثم إرسال الطلب
//                       context.read<ForgetPasswordCubit>().email =
//                           emailController.text.trim();
//                       context.read<ForgetPasswordCubit>().sendOtp();
//                     },
//                     child: const Text("إرسال OTP"),
//                   ),
//                   if (state is ForgetPasswordLoading)
//                     const Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: CircularProgressIndicator(),
//                     ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate/blocs/auth/forget_password/forget_password_cubit.dart';
import 'package:real_estate/blocs/auth/forget_password/forget_password_state.dart';
import 'package:real_estate/constans/routes.dart';
import 'package:real_estate/crud.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgetPasswordCubit(Crud()),
      child: Scaffold(
        appBar: AppBar(title: const Text("نسيت كلمة المرور")),
        body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
          listener: (context, state) {
            if (state is ForgetPasswordSuccess) {
              Navigator.pushNamed(
                context,
                AppRoute.resetPassword,
                arguments: emailController.text.trim(),
              );
            }
            if (state is ForgetPasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            isLoading = state is ForgetPasswordLoading;

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "أدخل بريدك الإلكتروني وسنرسل لك رمز التحقق لإعادة تعيين كلمة المرور",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "البريد الإلكتروني",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "يرجى إدخال البريد الإلكتروني";
                        }
                        if (!value.contains("@")) {
                          return "البريد الإلكتروني غير صالح";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<ForgetPasswordCubit>().email =
                                    emailController.text.trim();
                                context.read<ForgetPasswordCubit>().sendOtp();
                              }
                            },
                            icon: const Icon(Icons.send),
                            label: const Text("إرسال رمز التحقق"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 32,
                              ),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}