import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ciu_announcement/injection_container.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/announcement_bloc.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/events/get_all_announcements_event.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/events/delete_announcement_event.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/base/announcement_state.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/announcement_loading_state.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/announcement_loaded_state.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/announcement_deleted_state.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/announcement_error_state.dart';
import 'package:ciu_announcement/features/announcement/presentation/widgets/cards/announcement_card_widget.dart';
import 'package:ciu_announcement/features/announcement/presentation/pages/announcement_detail_page.dart';
import 'package:ciu_announcement/features/announcement/presentation/pages/announcement_create_page.dart';
import 'package:ciu_announcement/features/announcement/presentation/pages/announcement_edit_page.dart';

class AnnouncementListPage extends StatelessWidget {
  final bool canCreate;
  final bool canEdit;
  final bool canDelete;

  const AnnouncementListPage({
    super.key,
    this.canCreate = false,
    this.canEdit = false,
    this.canDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AnnouncementBloc>()..add(const GetAllAnnouncementsEvent()),
      child: _AnnouncementListView(
        canCreate: canCreate,
        canEdit: canEdit,
        canDelete: canDelete,
      ),
    );
  }
}

class _AnnouncementListView extends StatelessWidget {
  final bool canCreate;
  final bool canEdit;
  final bool canDelete;

  const _AnnouncementListView({
    required this.canCreate,
    required this.canEdit,
    required this.canDelete,
  });

  void _navigateToDetail(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AnnouncementDetailPage(announcementId: id),
      ),
    );
  }

  void _navigateToCreate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AnnouncementCreatePage(),
      ),
    ).then((_) {
      context.read<AnnouncementBloc>().add(const GetAllAnnouncementsEvent());
    });
  }

  void _navigateToEdit(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AnnouncementEditPage(announcementId: id),
      ),
    ).then((_) {
      context.read<AnnouncementBloc>().add(const GetAllAnnouncementsEvent());
    });
  }

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Duyuruyu Sil'),
        content: const Text('Bu duyuruyu silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AnnouncementBloc>().add(DeleteAnnouncementEvent(id));
            },
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Duyurular'),
      ),
      floatingActionButton: canCreate
          ? FloatingActionButton(
        onPressed: () => _navigateToCreate(context),
        child: const Icon(Icons.add),
      )
          : null,
      body: BlocConsumer<AnnouncementBloc, AnnouncementState>(
        listener: (context, state) {
          if (state is AnnouncementDeletedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Duyuru silindi')),
            );
            context.read<AnnouncementBloc>().add(const GetAllAnnouncementsEvent());
          } else if (state is AnnouncementErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AnnouncementLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AnnouncementLoadedState) {
            if (state.announcements.isEmpty) {
              return const Center(
                child: Text('Henüz duyuru bulunmuyor'),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<AnnouncementBloc>().add(const GetAllAnnouncementsEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.announcements.length,
                itemBuilder: (context, index) {
                  final announcement = state.announcements[index];
                  return AnnouncementCardWidget(
                    announcement: announcement,
                    onTap: () => _navigateToDetail(context, announcement.id),
                    onEdit: canEdit ? () => _navigateToEdit(context, announcement.id) : null,
                    onDelete: canDelete ? () => _showDeleteDialog(context, announcement.id) : null,
                    showActions: canEdit || canDelete,
                  );
                },
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
                      context.read<AnnouncementBloc>().add(const GetAllAnnouncementsEvent());
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
    );
  }
}