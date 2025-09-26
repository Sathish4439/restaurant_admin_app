import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:restaurent_admin_app/core/theme/app_color.dart';
import 'package:restaurent_admin_app/core/utils/common_wid.dart';
import 'package:restaurent_admin_app/feature/home/controller/admin_controllers/admin_menu_controller.dart';
import 'package:restaurent_admin_app/feature/home/view/admin_view/add_menu_page.dart';
import 'package:restaurent_admin_app/feature/home/view/widget/widgets.dart';

class MenuManagementPage extends StatefulWidget {
  const MenuManagementPage({super.key});

  @override
  State<MenuManagementPage> createState() => _MenuManagementPageState();
}

class _MenuManagementPageState extends State<MenuManagementPage> {
  var controller = Get.put(AdminMenuController());
  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
         fetchData();
    }); 
  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  floatingActionButton: FloatingActionButton(
    backgroundColor: AppColors.secondary,
    onPressed: () {
      Get.to(() => MenuItemFormPage());
    },
    child: const Icon(
      Icons.add,
      color: AppColors.textWhite,
    ),
  ),
  body: ListView(
    shrinkWrap: true,
    children: [
      SizedBox(
        height: getHeight(0.05),
        child: Obx(
          () => ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 10),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              var item = controller.categories[index];
              return categoryTabWid(item: item);
            },
            separatorBuilder: (context, index) => const SizedBox(),
            itemCount: controller.categories.length,
          ),
        ),
      ),
      const Divider(),
      Obx(() => controller.menuList.isEmpty
          ? SizedBox(
              height: MediaQuery.of(context).size.height * 0.6, // take most of screen
              child: const Center(
                child: Text(
                  "Add Menu's",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // avoid nested scroll issue
              padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
              itemBuilder: (context, index) {
                var item = controller.menuList[index];
                return MenucardWid(
                  menu: item,
                  onDelete: () {
                    controller.deleteMenu(item.id.toString());
                    fetchData();
                  },
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: controller.menuList.length,
            )),
    ],
  ),
);
}

  void fetchData() async {
    controller.fetchMenu();
  }
}
