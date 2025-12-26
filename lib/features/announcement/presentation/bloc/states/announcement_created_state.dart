import 'package:ciu_announcement/features/announcement/domain/entities/announcement_entity.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/base/announcement_state.dart';

class AnnouncementCreatedState extends AnnouncementState {
  final AnnouncementEntity announcement;

  const AnnouncementCreatedState(this.announcement);

  @override
  List<Object?> get props => [announcement];
}