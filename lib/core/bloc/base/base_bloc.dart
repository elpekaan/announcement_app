import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ciu_announcement/core/bloc/base/base_event.dart';
import 'package:ciu_announcement/core/bloc/base/base_state.dart';

abstract class BaseBloc<E extends BaseEvent, S extends BaseState> extends Bloc<E, S> {
  BaseBloc(super.initialState);
}