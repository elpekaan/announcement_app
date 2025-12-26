import 'package:ciu_announcement/features/announcement/domain/entities/announcement_entity.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/base/announcement_state.dart';

class AnnouncementLoadedState extends AnnouncementState {
  final List<AnnouncementEntity> announcements;

  const AnnouncementLoadedState(this.announcements);

  @override
  List<Object?> get props => [announcements];
}