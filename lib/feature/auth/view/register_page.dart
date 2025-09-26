import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_admin_app/core/theme/app_color.dart';
import 'package:restaurent_admin_app/core/theme/app_font.dart';
import 'package:restaurent_admin_app/feature/auth/controller/authController.dart';
import 'package:restaurent_admin_app/core/utils/common_wid.dart';
import 'package:restaurent_admin_app/feature/auth/view/login_page.dart';

class RegisterPage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(controller: nameController, labelText: 'Name'),
            const SizedBox(height: 20),
            CustomTextField(controller: emailController, labelText: 'Email'),
            const SizedBox(height: 20),
            CustomTextField(
                controller: passwordController,
                labelText: 'Password',
                obscureText: true),
            const SizedBox(height: 20),
            Obx(
              () => CustomButton(
                isLoading: authController.isLoading.value,
                onTap: () async {
                  await authController.register(
                    nameController.text,
                    emailController.text,
                    passwordController.text,
                  );

                  nameController.clear();
                  emailController.clear();
                  passwordController.clear();
                },
                text: "Register",
                textColor: AppColors.textWhite,
                color: AppColors.secondaryLight,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: RichText(
                text: TextSpan(
                  text: "Already Having an Account? ",
                  style: AppFonts.textStyle(
                      fontSize: AppFonts.regular, color: AppColors.textPrimary),
                  children: [
                    TextSpan(
                      text: 'Login',
                      style: AppFonts.textStyle(
                        fontSize: AppFonts.regular,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Handle Sign Up tap
                          Get.to(LoginPage());
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
