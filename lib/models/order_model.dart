class OrderItem {
  final int productId;
  final String productName;
  final double price;
  final int quantity;
  final double subtotal;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: (json['product_id'] as num).toInt(),
      productName: json['product_name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }
}

class Order {
  final int id;
  final int buyerId;
  final String status;
  final double totalPrice;
  final String deliveryAddress;
  final DateTime createdAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.buyerId,
    required this.status,
    required this.totalPrice,
    required this.deliveryAddress,
    required this.createdAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: (json['id'] as num).toInt(),
      buyerId: (json['buyer_id'] as num).toInt(),
      status: json['status'] as String,
      totalPrice: (json['total_price'] as num).toDouble(),
      deliveryAddress: json['delivery_address'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      items:
          (json['items'] as List?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyer_id': buyerId,
      'status': status,
      'total_price': totalPrice,
      'delivery_address': deliveryAddress,
      'created_at': createdAt.toIso8601String(),
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class OrderCreateRequest {
  final List<OrderItem> items;
  final String deliveryAddress;
  final String? notes;

  OrderCreateRequest({
    required this.items,
    required this.deliveryAddress,
    this.notes,
  });

  factory OrderCreateRequest.fromJson(Map<String, dynamic> json) {
    return OrderCreateRequest(
      items: (json['items'] as List)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      deliveryAddress: json['delivery_address'] as String,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'delivery_address': deliveryAddress,
      'notes': notes,
    };
  }
}

class OrderResponse {
  final List<Order> data;
  final int currentPage;
  final int perPage;
  final int total;

  OrderResponse({
    required this.data,
    required this.currentPage,
    required this.perPage,
    required this.total,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      data: (json['data'] as List)
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
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
