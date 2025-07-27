import 'package:json_annotation/json_annotation.dart';

part 'order_list_dto.g.dart';

@JsonSerializable()
class OrderListDto {
  final String id;
  final int orderNumber;
  final String? productName;
  final String? customerId;
  final String? companyId;
  final String? productType;
  final String? processType;
  final String status;
  final DateTime createdAt;
  final String? createdByUserName;
  final String? customerCompanyName;

  // ✅ Eksik olan alan eklendi:
  final bool isActive;

  OrderListDto({
    required this.id,
    required this.orderNumber,
    this.productName,
    this.customerId,
    this.companyId,
    this.productType,
    this.processType,
    required this.status,
    required this.createdAt,
    this.createdByUserName,
    this.customerCompanyName,
    required this.isActive, // ✅ eklendi
  });

  factory OrderListDto.fromJson(Map<String, dynamic> json) =>
      _$OrderListDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderListDtoToJson(this);
}
