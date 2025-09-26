import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:restaurent_admin_app/core/theme/app_color.dart';
import 'package:restaurent_admin_app/core/utils/common_wid.dart';
import 'package:restaurent_admin_app/feature/home/controller/admin_controllers/admin_menu_controller.dart';
import 'package:restaurent_admin_app/feature/home/controller/admin_controllers/admin_user_controller.dart';
import 'package:restaurent_admin_app/feature/home/model/admin_models/user_model.dart';
import 'package:restaurent_admin_app/feature/home/view/admin_view/add_menu_page.dart';
import 'package:restaurent_admin_app/feature/home/view/widget/widgets.dart';

class StaffManagementPage extends StatefulWidget {
  const StaffManagementPage({super.key});

  @override
  State<StaffManagementPage> createState() => _StaffManagementPageState();
}

class _StaffManagementPageState extends State<StaffManagementPage> {
  final controller = Get.put(AdminUserController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        onPressed: () {
          showUserBottomSheet(context);
        },
        child: const Icon(
          Icons.add,
          color: AppColors.textWhite,
        ),
      ),
      appBar: CustomerAppbar(
        title: "Staff Management",
      ),
      body: Obx(
        () => controller.loadUser.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final user = controller.listofUser[index];
                  return UserWid(
                    user: user,
                    onEdit: () {
                      showUserBottomSheet(context, user: user);
                    },
                    onDelete: () {
                      showDeleteTableDialog(
                          tableName: user.name,
                          onSubmit: () {
                            controller.deleteUser(user.id);
                          });
                    },
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: controller.listofUser.length,
              ),
      ),
    );
  }

  void fetchData() {
    controller.fetchUser();
  }

  Future<void> showUserBottomSheet(BuildContext context, {User? user}) async {
    var controller = Get.put(AdminUserController());

    // ✅ Pre-fill data when updating
    if (user != null) {
      controller.nameController.text = user.name;
      controller.emailController.text = user.email;
      controller.selectedRole.value = user.role;
      controller.selectedImage.value =
          user.imageUrl != null ? File(user.imageUrl!) : null;
    }

    await Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                user == null ? "Add User" : "Update User", // ✅ dynamic title
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Image Picker
              Obx(() {
                return GestureDetector(
                  onTap: () {
                    controller.pickImage();
                  },
                  child: SizedBox(
                      height: 80,
                      width: 80,
                      child: controller.selectedImage.value == null
                          ? const Icon(Icons.camera_alt, size: 32)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: GestureDetector(
                                onTap: () {
                                  controller.pickImage();
                                },
                                child: Image.file(
                                  controller.selectedImage.value!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )),
                );
              }),

              const SizedBox(height: 16),

              // Role Dropdown
              Obx(() {
                return Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: controller.selectedRole.value.isNotEmpty
                          ? controller.selectedRole.value
                          : null,
                      hint: const Text("Select Role"),
                      items: const [
                        DropdownMenuItem(value: "ADMIN", child: Text("ADMIN")),
                        DropdownMenuItem(
                            value: "WAITER", child: Text("WAITER")),
                        DropdownMenuItem(
                            value: "KITCHEN", child: Text("KITCHEN")),
                      ],
                      onChanged: (value) {
                        controller.selectedRole.value = value!;
                      },
                    ),
                  ),
                );
              }),

              // Name Field
              CustomTextField(
                controller: controller.nameController,
                labelText: "Name",
              ),
              const SizedBox(height: 12),

              // Email Field
              CustomTextField(
                controller: controller.emailController,
                labelText: "Email",
              ),
              const SizedBox(height: 12),

              // Password Field (only when creating)
              if (user == null) ...[
                Obx(
                  () => CustomTextField(
                    controller: controller.passwordController,
                    labelText: "Password",
                    obscureText: !controller.showPassword.value,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.showPassword.value =
                            !controller.showPassword.value;
                      },
                      icon: Icon(
                        controller.showPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              const SizedBox(height: 20),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    width: getWidth(0.4),
                    height: getHeight(0.05),
                    text: "Cancel",
                    onTap: () => Get.back(),
                  ),
                  CustomButton(
                    width: getWidth(0.4),
                    height: getHeight(0.05),
                    text: user == null ? "Save" : "Update", // ✅ dynamic button
                    onTap: () {
                      if (user == null) {
                        if (controller.selectedImage.value!.path.isNotEmpty) {
                          controller.addUser();
                        } else {
                          ToastHelper.showError("Please select the image");
                        } // create
                      } else {
                        controller.updateUser(user.id); // update
                      }
                      Navigator.pop(context);
                      controller.fetchUser();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );

    Get.delete<AdminUserController>();
  }
}
