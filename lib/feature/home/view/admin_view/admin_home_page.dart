import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_admin_app/core/theme/app_color.dart';
import 'package:restaurent_admin_app/core/theme/app_font.dart';
import 'package:restaurent_admin_app/feature/home/controller/admin_controllers/admin_home_controller.dart';
import 'package:restaurent_admin_app/feature/home/view/admin_view/analytics_page.dart';
import 'package:restaurent_admin_app/feature/home/view/admin_view/menu_page.dart';
import 'package:restaurent_admin_app/feature/home/view/admin_view/order_page.dart';
import 'package:restaurent_admin_app/feature/home/view/admin_view/staff_page.dart';
import 'package:restaurent_admin_app/feature/home/view/admin_view/table_page.dart';
import 'package:restaurent_admin_app/feature/home/view/widget/widgets.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  var controller = Get.put(AdminHomeController());

  @override
  void initState() {
    // TODO: implement initState

    controller.LoadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Obx(() => CustomeDrawerWid(
            controller: controller,
            name: controller.currentUserName.value,
            role: controller.currentUserRole.value,
          )),
      appBar: AppBar(
        title: Text('Management',
            style: AppFonts.textStyle(
              fontSize: AppFonts.extraLarge,
            )),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          GridView.builder(
            shrinkWrap: true,
            itemCount: controller.gridData.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              var data = controller.gridData[index];
              return GridData(
                onTap: () {
                  if (data == "Menu") {
                    Get.to(() => const MenuManagementPage());
                  } else if (data == "Order") {
                    Get.to(() => const OrderManagementPage());
                  } else if (data == "Staff") {
                    Get.to(() => const StaffManagementPage());
                  } else if (data == "Table") {
                    Get.to(() => const TableManagementPage());
                  } else {
                    Get.to(() => const AnalyticsScreen());
                  }
                },
                title: controller.gridData[index],
              );
            },
          )
        ],
      ),
    );
  }
}
