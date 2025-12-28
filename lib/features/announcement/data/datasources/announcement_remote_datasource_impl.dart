import 'package:dio/dio.dart';
import 'package:ciu_announcement/core/network/api_client.dart';
import 'package:ciu_announcement/core/errors/exceptions/server_exception.dart';
import 'package:ciu_announcement/core/errors/exceptions/unauthorized_exception.dart';
import 'package:ciu_announcement/features/announcement/data/datasources/announcement_remote_datasource.dart';
import 'package:ciu_announcement/features/announcement/data/models/announcement_model.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_category.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_priority.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_target_audience.dart';

class AnnouncementRemoteDataSourceImpl implements AnnouncementRemoteDataSource {
  final ApiClient _apiClient;

  AnnouncementRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<AnnouncementModel>> getAll() async {
    try {
      final response = await _apiClient.dio.get('/announcements');

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => AnnouncementModel.fromJson(json)).toList();
      }

      throw ServerException(response.data['message'] ?? 'Duyurular alınamadı');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Oturum süresi doldu');
      }
      throw ServerException(e.message ?? 'Bağlantı hatası');
    }
  }

  @override
  Future<AnnouncementModel> getById(int id) async {
    try {
      final response = await _apiClient.dio.get('/announcements/$id');

      if (response.data['success'] == true) {
        return AnnouncementModel.fromJson(response.data['data']);
      }

      throw ServerException(response.data['message'] ?? 'Duyuru bulunamadı');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Oturum süresi doldu');
      }
      if (e.response?.statusCode == 404) {
        throw ServerException('Duyuru bulunamadı');
      }
      throw ServerException(e.message ?? 'Bağlantı hatası');
    }
  }

  @override
  Future<AnnouncementModel> create({
    required String title,
    required String content,
    required AnnouncementCategory category,
    required AnnouncementPriority priority,
    required AnnouncementTargetAudience targetAudience,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/announcements',
        data: {
          'title': title,
          'content': content,
          'category': category.name,
          'priority': priority.name,
          'target_audience': targetAudience.name,
        },
      );

      if (response.data['success'] == true) {
        return AnnouncementModel.fromJson(response.data['data']);
      }

      throw ServerException(response.data['message'] ?? 'Duyuru oluşturulamadı');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Oturum süresi doldu');
      }
      if (e.response?.statusCode == 403) {
        throw ServerException(e.response?.data['message'] ?? 'Yetkiniz yok');
      }
      if (e.response?.statusCode == 422) {
        final message = e.response?.data['message'] ?? 'Validasyon hatası';
        throw ServerException(message);
      }
      throw ServerException(e.message ?? 'Bağlantı hatası');
    }
  }

  @override
  Future<AnnouncementModel> update({
    required int id,
    required String title,
    required String content,
    required AnnouncementCategory category,
    required AnnouncementPriority priority,
    required AnnouncementTargetAudience targetAudience,
  }) async {
    try {
      final response = await _apiClient.dio.put(
        '/announcements/$id',
        data: {
          'title': title,
          'content': content,
          'category': category.name,
          'priority': priority.name,
          'target_audience': targetAudience.name,
        },
      );

      if (response.data['success'] == true) {
        return AnnouncementModel.fromJson(response.data['data']);
      }

      throw ServerException(response.data['message'] ?? 'Duyuru güncellenemedi');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Oturum süresi doldu');
      }
      if (e.response?.statusCode == 403) {
        throw ServerException(e.response?.data['message'] ?? 'Yetkiniz yok');
      }
      if (e.response?.statusCode == 404) {
        throw ServerException('Duyuru bulunamadı');
      }
      throw ServerException(e.message ?? 'Bağlantı hatası');
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      final response = await _apiClient.dio.delete('/announcements/$id');

      if (response.data['success'] != true) {
        throw ServerException(response.data['message'] ?? 'Duyuru silinemedi');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Oturum süresi doldu');
      }
      if (e.response?.statusCode == 403) {
        throw ServerException(e.response?.data['message'] ?? 'Yetkiniz yok');
      }
      if (e.response?.statusCode == 404) {
        throw ServerException('Duyuru bulunamadı');
      }
      throw ServerException(e.message ?? 'Bağlantı hatası');
    }
  }
}