import 'package:json_annotation/json_annotation.dart';

part 'company.g.dart';

@JsonSerializable()
class Company {
  final String? id;
  final String companyName;
  final String companyCode;
  final DateTime lsd;
  final DateTime led;
  final bool isActive;
  final DateTime createdAt;
  final String createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;

  Company({
    this.id,
    required this.companyName,
    required this.companyCode,
    required this.lsd,
    required this.led,
    required this.isActive,
    required this.createdAt,
    required this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}
