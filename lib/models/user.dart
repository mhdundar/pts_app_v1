import 'package:json_annotation/json_annotation.dart';
import 'package:pts_app_v1/constants/order_statuses.dart'; // UserRole enum burada tanımlıysa

part 'user.g.dart';

@JsonSerializable()
class User {
  final String? id;
  final String name;
  final String surname;
  final String company;
  final String username;
  final String password;
  final String passwordSalt;
  final String email;
  final String phoneNumber;

  @JsonKey(fromJson: _roleFromJson, toJson: _roleToJson)
  final UserRole userRole;

  final bool isOnline;
  final String userDeviceId;
  final DateTime lastLoginAt;
  final DateTime createdAt;
  final String createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;

  User({
    this.id,
    required this.name,
    required this.surname,
    required this.company,
    required this.username,
    required this.password,
    required this.passwordSalt,
    required this.email,
    required this.phoneNumber,
    required this.userRole,
    required this.isOnline,
    required this.userDeviceId,
    required this.lastLoginAt,
    required this.createdAt,
    required this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

// 🔁 Enum dönüşüm yardımcıları
UserRole _roleFromJson(dynamic role) {
  if (role is int) {
    return UserRole.values[role];
  }
  // String olarak gelirse yine destekle
  if (role is String) {
    final index = int.tryParse(role);
    if (index != null) return UserRole.values[index];

    return UserRole.values.firstWhere(
      (e) => e.name.toLowerCase() == role.toLowerCase(),
      orElse: () => UserRole.employee,
    );
  }

  return UserRole.customer;
}

String _roleToJson(UserRole role) => role.name;
