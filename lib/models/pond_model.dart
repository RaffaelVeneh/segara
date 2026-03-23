class Pond {
  final int id;
  final int sellerId;
  final String name;
  final String description;
  final double area;
  final String location;
  final String type;
  final DateTime createdAt;

  Pond({
    required this.id,
    required this.sellerId,
    required this.name,
    required this.description,
    required this.area,
    required this.location,
    required this.type,
    required this.createdAt,
  });

  Pond copyWith({
    int? id,
    int? sellerId,
    String? name,
    String? description,
    double? area,
    String? location,
    String? type,
    DateTime? createdAt,
  }) {
    return Pond(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      name: name ?? this.name,
      description: description ?? this.description,
      area: area ?? this.area,
      location: location ?? this.location,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Pond.fromJson(Map<String, dynamic> json) {
    return Pond(
      id: (json['id'] as num).toInt(),
      sellerId: (json['seller_id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      area: (json['area'] as num).toDouble(),
      location: json['location'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seller_id': sellerId,
      'name': name,
      'description': description,
      'area': area,
      'location': location,
      'type': type,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class PondResponse {
  final List<Pond> data;
  final int currentPage;
  final int perPage;
  final int total;

  PondResponse({
    required this.data,
    required this.currentPage,
    required this.perPage,
    required this.total,
  });

  factory PondResponse.fromJson(Map<String, dynamic> json) {
    return PondResponse(
      data: (json['data'] as List)
          .map((e) => Pond.fromJson(e as Map<String, dynamic>))
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
