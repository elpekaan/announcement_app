import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ciu_announcement/core/theme/app_colors.dart';
import 'package:ciu_announcement/injection_container.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/announcement_bloc.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/events/get_announcement_by_id_event.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/base/announcement_state.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/announcement_loading_state.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/announcement_detail_loaded_state.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/announcement_error_state.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_priority.dart';

class AnnouncementDetailPage extends StatelessWidget {
  final int announcementId;

  const AnnouncementDetailPage({
    super.key,
    required this.announcementId,
  });

  Color _getPriorityColor(AnnouncementPriority priority) {
    switch (priority) {
      case AnnouncementPriority.urgent:
        return AppColors.error;
      case AnnouncementPriority.important:
        return AppColors.warning;
      case AnnouncementPriority.normal:
        return AppColors.info;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AnnouncementBloc>()..add(GetAnnouncementByIdEvent(announcementId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Duyuru Detayı'),
        ),
        body: BlocBuilder<AnnouncementBloc, AnnouncementState>(
          builder: (context, state) {
            if (state is AnnouncementLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AnnouncementDetailLoadedState) {
              final announcement = state.announcement;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(announcement.priority).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            announcement.priority.displayName,
                            style: TextStyle(
                              color: _getPriorityColor(announcement.priority),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            announcement.category.displayName,
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      announcement.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 18),
                        const SizedBox(width: 4),
                        Text(announcement.authorName),
                        const SizedBox(width: 16),
                        const Icon(Icons.access_time, size: 18),
                        const SizedBox(width: 4),
                        Text(_formatDate(announcement.createdAt)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.group_outlined, size: 18),
                        const SizedBox(width: 4),
                        Text('Hedef: ${announcement.targetAudience.displayName}'),
                      ],
                    ),
                    const Divider(height: 32),
                    Text(
                      announcement.content,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is AnnouncementErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AnnouncementBloc>().add(GetAnnouncementByIdEvent(announcementId));
                      },
                      child: const Text('Tekrar Dene'),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}