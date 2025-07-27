// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderListDto _$OrderListDtoFromJson(Map<String, dynamic> json) => OrderListDto(
      id: json['id'] as String,
      orderNumber: (json['orderNumber'] as num).toInt(),
      productName: json['productName'] as String?,
      customerId: json['customerId'] as String?,
      companyId: json['companyId'] as String?,
      productType: json['productType'] as String?,
      processType: json['processType'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdByUserName: json['createdByUserName'] as String?,
      customerCompanyName: json['customerCompanyName'] as String?,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$OrderListDtoToJson(OrderListDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'productName': instance.productName,
      'customerId': instance.customerId,
      'companyId': instance.companyId,
      'productType': instance.productType,
      'processType': instance.processType,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'createdByUserName': instance.createdByUserName,
      'customerCompanyName': instance.customerCompanyName,
      'isActive': instance.isActive,
    };
