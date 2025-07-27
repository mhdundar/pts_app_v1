import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pts_app_v1/constants/order_statuses.dart';

class JwtHelper {
  static String? getUserId(String token) {
    try {
      final decoded = JwtDecoder.decode(token);
      return decoded['UserId'] ?? decoded['userId'];
    } catch (_) {
      return null;
    }
  }

  static String? getCompanyId(String token) {
    try {
      final decoded = JwtDecoder.decode(token);
      return decoded['CompanyId'] ?? decoded['companyId'];
    } catch (_) {
      return null;
    }
  }

  static List<UserRole> getRoles(String token) {
    try {
      final decoded = JwtDecoder.decode(token);
      debugPrint("🧩 JWT decoded: $decoded");

      final possibleKeys = [
        'role',
        'roles',
        'http://schemas.microsoft.com/ws/2008/06/identity/claims/role'
      ];
      dynamic roles;

      for (var key in possibleKeys) {
        if (decoded.containsKey(key)) {
          roles = decoded[key];
          debugPrint("🔍 JWT roles raw ($key): $roles");
          break;
        }
      }

      if (roles is List) {
        final parsedRoles = roles.map((r) {
          final matched = UserRole.values.firstWhere(
            (e) => e.name.toLowerCase() == r.toString().toLowerCase(),
            orElse: () {
              debugPrint(
                  "⚠️ Eşleşmeyen rol: $r, varsayılan olarak employee atanacak");
              return UserRole.employee;
            },
          );
          debugPrint("✅ Eşleşen rol: $matched");
          return matched;
        }).toList();
        return parsedRoles;
      }

      if (roles is String) {
        final matched = UserRole.values.firstWhere(
          (e) => e.name.toLowerCase() == roles.toLowerCase(),
          orElse: () {
            debugPrint(
                "⚠️ Tekil eşleşmeyen rol: $roles, varsayılan olarak employee atanacak");
            return UserRole.employee;
          },
        );
        debugPrint("✅ Tekil eşleşen rol: $matched");
        return [matched];
      }

      debugPrint("🚫 Rol alanı boş ya da geçersiz formatta");
      return [];
    } catch (e) {
      debugPrint("❌ JWT çözümleme hatası: $e");
      return [];
    }
  }

  static bool isExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  static DateTime? getExpiryDate(String token) {
    try {
      return JwtDecoder.getExpirationDate(token);
    } catch (_) {
      return null;
    }
  }

  static Map<String, dynamic> decode(String token) {
    return JwtDecoder.decode(token);
  }
}
