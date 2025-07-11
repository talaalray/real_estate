import 'package:flutter/material.dart';
import 'package:real_estate/crud.dart';
import 'package:real_estate/constans/links_api.dart';
import 'package:real_estate/constans/routes.dart';

class ResetPassword extends StatefulWidget {
  final String email;

  const ResetPassword({super.key, required this.email});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  void showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  Future<void> resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await Crud().postRequest(AppLink.resetPassword, {
        "email": widget.email.trim(),
        "otp": otpController.text.trim(),
        "password": newPasswordController.text.trim(),
        "password_confirmation": confirmPasswordController.text.trim(),
      });

      print("🔁 Reset response: $response");

      if (response != null &&
          (response['status'] == "success" ||
              response['message'].toString().toLowerCase().contains("reset"))) {
        showMessage(" تم تغيير كلمة المرور بنجاح", Colors.green);

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushNamedAndRemoveUntil(context, AppRoute.login, (route) => false);
        });
      } else {
        showMessage(response?['message'] ?? "فشل في تغيير كلمة المرور", Colors.red);
      }
    } catch (e) {
      showMessage("حدث خطأ غير متوقع: ${e.toString()}", Colors.red);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إعادة تعيين كلمة المرور")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Text(
                "البريد المرتبط بالحساب",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                widget.email,
                style: const TextStyle(color: Colors.blue, fontSize: 16),
              ),
              const SizedBox(height: 20),

              _buildField(
                controller: otpController,
                label: "رمز التحقق OTP",
                keyboardType: TextInputType.number,
                validator: (val) => (val == null || val.length != 4) ? "أدخل رمز مكون من 4 أرقام" : null,
              ),

              const SizedBox(height: 20),

              _buildField(
                controller: newPasswordController,
                label: "كلمة المرور الجديدة",
                obscureText: true,
                validator: (val) => (val == null || val.length < 6)
                    ? "كلمة المرور يجب أن تكون 6 أحرف على الأقل"
                    : null,
              ),

              const SizedBox(height: 20),

              _buildField(
                controller: confirmPasswordController,
                label: "تأكيد كلمة المرور",
                obscureText: true,
                validator: (val) =>
                    val != newPasswordController.text ? "كلمتا المرور غير متطابقتين" : null,
              ),

              const SizedBox(height: 30),

              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: resetPassword,
                      icon: const Icon(Icons.lock_reset),
                      label: const Text("تحديث كلمة المرور"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: obscureText ? const Icon(Icons.lock_outline) : null,
      ),
    );
  }
}