import 'package:restaurent_admin_app/feature/home/model/admin_models/order_model.dart';

class CartModel {
  final int id;
  final int customerId;
  final int menuItemId;
  final int quantity;
  final String? notes;
  final MenuItemModel menuItem;
  final DateTime createdAt;

  CartModel({
    required this.id,
    required this.customerId,
    required this.menuItemId,
    required this.quantity,
    this.notes,
    required this.menuItem,
    required this.createdAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: _parseInt(json['id']),
      customerId: _parseInt(json['customerId']),
      menuItemId: _parseInt(json['menuItemId']),
      quantity: _parseInt(json['quantity']),
      notes: json['notes'],
      menuItem: MenuItemModel.fromJson(json['menuItem'] ?? {}),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'menuItemId': menuItemId,
      'quantity': quantity,
      'notes': notes,
      'menuItem': menuItem.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

class CartResponse {
  final bool success;
  final String message;
  final List<CartModel> data;

  CartResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      success: json['success'] == true,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => CartModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}
