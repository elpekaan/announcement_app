import 'package:ciu_announcement/features/announcement/presentation/bloc/events/base/announcement_event.dart';

class DeleteAnnouncementEvent extends AnnouncementEvent {
  final int id;

  const DeleteAnnouncementEvent(this.id);

  @override
  List<Object?> get props => [id];
}