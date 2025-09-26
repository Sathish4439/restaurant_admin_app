import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurent_admin_app/core/theme/app_color.dart';
import 'package:restaurent_admin_app/core/utils/common_wid.dart';
import 'package:restaurent_admin_app/feature/home/controller/admin_controllers/admin_menu_controller.dart';
import 'package:restaurent_admin_app/feature/home/model/admin_models/menu_item_model.dart';
import 'package:restaurent_admin_app/feature/home/view/admin_view/admin_home_page.dart';

class MenuItemFormPage extends StatefulWidget {
  final MenuItem? menuItem;

  const MenuItemFormPage({super.key, this.menuItem});

  @override
  State<MenuItemFormPage> createState() => _MenuItemFormPageState();
}

class _MenuItemFormPageState extends State<MenuItemFormPage> {
  final _formKey = GlobalKey<FormState>();
  var controller = Get.put(AdminMenuController());

  File? _pickedImage;

  @override
  void initState() {
    super.initState();

     controller.idController = TextEditingController();
    controller.nameController= TextEditingController();
    controller.descriptionController= TextEditingController();
    controller.priceController = TextEditingController();
    controller.categoryController = TextEditingController();
    controller.imageUrlController = TextEditingController();
    controller.createdAtController = TextEditingController();
    controller.notesController = TextEditingController();
 
    WidgetsBinding.instance.addPostFrameCallback((_) {
           setData();
      
    });
  
  }

  @override
  void dispose() {
    controller.idController.dispose();
    controller.nameController.dispose();
    controller.descriptionController.dispose();
    controller.priceController.dispose();
    controller.categoryController.dispose();
    controller.imageUrlController.dispose();
    controller.createdAtController.dispose();
    controller.notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);

      // Upload the image (async)
      await uploadImage(file, controller.isLoading, controller.uploadedUrl);

      setState(() {
        _pickedImage = file;
        controller.imageUrlController.text = pickedFile.path.split('/').last;
      });

      print("controller.uploadedUrl: ${controller.uploadedUrl}");
    }
  }

  void _addOrEditOption({MenuOption? option, int? index}) {
    final nameCtrl = TextEditingController(text: option?.name ?? "");
    final extraPriceCtrl =
        TextEditingController(text: option?.extraPrice ?? "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(option == null ? "Add Option" : "Edit Option",
                    style: const TextStyle(fontSize: 18)),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "Option Name"),
                ),
                TextField(
                  controller: extraPriceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Extra Price"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final newOption = MenuOption(
                      id: option?.id ?? controller.options.length + 1,
                      name: nameCtrl.text,
                      extraPrice: extraPriceCtrl.text,
                    );

                    setState(() {
                      if (index != null) {
                        controller.options[index] = newOption;
                      } else {
                        controller.options.add(newOption);
                      }
                    });

                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUpdate = widget.menuItem != null;

    return Scaffold(
      appBar:CustomerAppbar(title: isUpdate ? "Update Menu Item" : "Create Menu Item"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _pickedImage != null
                    ? Image.file(_pickedImage!, height: 120, width: 120)
                    : (controller.imageUrlController.text.isNotEmpty
                        ? Image.network(controller.imageUrlController.text,
                            height: 120, width: 120,
                            errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image, size: 80);
                          })
                        : Container(
                            height: 120,
                            width: 120,
                            color: Colors.grey[300],
                            child: const Icon(Icons.add_a_photo, size: 50),
                          )),
              ),
              CustomTextField(
                  labelText: "Categoty",
                  controller: controller.categoryController),
               Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                  ),
                  width: double.infinity,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isDense: true,
                      value: controller.selectedCategory.value.isEmpty
                          ? null
                          : controller.selectedCategory.value,
                      hint: const Text("Select Category"),
                      items: controller.categories
                          .map((cat) => DropdownMenuItem<String>(
                                value: cat,
                                child: Text(cat),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.selectedCategory.value = value;
                          
                        }
                      },
                    ),
                  ),
                )
              ,
              CustomTextField(
                  labelText: "Name", controller: controller.nameController),
              CustomTextField(
                  labelText: "Description",
                  controller: controller.descriptionController),
              CustomTextField(
                  labelText: "Price", controller: controller.priceController),
              const SizedBox(height: 10),
              CustomTextField(
                  labelText: "Notes", controller: controller.notesController),
              const SizedBox(height: 20),
              _buildOptionsSection(),
              const SizedBox(height: 30),
              CustomButton(
                  text: isUpdate ? "Update" : "Create",
                  onTap: () {
                    isUpdate
                        ? controller.updateMenu(widget.menuItem!.id.toString())
                        : controller.createMenu();

                    Get.to(()=> const AdminHomePage());
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Options",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () {
                  _addOrEditOption();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.secondary),
                  child: const Text("Add",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textWhite)),
                ),
              )
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.options.length,
            itemBuilder: (context, index) {
              final option = controller.options[index];
              return ListTile(
                title: Text("${option.name} - Rs: ${option.extraPrice}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.secondary),
                      onPressed: () =>
                          _addOrEditOption(option: option, index: index),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.delete, color: AppColors.secondary),
                      onPressed: () {
                        setState(() => controller.options.removeAt(index));
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void setData() {
    if (controller.categories.isNotEmpty) {
      controller.selectedCategory.value =
          controller.categories.first; // set default value
    }

    final item = widget.menuItem;

    controller.idController =
        TextEditingController(text: item?.id.toString() ?? "");
    controller.nameController = TextEditingController(text: item?.name ?? "");
    controller.descriptionController =
        TextEditingController(text: item?.description ?? "");
    controller.priceController = TextEditingController(text: item?.price ?? "");
    controller.categoryController =
        TextEditingController(text: item?.category ?? "");
    controller.imageUrlController =
        TextEditingController(text: item?.imageUrl ?? "");
    controller.createdAtController =
        TextEditingController(text: item?.createdAt?.toIso8601String() ?? "");
    controller.notesController = TextEditingController(text: item?.notes ?? "");

    controller.options = item?.options ?? [];
    controller.orderItems = item?.orderItems ?? [];
  }
}
