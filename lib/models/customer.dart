import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  @JsonKey(name: '_id')
  final String? customerId;

  final String customerCompanyCode;
  final String customerCompanyName;
  final String customerAuthorizedPerson;
  final String customerContactInfo;
  final String customerAddress;
  final String customerEmail;
  final String customerPhoneNumber;
  final List<String> customerOrderHistory;
  final bool customerIsActive;
  final DateTime customerCreatedAt;
  final String customerCreatedBy;
  final DateTime? customerUpdatedAt;
  final String? customerUpdatedBy;

  Customer({
    this.customerId,
    required this.customerCompanyCode,
    required this.customerCompanyName,
    required this.customerAuthorizedPerson,
    required this.customerContactInfo,
    required this.customerAddress,
    required this.customerEmail,
    required this.customerPhoneNumber,
    required this.customerOrderHistory,
    required this.customerIsActive,
    required this.customerCreatedAt,
    required this.customerCreatedBy,
    this.customerUpdatedAt,
    this.customerUpdatedBy,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
