class Product {
  final int id;
  final int pondId;
  final String name;
  final String description;
  final double price;
  final String category;
  final int stock;
  final String? imageUrl;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.pondId,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.stock,
    this.imageUrl,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] as num).toInt(),
      pondId: (json['pond_id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      stock: (json['stock'] as num).toInt(),
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pond_id': pondId,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'stock': stock,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class ProductResponse {
  final List<Product> data;
  final int currentPage;
  final int perPage;
  final int total;

  ProductResponse({
    required this.data,
    required this.currentPage,
    required this.perPage,
    required this.total,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      data: (json['data'] as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: (json['current_page'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'current_page': currentPage,
      'per_page': perPage,
      'total': total,
    };
  }
}
