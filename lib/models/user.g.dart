// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String?,
      name: json['name'] as String,
      surname: json['surname'] as String,
      company: json['company'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      passwordSalt: json['passwordSalt'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      userRole: _roleFromJson(json['userRole']),
      isOnline: json['isOnline'] as bool,
      userDeviceId: json['userDeviceId'] as String,
      lastLoginAt: DateTime.parse(json['lastLoginAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdBy: json['createdBy'] as String,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      updatedBy: json['updatedBy'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'surname': instance.surname,
      'company': instance.company,
      'username': instance.username,
      'password': instance.password,
      'passwordSalt': instance.passwordSalt,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'userRole': _roleToJson(instance.userRole),
      'isOnline': instance.isOnline,
      'userDeviceId': instance.userDeviceId,
      'lastLoginAt': instance.lastLoginAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'updatedBy': instance.updatedBy,
    };
