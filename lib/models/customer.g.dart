// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      customerId: json['_id'] as String?,
      customerCompanyCode: json['customerCompanyCode'] as String,
      customerCompanyName: json['customerCompanyName'] as String,
      customerAuthorizedPerson: json['customerAuthorizedPerson'] as String,
      customerContactInfo: json['customerContactInfo'] as String,
      customerAddress: json['customerAddress'] as String,
      customerEmail: json['customerEmail'] as String,
      customerPhoneNumber: json['customerPhoneNumber'] as String,
      customerOrderHistory: (json['customerOrderHistory'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      customerIsActive: json['customerIsActive'] as bool,
      customerCreatedAt: DateTime.parse(json['customerCreatedAt'] as String),
      customerCreatedBy: json['customerCreatedBy'] as String,
      customerUpdatedAt: json['customerUpdatedAt'] == null
          ? null
          : DateTime.parse(json['customerUpdatedAt'] as String),
      customerUpdatedBy: json['customerUpdatedBy'] as String?,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      '_id': instance.customerId,
      'customerCompanyCode': instance.customerCompanyCode,
      'customerCompanyName': instance.customerCompanyName,
      'customerAuthorizedPerson': instance.customerAuthorizedPerson,
      'customerContactInfo': instance.customerContactInfo,
      'customerAddress': instance.customerAddress,
      'customerEmail': instance.customerEmail,
      'customerPhoneNumber': instance.customerPhoneNumber,
      'customerOrderHistory': instance.customerOrderHistory,
      'customerIsActive': instance.customerIsActive,
      'customerCreatedAt': instance.customerCreatedAt.toIso8601String(),
      'customerCreatedBy': instance.customerCreatedBy,
      'customerUpdatedAt': instance.customerUpdatedAt?.toIso8601String(),
      'customerUpdatedBy': instance.customerUpdatedBy,
    };
