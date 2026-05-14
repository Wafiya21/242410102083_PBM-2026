import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/product.dart';
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = 'https://task.itprojects.web.id';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: 'auth_token');
  }

  static Map<String, String> _headers(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<UserModel?> login(String nim, String password) async {
    try {
      final url = Uri.parse('$baseUrl/api/auth/login');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': nim,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true) {
          final user = UserModel.fromJson(body['data']);
          await saveToken(user.token);
          return user;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Product>> getProducts() async {
    try {
      final token = await getToken();
      if (token == null) return [];

      final url = Uri.parse('$baseUrl/api/products');
      final response = await http.get(url, headers: _headers(token));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true) {
          final List data = body['data']['products'] ?? [];
          return data.map((e) => Product.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> createProduct({
    required String name,
    required int price,
    required String description,
  }) async {
    try {
      final token = await getToken();
      if (token == null) return false;

      final url = Uri.parse('$baseUrl/api/products');
      final response = await http.post(
        url,
        headers: _headers(token),
        body: jsonEncode({
          'name': name,
          'price': price,
          'description': description,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        return body['success'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteProduct(int productId) async {
    try {
      final token = await getToken();
      if (token == null) return false;

      final url = Uri.parse('$baseUrl/api/products/$productId');
      final response = await http.delete(url, headers: _headers(token));

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> submitTask({
    required String name,
    required int price,
    required String description,
    required String githubUrl,
  }) async {
    try {
      final token = await getToken();
      if (token == null) return false;

      final url = Uri.parse('$baseUrl/api/products/submit');
      final response = await http.post(
        url,
        headers: _headers(token),
        body: jsonEncode({
          'name': name,
          'price': price,
          'description': description,
          'github_url': githubUrl,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        return body['success'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
