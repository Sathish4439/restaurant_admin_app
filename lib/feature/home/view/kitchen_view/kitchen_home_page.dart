import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class KitchenHomePage extends StatefulWidget {
  const KitchenHomePage({super.key});

  @override
  State<KitchenHomePage> createState() => _KitchenHomePageState();
}

class _KitchenHomePageState extends State<KitchenHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("KitchenHomePage"),
    );
  }
}