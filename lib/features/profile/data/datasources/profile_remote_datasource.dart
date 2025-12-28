import 'package:dio/dio.dart';
import 'package:ciu_announcement/core/network/api_client.dart';
import 'package:ciu_announcement/core/storage/secure_storage.dart';
import 'package:ciu_announcement/core/errors/exceptions/server_exception.dart';
import 'package:ciu_announcement/core/errors/exceptions/unauthorized_exception.dart';
import 'package:ciu_announcement/features/auth/data/models/user_model.dart';

class ProfileRemoteDataSource {
  final ApiClient _apiClient;

  ProfileRemoteDataSource(this._apiClient);

  Future<UserModel> getProfile() async {
    try {
      final response = await _apiClient.dio.get('/profile');

      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      }

      throw ServerException(response.data['message'] ?? 'Profil alınamadı');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Oturum süresi doldu');
      }
      throw ServerException(e.message ?? 'Bağlantı hatası');
    }
  }

  Future<UserModel> updateProfile({
    String? name,
    String? email,
    String? currentPassword,
    String? newPassword,
    String? passwordConfirmation,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;
      if (currentPassword != null && newPassword != null && newPassword.isNotEmpty) {
        data['current_password'] = currentPassword;
        data['password'] = newPassword;
        data['password_confirmation'] = passwordConfirmation;
      }

      final response = await _apiClient.dio.put('/profile', data: data);

      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      }

      throw ServerException(response.data['message'] ?? 'Profil güncellenemedi');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Oturum süresi doldu');
      }
      if (e.response?.statusCode == 422) {
        throw ServerException(e.response?.data['message'] ?? 'Validasyon hatası');
      }
      throw ServerException(e.message ?? 'Bağlantı hatası');
    }
  }

  Future<void> deleteAccount(String password) async {
    try {
      final response = await _apiClient.dio.delete('/profile', data: {
        'password': password,
      });

      if (response.data['success'] == true) {
        await SecureStorage.clearAll();
        return;
      }

      throw ServerException(response.data['message'] ?? 'Hesap silinemedi');
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        throw ServerException(e.response?.data['message'] ?? 'Şifre hatalı');
      }
      throw ServerException(e.message ?? 'Bağlantı hatası');
    }
  }
}
