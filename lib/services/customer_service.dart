import 'package:dio/dio.dart';
import '../config.dart';
import '../utils/secure_storage.dart';
import '../models/customer.dart';

class CustomerService {
  static final Dio _dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));

  static Future<List<Customer>> getAll() async {
    final token = await SecureStorage.readAccessToken();
    final response = await _dio.get(
      "/customer",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    return (response.data as List).map((e) => Customer.fromJson(e)).toList();
  }

  static Future<Customer> getById(String id) async {
    final token = await SecureStorage.readAccessToken();
    final response = await _dio.get(
      "/customer/$id",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    return Customer.fromJson(response.data);
  }

  static Future<void> create(Customer customer) async {
    final token = await SecureStorage.readAccessToken();
    await _dio.post(
      "/customer",
      data: customer.toJson(),
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  static Future<void> update(String id, Customer customer) async {
    final token = await SecureStorage.readAccessToken();
    await _dio.put(
      "/customer/$id",
      data: customer.toJson(),
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  static Future<void> delete(String id) async {
    final token = await SecureStorage.readAccessToken();
    await _dio.delete(
      "/customer/$id",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}
