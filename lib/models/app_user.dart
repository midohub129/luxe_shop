class AppUser {
  final String id;
  final String email;
  final String? fullName;
  final String? phoneNumber;
  final String? city;
  final String? address;
  final String? avatarUrl;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.email,
    this.fullName,
    this.phoneNumber,
    this.city,
    this.address,
    this.avatarUrl,
    required this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'city': city,
      'address': address,
      'avatar_url': avatarUrl,
    };
  }

  AppUser copyWith({
    String? fullName,
    String? phoneNumber,
    String? city,
    String? address,
    String? avatarUrl,
  }) {
    return AppUser(
      id: id,
      email: email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      city: city ?? this.city,
      address: address ?? this.address,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt,
    );
  }
}
