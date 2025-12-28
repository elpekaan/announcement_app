import 'package:ciu_announcement/core/models/base/base_model.dart';
import 'package:ciu_announcement/features/announcement/domain/entities/announcement_entity.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_category.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_priority.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_target_audience.dart';

class AnnouncementModel extends BaseModel<AnnouncementEntity> {
  final int id;
  final String title;
  final String content;
  final AnnouncementCategory category;
  final AnnouncementPriority priority;
  final AnnouncementTargetAudience targetAudience;
  final int authorId;
  final String authorName;
  final DateTime createdAt;
  final DateTime? updatedAt;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.priority,
    required this.targetAudience,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    this.updatedAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      category: AnnouncementCategory.fromString(json['category']),
      priority: AnnouncementPriority.fromString(json['priority']),
      targetAudience: AnnouncementTargetAudience.fromString(json['target_audience']),
      authorId: json['author_id'],
      authorName: json['author_name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category.name,
      'priority': priority.name,
      'target_audience': targetAudience.name,
      'author_id': authorId,
      'author_name': authorName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  AnnouncementEntity toEntity() {
    return AnnouncementEntity(
      id: id,
      title: title,
      content: content,
      category: category,
      priority: priority,
      targetAudience: targetAudience,
      authorId: authorId,
      authorName: authorName,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}