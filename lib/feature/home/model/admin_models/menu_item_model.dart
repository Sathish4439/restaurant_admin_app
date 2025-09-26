class MenuItem {
  final int id;
  final String name;
  final String? description;
  final String price;
  final String? category;
  final String? imageUrl;
  final DateTime createdAt;
  final List<MenuOption> options;
  final List<OrderItem> orderItems;
  final String? notes;

  MenuItem({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.category,
    this.imageUrl,
    required this.createdAt,
    this.options = const [],
    this.orderItems = const [],
    this.notes,
  });

  /// ✅ Factory constructor to create object from JSON
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? "NA",
      description: json['description'] ?? "NA",
      price: (json['price']) ?? "NA",
      category: json['category'] ?? "NA",
      imageUrl: json['imageUrl'] ?? "NA",
      createdAt: DateTime.parse(json['createdAt']),
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => MenuOption.fromJson(e))
              .toList() ??
          [],
      orderItems: (json['orderItems'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e))
              .toList() ??
          [],
      notes: json['notes'] ?? "NA",
    );
  }

  /// ✅ Convert object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'options': options.map((e) => e.toJson()).toList(),
      'orderItems': orderItems.map((e) => e.toJson()).toList(),
      'notes': notes,
    };
  }

  static final nullMenuItem =
      MenuItem(id: 0, name: 'NA', price: "NA", createdAt: DateTime.now());
}

class MenuOption {
  final int id;
  final String name;
  final String extraPrice;

  // Constructor with named parameters
  MenuOption({required this.id, required this.name, required this.extraPrice});

  // Factory constructor from JSON
  factory MenuOption.fromJson(Map<String, dynamic> json) {
    return MenuOption(
      id: json['id'] ?? 0,
      name: json['name'] ?? "NA",
      extraPrice: json['extraPrice']?.toString() ?? "NA",
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'extraPrice': extraPrice,
      };

  // Null object for fallback
  static final nullMenuOption = MenuOption(id: 0, name: 'NA', extraPrice: "NA");
}

class OrderItem {
  final int id;
  final int quantity;

  OrderItem({required this.id, required this.quantity});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      quantity: json['quantity'] ?? "NA",
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'quantity': quantity,
      };

  static final nullOrderItem = OrderItem(id: 0, quantity: 0);
}
