import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();
  static const _configuredBaseUrl = String.fromEnvironment('API_BASE_URL');
  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'auth_user_id';
  static const _fullNameKey = 'auth_full_name';
  static const _emailKey = 'auth_email';

  String? _token;
  String? _userId;
  String? _fullName;
  String? _email;

  String get baseUrl {
    if (_configuredBaseUrl.isNotEmpty) {
      return _configuredBaseUrl.replaceAll(RegExp(r'/+$'), '');
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080/api';
    }
    return 'http://localhost:8080/api';
  }

  Future<void> initialize() async {
    final preferences = await SharedPreferences.getInstance();
    _token = preferences.getString(_tokenKey);
    _userId = preferences.getString(_userIdKey);
    _fullName = preferences.getString(_fullNameKey);
    _email = preferences.getString(_emailKey);
  }

  bool get isAuthenticated => _token != null && _token!.isNotEmpty;
  String get currentUserId => _userId ?? '';
  String get currentUserName => _fullName?.trim().isNotEmpty == true
      ? _fullName!
      : 'User';
  String get currentUserEmail => _email ?? '';

  Future<bool> checkConnection() async {
    final result = await get('/health', authenticated: false);
    return result is Map<String, dynamic> && result['status'] == 'UP';
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final result = await post('/auth/login', body: {
      'email': email,
      'password': password,
    }, authenticated: false);
    final user = result as Map<String, dynamic>;
    await _saveSession(user);
    return user;
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    final result = await post('/auth/register', body: {
      'fullName': fullName,
      'email': email,
      'password': password,
      if (phoneNumber != null && phoneNumber.isNotEmpty)
        'phoneNumber': phoneNumber,
    }, authenticated: false);
    final user = result as Map<String, dynamic>;
    await _saveSession(user);
    return user;
  }

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    await post('/auth/reset-password', body: {
      'email': email,
      'newPassword': newPassword,
    }, authenticated: false);
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _fullName = null;
    _email = null;
    final preferences = await SharedPreferences.getInstance();
    await Future.wait([
      preferences.remove(_tokenKey),
      preferences.remove(_userIdKey),
      preferences.remove(_fullNameKey),
      preferences.remove(_emailKey),
    ]);
  }

  Future<dynamic> get(String path, {bool authenticated = true}) =>
      _send('GET', path, authenticated: authenticated);

  Future<dynamic> post(
    String path, {
    Object? body,
    bool authenticated = true,
  }) => _send('POST', path, body: body, authenticated: authenticated);

  Future<dynamic> put(String path, {Object? body}) =>
      _send('PUT', path, body: body);

  Future<void> delete(String path) async {
    await _send('DELETE', path);
  }

  Future<dynamic> _send(
    String method,
    String path, {
    Object? body,
    bool authenticated = true,
  }) async {
    if (authenticated && !isAuthenticated) {
      throw const ApiException('Please log in first.', statusCode: 401);
    }

    final uri = Uri.parse('$baseUrl${path.startsWith('/') ? path : '/$path'}');
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (authenticated) 'Authorization': 'Bearer $_token',
    };

    try {
      final encodedBody = body == null ? null : jsonEncode(body);
      late final http.Response response;
      switch (method) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response = await http.post(uri, headers: headers, body: encodedBody);
          break;
        case 'PUT':
          response = await http.put(uri, headers: headers, body: encodedBody);
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        default:
          throw ArgumentError('Unsupported HTTP method: $method');
      }

      final decoded = response.body.isEmpty ? null : jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      }
      final message = decoded is Map<String, dynamic>
          ? decoded['message']?.toString()
          : null;
      throw ApiException(
        message ?? 'Request failed (${response.statusCode}).',
        statusCode: response.statusCode,
      );
    } on ApiException {
      rethrow;
    } on FormatException {
      throw const ApiException('The server returned an invalid response.');
    } on http.ClientException {
      throw ApiException('Cannot connect to the API at $baseUrl.');
    }
  }

  Future<void> _saveSession(Map<String, dynamic> user) async {
    final token = user['token']?.toString();
    if (token == null || token.isEmpty) {
      throw const ApiException(
        'The server did not return an authentication token.',
      );
    }
    _token = token;
    _userId = user['userId']?.toString();
    _fullName = user['fullName']?.toString();
    _email = user['email']?.toString();
    final preferences = await SharedPreferences.getInstance();
    await Future.wait([
      preferences.setString(_tokenKey, token),
      preferences.setString(_userIdKey, _userId ?? ''),
      preferences.setString(_fullNameKey, _fullName ?? ''),
      preferences.setString(_emailKey, _email ?? ''),
    ]);
  }
}
