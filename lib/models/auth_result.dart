import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'auth_result.g.dart';

@JsonSerializable()
class AuthResult {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final User user;

  AuthResult({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.user,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) =>
      _$AuthResultFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResultToJson(this);
}
