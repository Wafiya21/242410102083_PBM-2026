class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final String createdAt;
  final String updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  String get formattedPrice {
    final num p = price;
    final parts = p.toStringAsFixed(0).split('');
    final result = StringBuffer();
    int counter = 0;
    for (int i = parts.length - 1; i >= 0; i--) {
      if (counter > 0 && counter % 3 == 0) {
        result.write('.');
      }
      result.write(parts[i]);
      counter++;
    }
    return 'Rp ${result.toString().split('').reversed.join()}';
  }
}
