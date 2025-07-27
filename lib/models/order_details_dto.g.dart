// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailsDto _$OrderDetailsDtoFromJson(Map<String, dynamic> json) =>
    OrderDetailsDto(
      id: json['id'] as String?,
      orderNumber: (json['orderNumber'] as num).toInt(),
      productName: json['productName'] as String?,
      productType: json['productType'] as String?,
      processType: json['processType'] as String?,
      productWeight: (json['productWeight'] as num?)?.toDouble(),
      productCount: (json['productCount'] as num?)?.toInt(),
      orderDescription: json['orderDescription'] as String?,
      estimatedCompletionDate: json['estimatedCompletionDate'] == null
          ? null
          : DateTime.parse(json['estimatedCompletionDate'] as String),
      deliveryStatus: json['deliveryStatus'] as String?,
      deliveryDate: json['deliveryDate'] == null
          ? null
          : DateTime.parse(json['deliveryDate'] as String),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      orderImages: (json['orderImages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdByUserName: json['createdByUserName'] as String,
      updatedByUserName: json['updatedByUserName'] as String?,
      customerCompanyName: json['customerCompanyName'] as String,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$OrderDetailsDtoToJson(OrderDetailsDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'productName': instance.productName,
      'productType': instance.productType,
      'processType': instance.processType,
      'productWeight': instance.productWeight,
      'productCount': instance.productCount,
      'orderDescription': instance.orderDescription,
      'estimatedCompletionDate':
          instance.estimatedCompletionDate?.toIso8601String(),
      'deliveryStatus': instance.deliveryStatus,
      'deliveryDate': instance.deliveryDate?.toIso8601String(),
      'status': instance.status,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'orderImages': instance.orderImages,
      'createdByUserName': instance.createdByUserName,
      'updatedByUserName': instance.updatedByUserName,
      'customerCompanyName': instance.customerCompanyName,
    };
