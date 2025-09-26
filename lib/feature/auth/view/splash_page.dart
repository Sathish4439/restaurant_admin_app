import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_admin_app/feature/auth/controller/authController.dart';

class splash_page extends StatefulWidget {
  const splash_page({super.key});

  @override
  State<splash_page> createState() => _splash_pageState();
}

class _splash_pageState extends State<splash_page> {
  var authController = Get.put(AuthController());

  @override
  void initState() {
    // TODO: implement initState
    authController.checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
