import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_admin_app/core/services/notification_service.dart';
import 'package:restaurent_admin_app/feature/auth/view/login_page.dart';
import 'package:restaurent_admin_app/feature/auth/view/register_page.dart';
import 'package:restaurent_admin_app/feature/auth/view/splash_page.dart';
import 'package:restaurent_admin_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ This must come first

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // ✅ Only this is needed
  );

  await PushService.init(); // ✅ Initialize FCM and local notifications

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/splash', page: () => splash_page()),
      ],
    );
  }
}
