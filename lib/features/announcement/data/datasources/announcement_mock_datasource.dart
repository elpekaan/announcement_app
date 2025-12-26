import 'package:ciu_announcement/features/announcement/data/models/announcement_model.dart';
import 'package:ciu_announcement/features/announcement/data/datasources/announcement_remote_datasource.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_category.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_priority.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_target_audience.dart';

class AnnouncementMockDataSource implements AnnouncementRemoteDataSource {
  final List<AnnouncementModel> _announcements = [];

  int _nextId = 1;

  @override
  Future<List<AnnouncementModel>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_announcements.reversed);
  }

  @override
  Future<AnnouncementModel> getById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _announcements.firstWhere((a) => a.id == id);
  }

  @override
  Future<AnnouncementModel> create({
    required String title,
    required String content,
    required AnnouncementCategory category,
    required AnnouncementPriority priority,
    required AnnouncementTargetAudience targetAudience,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final newAnnouncement = AnnouncementModel(
      id: _nextId++,
      title: title,
      content: content,
      category: category,
      priority: priority,
      targetAudience: targetAudience,
      authorId: 1,
      authorName: 'Test Kullanıcı',
      createdAt: DateTime.now(),
      updatedAt: null,
    );

    _announcements.add(newAnnouncement);
    return newAnnouncement;
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
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _announcements.indexWhere((a) => a.id == id);
    final oldAnnouncement = _announcements[index];

    final updatedAnnouncement = AnnouncementModel(
      id: id,
      title: title,
      content: content,
      category: category,
      priority: priority,
      targetAudience: targetAudience,
      authorId: oldAnnouncement.authorId,
      authorName: oldAnnouncement.authorName,
      createdAt: oldAnnouncement.createdAt,
      updatedAt: DateTime.now(),
    );

    _announcements[index] = updatedAnnouncement;
    return updatedAnnouncement;
  }

  @override
  Future<void> delete(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _announcements.removeWhere((a) => a.id == id);
  }
}