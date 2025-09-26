import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:restaurent_admin_app/core/services/endpoint.dart';
import 'package:restaurent_admin_app/core/theme/app_color.dart';
import 'package:restaurent_admin_app/core/theme/app_font.dart';
import 'package:restaurent_admin_app/core/utils/common_wid.dart';
import 'package:restaurent_admin_app/feature/home/controller/admin_controllers/admin_home_controller.dart';
import 'package:restaurent_admin_app/feature/home/controller/admin_controllers/admin_table_controller.dart';
import 'package:restaurent_admin_app/feature/home/model/admin_models/dinning_table_model.dart';
import 'package:restaurent_admin_app/feature/home/model/admin_models/menu_item_model.dart';
import 'package:restaurent_admin_app/feature/home/model/admin_models/user_model.dart';
import 'package:restaurent_admin_app/feature/home/view/admin_view/add_menu_page.dart';

class GridData extends StatelessWidget {
  final String title;
  void Function() onTap;
  GridData({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border)),
        child: Center(
          child: Text(title,
              style: AppFonts.textStyle(
                fontSize: AppFonts.extraLarge,
              )),
        ),
      ),
    );
  }
}

class CustomeDrawerWid extends StatelessWidget {
  final String name;
  final String role;
  const CustomeDrawerWid({
    super.key,
    required this.controller,
    required this.name,
    required this.role,
  });

  final AdminHomeController controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.background,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.background,
                  radius: 30,
                  child: Icon(Icons.person),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => Text(
                          'Role: ${controller.currentUserRole}',
                          style: AppFonts.textStyle(
                            fontSize: AppFonts.large,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    SizedBox(height: 8),
                    Obx(() => Text(
                          'Name: ${controller.currentUserName}',
                          style: AppFonts.textStyle(
                            fontSize: AppFonts.large,
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.redAccent),
                  title: Text(
                    'Logout',
                    style: AppFonts.textStyle(
                      fontSize: AppFonts.large,
                      color: Colors.redAccent,
                    ),
                  ),
                  onTap: () {
                    controller.logout(); // Call your logout method
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class categoryTabWid extends StatelessWidget {
  final String item;
  const categoryTabWid({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border)),
      child: Center(
        child: Text(item,
            style: AppFonts.textStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppFonts.large,
                color: AppColors.textWhite)),
      ),
    );
  }
}

class MenucardWid extends StatelessWidget {
  final MenuItem menu;
  final void Function()? onDelete;

  const MenucardWid({super.key, required this.menu, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
//  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        loadImage(menu.imageUrl)

        // Image with fallback
        ,
        SizedBox(width: getWidth(0.05)),

        // Menu details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${menu.name}",
                  style: AppFonts.textStyle(
                      fontSize: AppFonts.large, color: AppColors.textPrimary)),
              Text("Rs: ${menu.price}",
                  style: AppFonts.textStyle(
                      fontSize: AppFonts.large, color: AppColors.textPrimary)),
              Text("Category: ${menu.category ?? ''}",
                  style: AppFonts.textStyle(
                      fontSize: AppFonts.large, color: AppColors.textPrimary)),
            ],
          ),
        ),

        // Action buttons
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                Get.to(() => MenuItemFormPage(
                      menuItem: menu,
                    ));
              },
              icon: Icon(Icons.edit, color: AppColors.secondary),
            ),
            IconButton(
              onPressed: onDelete,
              icon: Icon(Icons.delete, color: AppColors.secondary),
            ),
          ],
        ),
      ]),
    );
  }
}

// ignore: must_be_immutable
class TableWid extends StatelessWidget {
  final DiningTable table;
  final void Function()? onUpdate;
  final void Function()? onDelete;
  TableWid({super.key, required this.table, this.onDelete, this.onUpdate});

  final controller = Get.put(AdminTableController());

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'VACANT':
        return Colors.green;
      case 'OCCUPIED':
        return Colors.red;
      case 'CLEANING':
        return Colors.orange;
      default:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onUpdate,
      child: Card(
        color: AppColors.textWhite,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Row: ID + Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ID: ${table.id}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: _getStatusColor(table.status),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        table.status,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Center Table Name
              Expanded(
                child: Center(
                  child: Text(
                    table.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Bottom Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      await controller.downloadQR(table.id.toString());
                    },
                    child: Row(
                      children: const [
                        Text(
                          "Download QR",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.download, size: 16, color: Colors.blue),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserWid extends StatelessWidget {
  final User user;
  final void Function()? onEdit;
  final void Function()? onDelete;

  const UserWid({
    super.key,
    required this.user,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// User image
          SizedBox(
            height: 50,
            width: 50,
            child: loadImage(user.imageUrl),
          ),
          const SizedBox(width: 12),

          /// User details (Expanded to avoid overflow)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Role: ${user.role}",
                  style: AppFonts.textStyle(
                    fontSize: AppFonts.large,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Name: ${user.name}",
                  style: AppFonts.textStyle(
                    fontSize: AppFonts.large,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Email: ${user.email}",
                  overflow: TextOverflow.ellipsis, // ✅ Prevents overflow
                  maxLines: 1, // ✅ Keeps it in a single line
                  style: AppFonts.textStyle(
                    fontSize: AppFonts.large,
                  ),
                ),
              ],
            ),
          ),

          /// Action buttons
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: onEdit,
                child: const Icon(
                  Icons.edit,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: onDelete,
                child: const Icon(
                  Icons.delete,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void showDeleteTableDialog({
  required String tableName, // Name of the table to show in dialog
  required Function() onSubmit, // Called when user confirms
}) {
  Get.defaultDialog(
    title: 'Confirm Delete',
    middleText: 'Are you sure you want to delete "$tableName"?',
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomButton(
            width: getWidth(0.30),
            height: getHeight(0.03),
            text: "Cancel",
            onTap: () {
              Get.back(); // close dialog
            },
          ),
          CustomButton(
            width: getWidth(0.30),
            height: getHeight(0.03),
            text: "Delete",
            onTap: () {
              onSubmit(); // trigger deletion
              Get.back(); // close dialog
            },
          ),
        ],
      )
    ],
  );
}
