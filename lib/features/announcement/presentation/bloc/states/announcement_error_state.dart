import 'package:ciu_announcement/features/announcement/presentation/bloc/states/base/announcement_state.dart';

class AnnouncementErrorState extends AnnouncementState {
  final String message;

  const AnnouncementErrorState(this.message);

  @override
  List<Object?> get props => [message];
}