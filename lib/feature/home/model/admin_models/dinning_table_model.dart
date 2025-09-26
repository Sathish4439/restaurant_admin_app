class DiningTable {
  final int id;
  final String name;
  final String status;
  final DateTime createdAt;

  DiningTable({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
  });

  // Convert JSON to DiningTable object
  factory DiningTable.fromJson(Map<String, dynamic> json) {
    return DiningTable(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'NA',
      status: json['status'] ?? 'VACANT',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Convert DiningTable object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Optional: a default empty table
  static final empty = DiningTable(
    id: 0,
    name: 'NA',
    status: 'NA',
    createdAt: DateTime.now(),
  );
}
