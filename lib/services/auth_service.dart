import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pts_app_v1/config.dart';
import 'package:pts_app_v1/main.dart';
import 'package:pts_app_v1/utils/secure_storage.dart';

class AuthService {
  static String? accessTokenTemp;
  static String? refreshTokenTemp;
  static bool _refreshInProgress = false;
  static bool _isLoggingOut = false;

  static final dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));

  static Future<Map<String, dynamic>?> login(String username, String password,
      {bool rememberMe = false}) async {
    debugPrint("🔐 Attempting login with username: $username");
    try {
      final response = await dio.post(
        "/auth/login",
        data: {
          "username": username,
          "password": password,
        },
      );
      debugPrint("✅ Login response: ${response.data}");

      if (response.statusCode == 200) {
        final accessToken = response.data['accessToken'];
        final refreshToken = response.data['refreshToken'];

        accessTokenTemp = accessToken;
        refreshTokenTemp = refreshToken;

        // 💾 Her zaman yaz:
        await SecureStorage.writeAccessToken(accessToken);
        await SecureStorage.writeRefreshToken(refreshToken);
        await SecureStorage.writeRememberMe(rememberMe); // ✅ BU SATIR ŞART

        debugPrint(
            "🔐 Giriş sonrası accessToken: ${accessToken.substring(0, 20)}...");
        debugPrint(
            "🔐 Giriş sonrası refreshToken: ${refreshToken.substring(0, 20)}...");
        debugPrint("💾 RememberMe değeri kaydedildi: $rememberMe");

        return response.data;
      }
    } on DioException catch (e) {
      debugPrint("❌ Login error: ${e.response?.data ?? e.message}");
    }
    return null;
  }

  static Future<bool> logout() async {
    _isLoggingOut = true;
    try {
      debugPrint("🚪 Logout başlatıldı");

      String? token = await SecureStorage.readAccessToken();
      debugPrint("🔑 Token from SecureStorage: $token");

      if (token == null || token.isEmpty) {
        debugPrint("⚠️ Logout için geçerli token yok");
        return false;
      }

      final response = await dio.post(
        "/auth/logout",
        options: Options(headers: {
          "Authorization": "Bearer $token",
        }),
      );

      debugPrint(
          "✅ Logout response: ${response.statusCode} - ${response.data}");

      await SecureStorage.clear();
      accessTokenTemp = null;
      refreshTokenTemp = null;
      dio.interceptors.clear();

      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil("/login", (route) => false);

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e, stack) {
      debugPrint("❌ Logout error: $e");
      debugPrint("📍 Stacktrace: $stack");
      return false;
    } finally {
      _isLoggingOut = false;
    }
  }

  static Future<bool> refreshToken() async {
    if (_refreshInProgress || _isLoggingOut) {
      debugPrint(
          "🔁 Zaten refresh işlemi sürüyor veya çıkış yapılıyor, atlanıyor.");
      return false;
    }

    _refreshInProgress = true;

    try {
      final refreshToken = await SecureStorage.readRefreshToken();
      debugPrint(
          "🔄 Mevcut refreshToken: ${refreshToken?.substring(0, 20)}...");

      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint("⚠️ Refresh token yok");
        return false;
      }

      final response = await dio.post(
        "/auth/refresh-token",
        data: {"refreshToken": refreshToken},
      );

      debugPrint(
          "🔄 Refresh response: ${response.statusCode} - ${response.data}");

      if (response.statusCode == 200) {
        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];

        await SecureStorage.writeAccessToken(newAccessToken);
        await SecureStorage.writeRefreshToken(newRefreshToken);

        accessTokenTemp = newAccessToken;
        refreshTokenTemp = newRefreshToken;

        debugPrint("✅ Yeni accessToken: ${newAccessToken.substring(0, 20)}...");
        debugPrint(
            "✅ Yeni refreshToken: ${newRefreshToken.substring(0, 20)}...");
        return true;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        debugPrint(
            "⚠️ Refresh isteği de 401 verdi, interceptor logout yapacak zaten");
      } else {
        debugPrint("❌ Token yenileme hatası: $e");
      }
    } catch (e) {
      debugPrint("❌ Refresh sırasında genel hata: $e");
    } finally {
      _refreshInProgress = false;
    }

    return false;
  }

  static void setupInterceptors() {
    dio.interceptors.clear();

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = accessTokenTemp ?? await SecureStorage.readAccessToken();
        debugPrint(
            "📤 Request için accessToken kullanılıyor: ${token?.substring(0, 20)}...");
        if (token != null && token.isNotEmpty) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (_isLoggingOut) {
          debugPrint("🚫 Logout sırasında hata geldi, refresh yapılmayacak.");
          return handler.reject(error);
        }

        if (error.response?.statusCode == 401) {
          debugPrint("⛔ 401 geldi, refresh deneniyor...");

          final success = await refreshToken();
          if (success) {
            final retryToken = await SecureStorage.readAccessToken();
            final opts = error.requestOptions;

            debugPrint("🔁 İstek tekrar gönderiliyor: ${opts.path}");

            try {
              final retryResponse = await dio.request(
                opts.path,
                data: opts.data,
                queryParameters: opts.queryParameters,
                options: Options(
                  method: opts.method,
                  headers: {
                    ...opts.headers,
                    "Authorization": "Bearer $retryToken",
                  },
                  contentType: opts.contentType,
                  responseType: opts.responseType,
                  followRedirects: opts.followRedirects,
                  receiveDataWhenStatusError: opts.receiveDataWhenStatusError,
                  extra: opts.extra,
                  validateStatus: opts.validateStatus,
                ),
              );

              return handler.resolve(retryResponse);
            } catch (e) {
              debugPrint("❌ Retry isteğinde hata: $e");
              return handler.reject(error);
            }
          } else {
            debugPrint("🚫 Refresh başarısız, çıkış yapılıyor.");
            await logout();
            return handler.reject(error);
          }
        }

        return handler.next(error);
      },
    ));
  }
}
