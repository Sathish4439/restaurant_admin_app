import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WaiterHomePage extends StatefulWidget {
  const WaiterHomePage({super.key});

  @override
  State<WaiterHomePage> createState() => _WaiterHomePageState();
}

class _WaiterHomePageState extends State<WaiterHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("WaiterHomePage"),
    );
  }
}