import 'package:ciu_announcement/core/models/base/base_model.dart';
import 'package:ciu_announcement/features/announcement/domain/entities/announcement_entity.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_category.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_priority.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_target_audience.dart';

class AnnouncementModel extends BaseModel<AnnouncementEntity> {
  final String title;
  final String content;
  final AnnouncementCategory category;
  final AnnouncementPriority priority;
  final AnnouncementTargetAudience targetAudience;
  final int authorId;
  final String authorName;

  const AnnouncementModel({
    required super.id,
    required this.title,
    required this.content,
    required this.category,
    required this.priority,
    required this.targetAudience,
    required this.authorId,
    required this.authorName,
    required super.createdAt,
    super.updatedAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      category: AnnouncementCategory.fromString(json['category'] as String),
      priority: AnnouncementPriority.fromString(json['priority'] as String),
      targetAudience: AnnouncementTargetAudience.fromString(json['target_audience'] as String),
      authorId: json['author_id'] as int,
      authorName: json['author_name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_At'] as String) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category.value,
      'priority': priority.value,
      'target_audience': targetAudience.value,
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
