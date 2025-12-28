import 'package:dio/dio.dart';
import 'package:ciu_announcement/core/network/api_client.dart';
import 'package:ciu_announcement/core/errors/exceptions/server_exception.dart';
import 'package:ciu_announcement/core/errors/exceptions/unauthorized_exception.dart';
import 'package:ciu_announcement/features/auth/data/models/user_model.dart';
import 'package:ciu_announcement/features/auth/domain/enums/user_role.dart';

class UserRemoteDataSource {
  final ApiClient _apiClient;

  UserRemoteDataSource(this._apiClient);

  Future<List<UserModel>> getManageableUsers() async {
    try {
      final response = await _apiClient.dio.get('/users');

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => UserModel.fromJson(json)).toList();
      }

      throw ServerException(response.data['message'] ?? 'Kullanıcılar alınamadı');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Oturum süresi doldu');
      }
      if (e.response?.statusCode == 403) {
        throw ServerException(e.response?.data['message'] ?? 'Yetkiniz yok');
      }
      throw ServerException(e.message ?? 'Bağlantı hatası');
    }
  }

  Future<UserModel> getById(int id) async {
    try {
      final response = await _apiClient.dio.get('/users/$id');

      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      }

      throw ServerException(response.data['message'] ?? 'Kullanıcı bulunamadı');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Oturum süresi doldu');
      }
      if (e.response?.statusCode == 404) {
        throw ServerException('Kullanıcı bulunamadı');
      }
      throw ServerException(e.message ?? 'Bağlantı hatası');
    }
  }

  Future<UserModel> create({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required UserRole role,
  }) async {
    try {
      final response = await _apiClient.dio.post('/users', data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'role': role.apiValue,
      });

      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      }

      throw ServerException(response.data['message'] ?? 'Kullanıcı oluşturulamadı');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Oturum süresi doldu');
      }
      if (e.response?.statusCode == 403) {
        throw ServerException(e.response?.data['message'] ?? 'Yetkiniz yok');
      }
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'];
        if (errors != null && errors['email'] != null) {
          throw ServerException(errors['email'][0]);
        }
        if (errors != null && errors['password'] != null) {
          throw ServerException(errors['password'][0]);
        }
        throw ServerException(e.response?.data['message'] ?? 'Validasyon hatası');
      }
      throw ServerException(e.message ?? 'Bağlantı hatası');
    }
  }

  Future<UserModel> update({
    required int id,
    String? name,
    String? email,
    String? password,
    String? passwordConfirmation,
    UserRole? role,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;
      if (password != null && password.isNotEmpty) {
        data['password'] = password;
        data['password_confirmation'] = passwordConfirmation;
      }
      if (role != null) data['role'] = role.apiValue;

      final response = await _apiClient.dio.put('/users/$id', data: data);

      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      }

      throw ServerException(response.data['message'] ?? 'Kullanıcı güncellenemedi');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Oturum süresi doldu');
      }
      if (e.response?.statusCode == 403) {
        throw ServerException(e.response?.data['message'] ?? 'Yetkiniz yok');
      }
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'];
        if (errors != null && errors['email'] != null) {
          throw ServerException(errors['email'][0]);
        }
        throw ServerException(e.response?.data['message'] ?? 'Validasyon hatası');
      }
      throw ServerException(e.message ?? 'Bağlantı hatası');
    }
  }

  Future<void> delete(int id) async {
    try {
      final response = await _apiClient.dio.delete('/users/$id');

      if (response.data['success'] != true) {
        throw ServerException(response.data['message'] ?? 'Kullanıcı silinemedi');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Oturum süresi doldu');
      }
      if (e.response?.statusCode == 403) {
        throw ServerException(e.response?.data['message'] ?? 'Yetkiniz yok');
      }
      throw ServerException(e.message ?? 'Bağlantı hatası');
    }
  }

  Future<List<UserRole>> getCreatableRoles() async {
    try {
      final response = await _apiClient.dio.get('/users/creatable-roles');

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((r) => UserRole.fromString(r['value'])).toList();
      }

      throw ServerException('Roller alınamadı');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Oturum süresi doldu');
      }
      throw ServerException(e.message ?? 'Bağlantı hatası');
    }
  }
}
