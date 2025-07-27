import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _rememberMeKey = 'remember_me';

  static Future<void> writeRememberMe(bool value) async {
    await _storage.write(key: _rememberMeKey, value: value.toString());
    debugPrint("📌 RememberMe kaydedildi: $value");
  }

  static Future<bool> readRememberMe() async {
    final val = await _storage.read(key: _rememberMeKey);
    debugPrint("📤 RememberMe okundu: $val");
    return val == 'true';
  }

  static Future<void> writeAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
    debugPrint("📌 AccessToken kaydedildi: ${token.substring(0, 20)}...");
  }

  static Future<void> writeRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
    debugPrint("📌 RefreshToken kaydedildi: ${token.substring(0, 20)}...");
  }

  static Future<String?> readAccessToken() async {
    final token = await _storage.read(key: _accessTokenKey);
    debugPrint("📤 AccessToken okundu: ${token?.substring(0, 20)}...");
    return token;
  }

  static Future<String?> readRefreshToken() async {
    final token = await _storage.read(key: _refreshTokenKey);
    debugPrint("📤 RefreshToken okundu: ${token?.substring(0, 20)}...");
    return token;
  }

  static Future<void> clear() async {
    debugPrint("🧹 SecureStorage temizleniyor...");
    await _storage.deleteAll();
    debugPrint("✅ SecureStorage temizlendi.");
  }

  static Future<String?> readUserId() async {
    final token = await readAccessToken();
    return _decodeClaim(token,
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier');
  }

  static Future<String?> readUsername() async {
    final token = await readAccessToken();
    return _decodeClaim(
        token, 'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name');
  }

  static Future<String?> readRole() async {
    final token = await readAccessToken();
    return _decodeClaim(
        token, 'http://schemas.microsoft.com/ws/2008/06/identity/claims/role');
  }

  static Future<String?> readCompanyId() async {
    final token = await readAccessToken();
    return _decodeClaim(token, 'companyId');
  }

  static String? _decodeClaim(String? token, String claimKey) {
    if (token == null || token.isEmpty) return null;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(payload));
      final Map<String, dynamic> data = json.decode(decoded);
      final value = data[claimKey]?.toString();
      debugPrint("🔍 Token'dan '$claimKey' alanı çözüldü: $value");
      return value;
    } catch (e) {
      debugPrint("❌ Token decode hatası: $e");
      return null;
    }
  }
}
