import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  final String? id;
  final int? orderNumber;
  final String? productName;
  final String customerId;
  final String companyId;
  final List<String> orderImages;
  final double? productWeight;
  final int? productCount;
  final String? productType;
  final String? processType;
  final String status;
  final String? orderDescription;
  final DateTime? estimatedCompletionDate;
  final String? deliveryStatus;
  final DateTime? deliveryDate;
  final bool isActive;
  final DateTime createdAt;
  final String createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;

  Order({
    this.id,
    this.orderNumber,
    this.productName,
    required this.customerId,
    required this.companyId,
    required this.orderImages,
    this.productWeight,
    this.productCount,
    this.productType,
    this.processType,
    required this.status,
    this.orderDescription,
    this.estimatedCompletionDate,
    this.deliveryStatus,
    this.deliveryDate,
    required this.isActive,
    required this.createdAt,
    required this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
