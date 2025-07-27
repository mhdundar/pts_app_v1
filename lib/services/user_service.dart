import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config.dart';
import '../models/user.dart';
import '../utils/secure_storage.dart';

class UserService {
  static final Dio _dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));

  static Future<List<User>> getAll() async {
    try {
      final token = await SecureStorage.readAccessToken();
      debugPrint("📥 GET /user token: $token");

      final response = await _dio.get(
        "/user",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      debugPrint("✅ GET /user response: ${response.data}");
      return (response.data as List).map((e) => User.fromJson(e)).toList();
    } catch (e) {
      debugPrint("❌ Error in getAll: $e");
      rethrow;
    }
  }

  static Future<User?> getById(String id) async {
    try {
      final token = await SecureStorage.readAccessToken();
      debugPrint("📥 GET /user/$id token: $token");

      final response = await _dio.get(
        "/user/$id",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      debugPrint("✅ GET /user/$id response: ${response.data}");
      return User.fromJson(response.data);
    } catch (e) {
      debugPrint("❌ Error in getById: $e");
      rethrow;
    }
  }

  static Future<void> register(User user) async {
    try {
      final token = await SecureStorage.readAccessToken();
      debugPrint("📝 POST /user/register token: $token");
      debugPrint("📝 POST /user/register body: ${user.toJson()}");

      final response = await _dio.post(
        "/user/register",
        data: user.toJson(),
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      debugPrint("✅ User registered: ${response.statusCode}");
    } catch (e) {
      debugPrint("❌ Error in register: $e");
      rethrow;
    }
  }

  static Future<void> delete(String id) async {
    try {
      final token = await SecureStorage.readAccessToken();
      debugPrint("🗑 DELETE /user/$id token: $token");

      final response = await _dio.delete(
        "/user/$id",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      debugPrint("✅ User deleted: ${response.statusCode}");
    } catch (e) {
      debugPrint("❌ Error in delete: $e");
      rethrow;
    }
  }

  static Future<void> updatePassword(String id, String newPassword) async {
    try {
      final token = await SecureStorage.readAccessToken();
      debugPrint("🔑 PUT /user/$id/password token: $token");
      debugPrint("🔑 PUT /user/$id/password body: {newPassword: $newPassword}");

      final response = await _dio.put(
        "/user/$id/password",
        data: {"newPassword": newPassword},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      debugPrint("✅ Password updated: ${response.statusCode}");
    } catch (e) {
      debugPrint("❌ Error in updatePassword: $e");
      rethrow;
    }
  }

  static Future<void> setStatus(String id, bool isOnline) async {
    try {
      final token = await SecureStorage.readAccessToken();
      debugPrint("🔁 PUT /user/$id/status token: $token");
      debugPrint("🔁 PUT /user/$id/status body: {isOnline: $isOnline}");

      final response = await _dio.put(
        "/user/$id/status",
        data: {"isOnline": isOnline},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      debugPrint("✅ Status updated: ${response.statusCode}");
    } catch (e) {
      debugPrint("❌ Error in setStatus: $e");
      rethrow;
    }
  }

  static Future<void> changeRole(String id, String newRole) async {
    try {
      final token = await SecureStorage.readAccessToken();
      debugPrint("🛠 PUT /user/$id/role token: $token");
      debugPrint("🛠 PUT /user/$id/role body: {newRole: $newRole}");

      final response = await _dio.put(
        "/user/$id/role",
        data: {"newRole": newRole},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      debugPrint("✅ Role changed: ${response.statusCode}");
    } catch (e) {
      debugPrint("❌ Error in changeRole: $e");
      rethrow;
    }
  }

  static Future<void> update(User user) async {
    final token = await SecureStorage.readAccessToken();
    debugPrint("✏️ PUT /user/${user.id} token: $token");
    debugPrint("✏️ PUT /user/${user.id} body: ${user.toJson()}");

    final response = await _dio.put(
      "/user/${user.id}",
      data: user.toJson(),
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    debugPrint("✅ User updated: ${response.statusCode}");
  }
}
