// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:real_estate/screens/onboarding/onboarding.dart';
// import '../../blocs/onboarding/onboarding_cubit.dart';

// class SplashOrOnboarding extends StatelessWidget {
//   const SplashOrOnboarding({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => OnboardingCubit()..checkIfSeenBefore(),
//       child: BlocBuilder<OnboardingCubit, OnboardingState>(
//         builder: (context, state) {
//           if (state is OnboardingCheckCompleted || state is OnboardingPageChanged) {
//             return const OnboardingScreen();
//           }
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate/screens/onboarding/onboarding.dart';
import 'package:real_estate/constans/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../blocs/onboarding/onboarding_cubit.dart';

class SplashOrOnboarding extends StatefulWidget {
  const SplashOrOnboarding({super.key});

  @override
  State<SplashOrOnboarding> createState() => _SplashOrOnboardingState();
}

class _SplashOrOnboardingState extends State<SplashOrOnboarding> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnStatus();
  }

  Future<void> _navigateBasedOnStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seen_onboarding') ?? false;
    final token = prefs.getString('user_token');

    await Future.delayed(const Duration(seconds: 2)); // لتظهر دائرة التحميل قليلًا

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, AppRoute.home);
    } else if (seenOnboarding) {
      Navigator.pushReplacementNamed(context, AppRoute.login);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}