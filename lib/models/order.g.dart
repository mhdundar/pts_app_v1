// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: json['id'] as String?,
      orderNumber: (json['orderNumber'] as num).toInt(),
      productName: json['productName'] as String?,
      customerId: json['customerId'] as String,
      companyId: json['companyId'] as String,
      orderImages: (json['orderImages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      productWeight: (json['productWeight'] as num?)?.toDouble(),
      productCount: (json['productCount'] as num?)?.toInt(),
      productType: json['productType'] as String?,
      processType: json['processType'] as String?,
      status: json['status'] as String,
      orderDescription: json['orderDescription'] as String?,
      estimatedCompletionDate: json['estimatedCompletionDate'] == null
          ? null
          : DateTime.parse(json['estimatedCompletionDate'] as String),
      deliveryStatus: json['deliveryStatus'] as String?,
      deliveryDate: json['deliveryDate'] == null
          ? null
          : DateTime.parse(json['deliveryDate'] as String),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdBy: json['createdBy'] as String,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      updatedBy: json['updatedBy'] as String?,
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'productName': instance.productName,
      'customerId': instance.customerId,
      'companyId': instance.companyId,
      'orderImages': instance.orderImages,
      'productWeight': instance.productWeight,
      'productCount': instance.productCount,
      'productType': instance.productType,
      'processType': instance.processType,
      'status': instance.status,
      'orderDescription': instance.orderDescription,
      'estimatedCompletionDate':
          instance.estimatedCompletionDate?.toIso8601String(),
      'deliveryStatus': instance.deliveryStatus,
      'deliveryDate': instance.deliveryDate?.toIso8601String(),
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'updatedBy': instance.updatedBy,
    };
