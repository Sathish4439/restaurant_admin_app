import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:restaurent_admin_app/core/services/endpoint.dart';
import 'package:restaurent_admin_app/core/theme/app_color.dart';
import 'package:restaurent_admin_app/core/theme/app_font.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onTap;
  final double width;
  final double height;
  final Color color;
  final Color textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 50,
    this.color = AppColors.secondary,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: isLoading ? null : onTap,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(text,
                style: AppFonts.textStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppFonts.large,
                    color: textColor)),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          enabledBorder:OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.border),
            
            borderRadius: BorderRadius.circular(8),
          ) ,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.border),
            
            borderRadius: BorderRadius.circular(8),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.border),
            
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }
}

class CustomerAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomerAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        textAlign: TextAlign.end, // 👈 must be inside Text widget, not before
        style: AppFonts.textStyle(
          fontSize: AppFonts.extraLarge,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ToastHelper {
  /// Show a toast message
  static void showToast({
    required String message,
    ToastGravity gravity = ToastGravity.TOP,
    Color backgroundColor = AppColors.primary,
    Color textColor = Colors.white,
    double fontSize = 16,
    Toast length = Toast.LENGTH_SHORT,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: length,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }

  /// Show success toast
  static void showSuccess(String message) {
    showToast(
      message: message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  /// Show error toast
  static void showError(String message) {
    showToast(
      message: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  /// Show info toast
  static void showInfo(String message) {
    showToast(
      message: message,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }
}

double getHeight(double h) {
  return Get.height * h;
}

double getWidth(double w) {
  return Get.width * w;
}

Widget loadImage(String? imageUrl) {
  return Image.network(
    imageUrl ?? "", // if null, pass empty
    height: getHeight(0.12),
    width: getWidth(0.12),
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) {
      // ✅ Show default image if network fails
      return Image.asset(
        "assets/icons/default.png",
        height: getHeight(0.12),
        width: getWidth(0.12),
        fit: BoxFit.contain,
      );
    },
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      // ✅ Show placeholder while loading
      return Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    },
  );
}

Future<void> uploadImage(
    File file, RxBool isLoading, RxString uploadedUrl) async {
  try {
    isLoading.value = true;

    String fileName = file.path.split("/").last;
    dio.FormData formData = dio.FormData.fromMap({
      "image": await dio.MultipartFile.fromFile(file.path, filename: fileName),
    });

    var response = await dio.Dio().post(
      EndPoints.single, // change to your backend URL
      data: formData,
      options: dio.Options(headers: {"Content-Type": "multipart/form-data"}),
    );

    print(response);
    if (response.data["success"]) {
      uploadedUrl.value = response.data["filename"];
      Get.snackbar("Success", "Image uploaded successfully");
    } else {
      Get.snackbar("Error", response.data["message"]);
    }
  } catch (e) {
    Get.snackbar("Error", e.toString());
  } finally {
    isLoading.value = false;
  }
}
