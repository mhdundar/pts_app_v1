import 'package:dio/dio.dart';
import '../config.dart';
import '../models/company.dart';
import '../utils/secure_storage.dart';

class CompanyService {
  static final Dio _dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));

  static Future<List<Company>> getAll() async {
    final token = await SecureStorage.readAccessToken();
    final response = await _dio.get(
      "/company",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    return (response.data as List).map((e) => Company.fromJson(e)).toList();
  }

  static Future<Company?> getById(String id) async {
    final token = await SecureStorage.readAccessToken();
    final response = await _dio.get(
      "/company/$id",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    return Company.fromJson(response.data);
  }

  static Future<void> create(Company company) async {
    final token = await SecureStorage.readAccessToken();
    await _dio.post(
      "/company",
      data: company.toJson(),
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  static Future<void> update(String id, Company company) async {
    final token = await SecureStorage.readAccessToken();
    await _dio.put(
      "/company/$id",
      data: company.toJson(),
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  static Future<void> delete(String id) async {
    final token = await SecureStorage.readAccessToken();
    await _dio.delete(
      "/company/$id",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  static Future<void> setActive(String id, bool isActive) async {
    final token = await SecureStorage.readAccessToken();
    await _dio.patch(
      "/company/$id/set-active",
      queryParameters: {"isActive": isActive},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}
