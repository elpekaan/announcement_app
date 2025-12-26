import 'package:ciu_announcement/core/constants/api_endpoints.dart';
import 'package:ciu_announcement/core/errors/exceptions/server_exception.dart';
import 'package:ciu_announcement/core/errors/exceptions/unauthorized_exception.dart';
import 'package:ciu_announcement/core/network/api_client.dart';
import 'package:ciu_announcement/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ciu_announcement/features/auth/data/models/user_model.dart';
import 'package:ciu_announcement/features/auth/domain/enums/user_role.dart';
import 'package:dio/dio.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final token = response.data['data']['token'] as String;
      _apiClient.setAuthToken(token);

      return UserModel.fromJson(response.data['data']['user']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException('Email veya şifre hatalı');
      }
      throw ServerException(
        e.message ?? 'Sunucu hatası',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'role' : role,
        },
      );

      final token = response.data['data']['token'] as String;
      _apiClient.setAuthToken(token);

      return UserModel.fromJson(response.data['data']['user']);
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? 'Registration failed',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.dio.post(ApiEndpoints.logout);
      _apiClient.clearAuthToken();
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? 'Çıkış başarısız',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.me);
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException('Oturum süresi dolmuş');
      }
      throw ServerException(
        e.message ?? 'Kullanıcı bilgisi alınamadı',
        statusCode: e.response?.statusCode,
      );
    }
  }
}