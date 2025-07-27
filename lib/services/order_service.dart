import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config.dart';
import '../models/order.dart';
import '../models/order_details_dto.dart';
import '../models/order_list_dto.dart';
import '../utils/secure_storage.dart';

class OrderService {
  static final Dio _dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));

  /// ✅ ARTIK OrderListDto kullanıyor
  static Future<List<OrderListDto>> getAll() async {
    try {
      final token = await SecureStorage.readAccessToken();
      final companyId = await SecureStorage.readCompanyId();
      final userId = await SecureStorage.readUserId();
      final role = await SecureStorage.readRole();

      debugPrint(
          "TOKEN -> companyId: $companyId | userId: $userId | role: $role");
      debugPrint("📦 GET /order token: $token");

      final response = await _dio.get(
        "/order",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      debugPrint("📦 GET /order response: ${response.data}");

      if (response.data is List) {
        final list = response.data as List;
        return list
            .map((e) {
              try {
                final map = Map<String, dynamic>.from(e);
                return OrderListDto.fromJson(map);
              } catch (error, stacktrace) {
                debugPrint("⚠️ Parse hatası: $error");
                debugPrint("⚠️ JSON içeriği: $e");
                debugPrint("❌ Stacktrace: $stacktrace");
                return null;
              }
            })
            .whereType<OrderListDto>()
            .toList();
      } else {
        debugPrint("🚫 Beklenen liste formatı gelmedi.");
        return [];
      }
    } catch (e, stacktrace) {
      debugPrint("❌ Error in getAll: $e");
      debugPrint("$stacktrace");
      rethrow;
    }
  }

  static Future<Order?> getById(String id) async {
    try {
      final token = await SecureStorage.readAccessToken();
      debugPrint("📦 GET /order/$id token: $token");

      final response = await _dio.get(
        "/order/$id",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      debugPrint("📦 GET /order/$id response: ${response.data}");
      return Order.fromJson(response.data);
    } catch (e) {
      debugPrint("❌ Error in getById: $e");
      rethrow;
    }
  }

  static Future<OrderDetailsDto?> getDetails(String id) async {
    try {
      final token = await SecureStorage.readAccessToken();
      debugPrint("📦 GET /order/$id/details token: $token");

      final response = await _dio.get(
        "/order/$id/details",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      debugPrint("📦 GET /order/$id/details response: ${response.data}");
      return OrderDetailsDto.fromJson(response.data);
    } catch (e) {
      debugPrint("❌ Error in getDetails: $e");
      rethrow;
    }
  }

  static Future<void> create(Order order) async {
    try {
      final token = await SecureStorage.readAccessToken();
      debugPrint("📤 POST /order token: $token");
      debugPrint("📤 POST /order body: ${order.toJson()}");

      final response = await _dio.post(
        "/order",
        data: order.toJson(),
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      debugPrint("✅ Order created: ${response.data}");
    } catch (e) {
      debugPrint("❌ Error in create: $e");
      rethrow;
    }
  }

  static Future<void> update(String id, Order order) async {
    try {
      final token = await SecureStorage.readAccessToken();
      debugPrint("✏️ PUT /order/$id token: $token");
      debugPrint("✏️ PUT /order/$id body: ${order.toJson()}");

      final response = await _dio.put(
        "/order/$id",
        data: order.toJson(),
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      debugPrint("✅ Order updated: ${response.data}");
    } catch (e) {
      debugPrint("❌ Error in update: $e");
      rethrow;
    }
  }

  static Future<void> delete(String id) async {
    try {
      final token = await SecureStorage.readAccessToken();
      debugPrint("🗑 DELETE /order/$id token: $token");

      final response = await _dio.delete(
        "/order/$id",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      debugPrint("✅ Order deleted: ${response.statusCode}");
    } catch (e) {
      debugPrint("❌ Error in delete: $e");
      rethrow;
    }
  }

  static Future<void> updateStatus(String id, String newStatus) async {
    try {
      final token = await SecureStorage.readAccessToken();
      debugPrint("🔄 PATCH /order/$id/status token: $token");
      debugPrint("🔄 PATCH /order/$id/status data: $newStatus");

      final response = await _dio.patch(
        "/order/$id/status",
        data: '"$newStatus"',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      debugPrint("✅ Status updated: ${response.statusCode}");
    } catch (e) {
      debugPrint("❌ Error in updateStatus: $e");
      rethrow;
    }
  }
}
