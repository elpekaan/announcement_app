import 'package:ciu_announcement/core/constants/api_endpoints.dart';
import 'package:ciu_announcement/core/errors/exceptions/server_exception.dart';
import 'package:ciu_announcement/core/network/api_client.dart';
import 'package:ciu_announcement/features/announcement/data/datasources/announcement_remote_datasource.dart';
import 'package:ciu_announcement/features/announcement/data/models/announcement_model.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_category.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_priority.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_target_audience.dart';
import 'package:dio/dio.dart';

class AnnouncementRemoteDataSourceImpl implements AnnouncementRemoteDataSource {
  final ApiClient _apiClient;

  AnnouncementRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<AnnouncementModel>> getAll() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.announcement);

      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data
          .map(
            (json) => AnnouncementModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? 'Something went wrong',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<AnnouncementModel> getById(int id) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.announcementById(id),
      );

      return AnnouncementModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? 'Something went wrong',
        statusCode: e.response?.statusCode,
      );
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
        ApiEndpoints.announcement,
        data: {
          'title': title,
          'content': content,
          'category': category.value,
          'priority': priority.value,
          'target_audience': targetAudience.value,
        },
      );
      return AnnouncementModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? 'Something went wrong',
        statusCode: e.response?.statusCode,
      );
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
        ApiEndpoints.announcementById(id),
        data: {
          'title': title,
          'content': content,
          'category': category.value,
          'priority': priority.value,
          'target_audience': targetAudience.value,
        },
      );

      return AnnouncementModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? 'Something went wrong',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      await _apiClient.dio.delete(ApiEndpoints.announcementById(id));
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? 'Something went wrong',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
