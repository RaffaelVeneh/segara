class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String? profilePicture;
  final String? address;
  final bool isVerified;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.profilePicture,
    this.address,
    this.isVerified = false,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? profilePicture,
    String? address,
    bool? isVerified,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profilePicture: profilePicture ?? this.profilePicture,
      address: address ?? this.address,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      profilePicture: json['profilePicture'] as String?,
      address: json['address'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'profilePicture': profilePicture,
      'address': address,
      'isVerified': isVerified,
    };
  }

  @override
  String toString() =>
      'User(id: $id, name: $name, email: $email, phone: $phone, role: $role)';
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
