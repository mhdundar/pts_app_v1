import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pts_app_v1/config.dart';
import '../utils/secure_storage.dart';

class PhotoService {
  static final dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));
  static const String _apiBaseUrl = AppConfig.apiBase;

  /// 🔐 Token'ı hem secure storage hem shared preferences üzerinden kontrol eder
  static Future<String?> _getToken() async {
    String? token = await SecureStorage.readAccessToken();
    if (token == null || token.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString("access_token");
    }
    return token;
  }

  /// 📥 Siparişe ait fotoğrafları getirir
  static Future<List<String>> getOrderPhotos(String orderNumber) async {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      debugPrint("⚠️ Token bulunamadı!");
      throw Exception("Yetkilendirme hatası");
    }

    try {
      final response = await dio.get(
        "/order/$orderNumber/photos",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );
      final List<dynamic> data = response.data;
      final urls = data.map<String>((path) => "$_apiBaseUrl/$path").toList();
      debugPrint("urls: ${urls[0]}");
      return urls;
    } catch (e) {
      debugPrint("❌ Fotoğraflar alınamadı: $e");
      rethrow;
    }
  }

  /// 📤 Siparişe fotoğraf yükler
  static Future<void> uploadPhotos(String orderId, List<File> files) async {
    if (files.isEmpty) return;

    final token = await _getToken();
    if (token == null || token.isEmpty) {
      debugPrint("⚠️ Token bulunamadı!");
      throw Exception("Yetkilendirme hatası");
    }

    final formData = FormData();

    for (var file in files) {
      final fileName = file.path.split('/').last;
      formData.files.add(MapEntry(
        'files',
        await MultipartFile.fromFile(file.path, filename: fileName),
      ));
    }

    try {
      debugPrint("📤 Fotoğraf yükleniyor. Order ID: $orderId");

      final response = await dio.post(
        "/order/$orderId/upload-images",
        data: formData,
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
          contentType: "multipart/form-data",
        ),
      );

      debugPrint("✅ Fotoğraf yükleme başarılı: ${response.statusCode}");
      debugPrint("Yanıt: ${response.data}");
    } catch (e, stack) {
      debugPrint("❌ Fotoğraf yükleme hatası: $e");
      debugPrint("📍 Stacktrace: $stack");
      rethrow;
    }
  }

  /// 🗑 Siparişten fotoğraf siler
  static Future<void> deletePhoto(String orderId, String filePathOrUrl) async {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      debugPrint("⚠️ Token bulunamadı!");
      throw Exception("Yetkilendirme hatası");
    }

    final fileName = filePathOrUrl.split('/').last;

    try {
      final response = await dio.delete(
        "/order/$orderId/delete-image",
        queryParameters: {
          "fileName": fileName,
        },
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      debugPrint(
          "🗑 Fotoğraf silindi: $fileName — Status: ${response.statusCode}");
    } catch (e) {
      debugPrint("❌ Fotoğraf silme hatası: $e");
      rethrow;
    }
  }
}
