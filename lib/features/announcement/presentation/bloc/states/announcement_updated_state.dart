import 'package:ciu_announcement/features/announcement/domain/entities/announcement_entity.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/base/announcement_state.dart';

class AnnouncementUpdatedState extends AnnouncementState {
  final AnnouncementEntity announcement;

  const AnnouncementUpdatedState(this.announcement);

  @override
  List<Object?> get props => [announcement];
}