class User {
  final String id;
  final String name;
  final String email;
  final String whatsapp;
  final String role;
  final String? profilePicture;
  final String? address;
  final bool isVerified;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.whatsapp,
    required this.role,
    this.profilePicture,
    this.address,
    this.isVerified = false,
  });

  String get phone => whatsapp;

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? whatsapp,
    String? role,
    String? profilePicture,
    String? address,
    bool? isVerified,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      whatsapp: whatsapp ?? this.whatsapp,
      role: role ?? this.role,
      profilePicture: profilePicture ?? this.profilePicture,
      address: address ?? this.address,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      whatsapp: (json['whatsapp'] ?? json['phone'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      profilePicture: (json['profilePicture'] ?? json['profile_picture'])
          ?.toString(),
      address: (json['address'] ?? json['alamat'])?.toString(),
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'whatsapp': whatsapp,
      'role': role,
      'profilePicture': profilePicture,
      'address': address,
      'isVerified': isVerified,
    };
  }

  @override
  String toString() =>
      'User(id: $id, name: $name, email: $email, whatsapp: $whatsapp, role: $role)';
}

class AuthResponse {
  final String token;
  final User user;
  final String? message;

  AuthResponse({required this.token, required this.user, this.message});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'user': user.toJson(), 'message': message};
  }
}

class OtpRequest {
  final String phone;
  final String role;

  OtpRequest({required this.phone, required this.role});

  factory OtpRequest.fromJson(Map<String, dynamic> json) {
    return OtpRequest(
      phone: json['phone'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'phone': phone, 'role': role};
  }
}

class OtpVerifyRequest {
  final String phone;
  final String otp;
  final String role;

  OtpVerifyRequest({
    required this.phone,
    required this.otp,
    required this.role,
  });

  factory OtpVerifyRequest.fromJson(Map<String, dynamic> json) {
    return OtpVerifyRequest(
      phone: json['phone'] as String,
      otp: json['otp'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'phone': phone, 'otp': otp, 'role': role};
  }
}
