import 'package:ciu_announcement/features/announcement/presentation/bloc/events/base/announcement_event.dart';

class GetAnnouncementByIdEvent extends AnnouncementEvent {
  final int id;

  const GetAnnouncementByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}
