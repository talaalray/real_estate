

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../blocs/auth/verify/otp_cubit.dart';
// import '../../blocs/auth/verify/verify_cubit.dart';
// import '../../blocs/auth/verify/verify_state.dart';
// import '../../constans/image_url.dart';
// import '../../constans/routes.dart';
// import '../../crud.dart';
// import '../../widgets/auth/bouttom_auth.dart';
// import '../../widgets/auth/otpfeild.dart';

// class Verification extends StatelessWidget {
//   final String email;

//   const Verification({super.key, required this.email});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => OtpCubit()),
//         BlocProvider(create: (_) => VerifyCubit(Crud())),
//       ],
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: BlocConsumer<VerifyCubit, VerifyState>(
//             listener: (context, state) {
//               print("Current State: $state");

//               if (state is VerifySuccess) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text("تم التحقق بنجاح"),
//                     backgroundColor: Colors.green,
//                     duration: Duration(seconds: 2),
//                   ),
//                 );

//                 Future.delayed(const Duration(seconds: 1), () {
//                   print("الانتقال إلى الصفحة الرئيسية بعد التحقق");
//                   Navigator.of(context).pushReplacementNamed(AppRoute.home);
//                 });
//               }

//               if (state is VerifyFailure) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(state.error),
//                     backgroundColor: Colors.red,
//                   ),
//                 );

//                 context.read<OtpCubit>().clear();
//               }
//             },
//             builder: (context, state) {
//               return _buildVerificationUI(context, state);
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildVerificationUI(BuildContext context, VerifyState state) {
//     return Column(
//       children: [
//         Expanded(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 40),
//                   Image.asset(AppImageAsset.verify, height: 200),
//                   const SizedBox(height: 30),
//                   const Text(
//                     'يرجى إدخال الرمز المرسل إلى البريد الإلكتروني التالي',
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     email,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       color: Colors.blue,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 30),

//                   OtpFields(),

//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),

//         Padding(
//           padding: const EdgeInsets.all(20.0),
          
//           child: state is VerifyLoading
//               ? const CircularProgressIndicator()
//               : BottumAuth(
//                   title: "تحقق",
//                   onPressed: () {
//                     final code = context.read<OtpCubit>().fullCode;
//                     if (code.length == 4) {
//                       context.read<VerifyCubit>().verifyCode(email, code);
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("يجب إدخال الكود المكون من 4 أرقام"),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                     }
//                   },
//                 ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/verify/otp_cubit.dart';
import '../../blocs/auth/verify/verify_cubit.dart';
import '../../blocs/auth/verify/verify_state.dart';
import '../../constans/image_url.dart';
import '../../constans/routes.dart';
import '../../crud.dart';
import '../../widgets/auth/bouttom_auth.dart';
import '../../widgets/auth/otpfeild.dart';

class Verification extends StatelessWidget {
  final String email;
  final bool fromReset;

  const Verification({
    super.key,
    required this.email,
    this.fromReset = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => OtpCubit()),
        BlocProvider(create: (_) => VerifyCubit(Crud())),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocConsumer<VerifyCubit, VerifyState>(
            listener: (context, state) {
              if (state is VerifySuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("تم التحقق بنجاح"),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );

                Future.delayed(const Duration(seconds: 1), () {
                  if (fromReset) {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoute.resetPassword,
                      arguments: email,
                    );
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoute.home,
                      (route) => false,
                    );
                  }
                });
              }

              if (state is VerifyFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
                context.read<OtpCubit>().clear();
              }
            },
            builder: (context, state) {
              return _buildVerificationUI(context, state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationUI(BuildContext context, VerifyState state) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Image.asset(AppImageAsset.verify, height: 200),
                const SizedBox(height: 30),
                const Text(
                  'يرجى إدخال الرمز المرسل إلى البريد الإلكتروني التالي',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),
                OtpFields(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: state is VerifyLoading
              ? const CircularProgressIndicator()
              : BottumAuth(
                  title: "تحقق",
                  onPressed: () {
                    final code = context.read<OtpCubit>().fullCode;
                    if (code.length == 4) {
                      context.read<VerifyCubit>().verifyCode(email, code);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("يجب إدخال الكود المكون من 4 أرقام"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
        ),
      ],
    );
  }
}