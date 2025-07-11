import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate/blocs/auth/auth_storage.dart';
import 'package:real_estate/blocs/auth/logout/logout_cubit.dart';
import 'package:real_estate/blocs/auth/logout/logout_state.dart';
import 'package:real_estate/crud.dart';
import 'package:real_estate/constans/routes.dart';
import 'package:real_estate/screens/auth/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    final user = await AuthStorage.getUserData();
    setState(() {
      userName = user['name'] ?? '';
      userEmail = user['email'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LogoutCubit(Crud()),
      child: BlocConsumer<LogoutCubit, LogoutState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoute.login,
              (route) => false,
            );
          } else if (state is LogoutFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text("الصفحة الرئيسية")),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(userName),
                    accountEmail: Text(userEmail),
                    currentAccountPicture: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 40),
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.lightBlueAccent],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text("تعديل الملف الشخصي"),
                    onTap: () {
                      // تعديل الملف الشخصي
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text("تغيير كلمة المرور"),
                    onTap: () {
                      // تغيير كلمة السر
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: state is LogoutLoading
                        ? const Text("جاري تسجيل الخروج...")
                        : const Text("تسجيل الخروج"),
                    onTap: state is LogoutLoading
                        ? null
                        : () {
                            context.read<LogoutCubit>().logout();
                          },
                  ),
                ],
              ),
            ),
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Login()),
                  );
                },
                child: const Text("الذهاب إلى صفحة التسجيل"),
              ),
            ),
          );
        },
      ),
    );
  }
}