class OrderModel {
  final int id;
  final int tableId;
  final double total;
  final String? paymentMethod;
  final String status;
  final DateTime createdAt;
  final List<OrderItemModel> items;
  final TableModel table;

  OrderModel({
    required this.id,
    required this.tableId,
    required this.total,
    this.paymentMethod,
    required this.status,
    required this.createdAt,
    required this.items,
    required this.table,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      tableId: json['tableId'] ?? 0,
      total: _parseDouble(json['total']),
      paymentMethod: json['paymentMethod'],
      status: json['status'] ?? 'PENDING',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItemModel.fromJson(item))
              .toList() ??
          [],
      table: TableModel.fromJson(json['table'] ?? {}),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tableId': tableId,
      'total': total,
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'table': table.toJson(),
    };
  }
}

class OrderItemModel {
  final int id;
  final int menuItemId;
  final int quantity;
  final String? notes;
  final MenuItemModel menuItem;

  OrderItemModel({
    required this.id,
    required this.menuItemId,
    required this.quantity,
    this.notes,
    required this.menuItem,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? 0,
      menuItemId: json['menuItemId'] ?? 0,
      quantity: json['quantity'] ?? 1,
      notes: json['notes'],
      menuItem: MenuItemModel.fromJson(json['menuItem'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menuItemId': menuItemId,
      'quantity': quantity,
      'notes': notes,
      'menuItem': menuItem.toJson(),
    };
  }
}

class TableModel {
  final int id;
  final String name;
  final String status;

  TableModel({
    required this.id,
    required this.name,
    required this.status,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      status: json['status'] ?? 'VACANT',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
    };
  }
}

class MenuItemModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String? category;
  final String? imageUrl;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.category,
    this.imageUrl,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: OrderModel._parseDouble(json['price']),
      category: json['category'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
    };
  }
}

class OrderStatsModel {
  final int totalOrders;
  final double totalRevenue;
  final int pendingOrders;
  final int preparingOrders;
  final int servedOrders;
  final int cancelledOrders;
  final Map<String, int> ordersByStatus;

  OrderStatsModel({
    required this.totalOrders,
    required this.totalRevenue,
    required this.pendingOrders,
    required this.preparingOrders,
    required this.servedOrders,
    required this.cancelledOrders,
    required this.ordersByStatus,
  });

  factory OrderStatsModel.fromJson(Map<String, dynamic> json) {
    return OrderStatsModel(
      totalOrders: json['totalOrders'] ?? 0,
      totalRevenue: OrderModel._parseDouble(json['totalRevenue']),
      pendingOrders: json['pendingOrders'] ?? 0,
      preparingOrders: json['preparingOrders'] ?? 0,
      servedOrders: json['servedOrders'] ?? 0,
      cancelledOrders: json['cancelledOrders'] ?? 0,
      ordersByStatus: Map<String, int>.from(json['ordersByStatus'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalOrders': totalOrders,
      'totalRevenue': totalRevenue,
      'pendingOrders': pendingOrders,
      'preparingOrders': preparingOrders,
      'servedOrders': servedOrders,
      'cancelledOrders': cancelledOrders,
      'ordersByStatus': ordersByStatus,
    };
  }
}
