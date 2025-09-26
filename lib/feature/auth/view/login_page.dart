import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_admin_app/core/theme/app_color.dart';
import 'package:restaurent_admin_app/core/theme/app_font.dart';
import 'package:restaurent_admin_app/feature/auth/controller/authController.dart';
import 'package:restaurent_admin_app/core/utils/common_wid.dart';
import 'package:restaurent_admin_app/feature/auth/view/register_page.dart';

class LoginPage extends StatelessWidget {
  var authController = Get.put(AuthController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Login',
              style: AppFonts.textStyle(fontSize: AppFonts.extraLarge))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(controller: emailController, labelText: 'Email'),
            const SizedBox(height: 20),
            CustomTextField(
                controller: passwordController, labelText: 'Password'),
            const SizedBox(height: 20),
            Obx(
              () => CustomButton(
                isLoading: authController.isLoading.value,
                onTap: () async {
                  if (emailController.text.trim().isNotEmpty &&
                      passwordController.text.trim().isNotEmpty) {
                    await authController.login(
                      emailController.text,
                      passwordController.text,
                    );

                    emailController.clear();
                    passwordController.clear();
                  } else {
                    ToastHelper.showError("Email And Password Are Missing!...");
                  }
                },
                text: "Login",
                textColor: AppColors.textWhite,
                color: AppColors.secondaryLight,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: RichText(
                text: TextSpan(
                  text: "Don't Have an Account? ",
                  style: AppFonts.textStyle(
                      fontSize: AppFonts.regular, color: AppColors.textPrimary),
                  children: [
                    TextSpan(
                      text: 'Sign Up',
                      style: AppFonts.textStyle(
                        fontSize: AppFonts.regular,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Handle Sign Up tap
                          Get.to(RegisterPage());
                        },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
