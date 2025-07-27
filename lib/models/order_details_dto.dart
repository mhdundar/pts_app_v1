import 'package:json_annotation/json_annotation.dart';

part 'order_details_dto.g.dart';

@JsonSerializable()
class OrderDetailsDto {
  final String? id;
  final int orderNumber;
  final String? productName;
  final String? productType;
  final String? processType;
  final double? productWeight;
  final int? productCount;
  final String? orderDescription;
  final DateTime? estimatedCompletionDate;
  final String? deliveryStatus;
  final DateTime? deliveryDate;
  final String status;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> orderImages;
  final String createdByUserName;
  final String? updatedByUserName;
  final String customerCompanyName;

  OrderDetailsDto({
    this.id,
    required this.orderNumber,
    this.productName,
    this.productType,
    this.processType,
    this.productWeight,
    this.productCount,
    this.orderDescription,
    this.estimatedCompletionDate,
    this.deliveryStatus,
    this.deliveryDate,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    required this.orderImages,
    required this.createdByUserName,
    this.updatedByUserName,
    required this.customerCompanyName,
    required this.isActive, // ✅ eklendi
  });

  factory OrderDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailsDtoToJson(this);

  OrderDetailsDto copyWith({
    String? status,
  }) {
    return OrderDetailsDto(
      id: id,
      orderNumber: orderNumber,
      productName: productName,
      productType: productType,
      processType: processType,
      productWeight: productWeight,
      productCount: productCount,
      orderDescription: orderDescription,
      estimatedCompletionDate: estimatedCompletionDate,
      deliveryStatus: deliveryStatus,
      deliveryDate: deliveryDate,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      orderImages: orderImages,
      createdByUserName: createdByUserName,
      updatedByUserName: updatedByUserName,
      customerCompanyName: customerCompanyName,
      isActive: isActive, // ✅ eklendi
    );
  }
}
