import 'package:ciu_announcement/core/bloc/base/base_bloc.dart';
import 'package:ciu_announcement/core/usecases/no_params.dart';
import 'package:ciu_announcement/features/announcement/domain/usecases/get_all_announcements_usecase.dart';
import 'package:ciu_announcement/features/announcement/domain/usecases/get_announcement_by_id_usecase.dart';
import 'package:ciu_announcement/features/announcement/domain/usecases/create_announcement_usecase.dart';
import 'package:ciu_announcement/features/announcement/domain/usecases/update_announcement_usecase.dart';
import 'package:ciu_announcement/features/announcement/domain/usecases/delete_announcement_usecase.dart';
import 'package:ciu_announcement/features/announcement/domain/usecases/params/get_announcement_params.dart';
import 'package:ciu_announcement/features/announcement/domain/usecases/params/create_announcement_params.dart';
import 'package:ciu_announcement/features/announcement/domain/usecases/params/update_announcement_params.dart';
import 'package:ciu_announcement/features/announcement/domain/usecases/params/delete_announcement_params.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/events/base/announcement_event.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/events/get_all_announcements_event.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/events/get_announcement_by_id_event.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/events/create_announcement_event.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/events/update_announcement_event.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/events/delete_announcement_event.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/base/announcement_state.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/announcement_initial_state.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/announcement_loading_state.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/announcement_loaded_state.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/announcement_detail_loaded_state.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/announcement_created_state.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/announcement_updated_state.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/announcement_deleted_state.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/announcement_error_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnnouncementBloc extends BaseBloc<AnnouncementEvent, AnnouncementState> {
  final GetAllAnnouncementsUseCase _getAllAnnouncementsUseCase;
  final GetAnnouncementByIdUseCase _getAnnouncementByIdUseCase;
  final CreateAnnouncementUseCase _createAnnouncementUseCase;
  final UpdateAnnouncementUseCase _updateAnnouncementUseCase;
  final DeleteAnnouncementUseCase _deleteAnnouncementUseCase;

  AnnouncementBloc({
    required GetAllAnnouncementsUseCase getAllAnnouncementsUseCase,
    required GetAnnouncementByIdUseCase getAnnouncementByIdUseCase,
    required CreateAnnouncementUseCase createAnnouncementUseCase,
    required UpdateAnnouncementUseCase updateAnnouncementUseCase,
    required DeleteAnnouncementUseCase deleteAnnouncementUseCase,
  })  : _getAllAnnouncementsUseCase = getAllAnnouncementsUseCase,
        _getAnnouncementByIdUseCase = getAnnouncementByIdUseCase,
        _createAnnouncementUseCase = createAnnouncementUseCase,
        _updateAnnouncementUseCase = updateAnnouncementUseCase,
        _deleteAnnouncementUseCase = deleteAnnouncementUseCase,
        super(const AnnouncementInitialState()) {
    on<GetAllAnnouncementsEvent>(_onGetAllAnnouncements);
    on<GetAnnouncementByIdEvent>(_onGetAnnouncementById);
    on<CreateAnnouncementEvent>(_onCreateAnnouncement);
    on<UpdateAnnouncementEvent>(_onUpdateAnnouncement);
    on<DeleteAnnouncementEvent>(_onDeleteAnnouncement);
  }

  Future<void> _onGetAllAnnouncements(
      GetAllAnnouncementsEvent event,
      Emitter<AnnouncementState> emit,
      ) async {
    emit(const AnnouncementLoadingState());

    final result = await _getAllAnnouncementsUseCase(const NoParams());

    result.fold(
          (failure) => emit(AnnouncementErrorState(failure.message)),
          (announcements) => emit(AnnouncementLoadedState(announcements)),
    );
  }

  Future<void> _onGetAnnouncementById(
      GetAnnouncementByIdEvent event,
      Emitter<AnnouncementState> emit,
      ) async {
    emit(const AnnouncementLoadingState());

    final result = await _getAnnouncementByIdUseCase(
      GetAnnouncementParams(id: event.id),
    );

    result.fold(
          (failure) => emit(AnnouncementErrorState(failure.message)),
          (announcement) => emit(AnnouncementDetailLoadedState(announcement)),
    );
  }

  Future<void> _onCreateAnnouncement(
      CreateAnnouncementEvent event,
      Emitter<AnnouncementState> emit,
      ) async {
    emit(const AnnouncementLoadingState());

    final result = await _createAnnouncementUseCase(
      CreateAnnouncementParams(
        title: event.title,
        content: event.content,
        category: event.category,
        priority: event.priority,
        targetAudience: event.targetAudience,
      ),
    );

    result.fold(
          (failure) => emit(AnnouncementErrorState(failure.message)),
          (announcement) => emit(AnnouncementCreatedState(announcement)),
    );
  }

  Future<void> _onUpdateAnnouncement(
      UpdateAnnouncementEvent event,
      Emitter<AnnouncementState> emit,
      ) async {
    emit(const AnnouncementLoadingState());

    final result = await _updateAnnouncementUseCase(
      UpdateAnnouncementParams(
        id: event.id,
        title: event.title,
        content: event.content,
        category: event.category,
        priority: event.priority,
        targetAudience: event.targetAudience,
      ),
    );

    result.fold(
          (failure) => emit(AnnouncementErrorState(failure.message)),
          (announcement) => emit(AnnouncementUpdatedState(announcement)),
    );
  }

  Future<void> _onDeleteAnnouncement(
      DeleteAnnouncementEvent event,
      Emitter<AnnouncementState> emit,
      ) async {
    emit(const AnnouncementLoadingState());

    final result = await _deleteAnnouncementUseCase(
      DeleteAnnouncementParams(id: event.id),
    );

    result.fold(
          (failure) => emit(AnnouncementErrorState(failure.message)),
          (_) => emit(const AnnouncementDeletedState()),
    );
  }
}