import 'package:dio/dio.dart';
import 'package:ciu_announcement/core/network/api_client.dart';
import 'package:ciu_announcement/core/storage/secure_storage.dart';
import 'package:ciu_announcement/core/errors/exceptions/server_exception.dart';
import 'package:ciu_announcement/core/errors/exceptions/unauthorized_exception.dart';
import 'package:ciu_announcement/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ciu_announcement/features/auth/data/models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.data['success'] == true) {
        final token = response.data['data']['token'];
        await SecureStorage.saveToken(token);

        return UserModel.fromJson(response.data['data']['user']);
      }

      throw ServerException(response.data['message'] ?? 'Giriş başarısız');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Email veya şifre hatalı');
      }
      if (e.response?.statusCode == 422) {
        final message = e.response?.data['message'] ?? 'Validasyon hatası';
        throw ServerException(message);
      }
      throw ServerException(e.message ?? 'Bağlantı hatası');
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password, String role) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        },
      );

      if (response.data['success'] == true) {
        final token = response.data['data']['token'];
        await SecureStorage.saveToken(token);

        return UserModel.fromJson(response.data['data']['user']);
      }

      throw ServerException(response.data['message'] ?? 'Kayıt başarısız');
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'];
        if (errors != null && errors['email'] != null) {
          throw ServerException(errors['email'][0]);
        }
        final message = e.response?.data['message'] ?? 'Validasyon hatası';
        throw ServerException(message);
      }
      throw ServerException(e.message ?? 'Bağlantı hatası');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.dio.post('/auth/logout');
      await SecureStorage.clearAll();
    } on DioException catch (e) {
      await SecureStorage.clearAll();
      if (e.response?.statusCode == 401) {
        return;
      }
      throw ServerException(e.message ?? 'Çıkış hatası');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.dio.get('/auth/me');

      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']['user']);
      }

      throw ServerException('Kullanıcı bilgisi alınamadı');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await SecureStorage.clearAll();
        throw UnauthorizedException('Oturum süresi doldu');
      }
      throw ServerException(e.message ?? 'Bağlantı hatası');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await SecureStorage.getToken();
    return token != null;
  }
}