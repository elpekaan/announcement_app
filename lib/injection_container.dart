import 'package:ciu_announcement/features/announcement/data/datasources/announcement_mock_datasource.dart';
import 'package:get_it/get_it.dart';
import 'package:ciu_announcement/core/network/api_client.dart';
import 'package:ciu_announcement/core/network/network_info/base/base_network_info.dart';
import 'package:ciu_announcement/core/network/network_info/network_info_impl.dart';
import 'package:ciu_announcement/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ciu_announcement/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:ciu_announcement/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ciu_announcement/features/auth/domain/repositories/auth_repository.dart';
import 'package:ciu_announcement/features/auth/domain/usecases/login_usecase.dart';
import 'package:ciu_announcement/features/auth/domain/usecases/register_usecase.dart';
import 'package:ciu_announcement/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ciu_announcement/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:ciu_announcement/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ciu_announcement/features/announcement/data/datasources/announcement_remote_datasource.dart';
import 'package:ciu_announcement/features/announcement/data/datasources/announcement_remote_datasource_impl.dart';
import 'package:ciu_announcement/features/announcement/data/repositories/announcement_repository_impl.dart';
import 'package:ciu_announcement/features/announcement/domain/repositories/announcement_repository.dart';
import 'package:ciu_announcement/features/announcement/domain/usecases/get_all_announcements_usecase.dart';
import 'package:ciu_announcement/features/announcement/domain/usecases/get_announcement_by_id_usecase.dart';
import 'package:ciu_announcement/features/announcement/domain/usecases/create_announcement_usecase.dart';
import 'package:ciu_announcement/features/announcement/domain/usecases/update_announcement_usecase.dart';
import 'package:ciu_announcement/features/announcement/domain/usecases/delete_announcement_usecase.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/announcement_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //============ CORE ============//

  sl.registerLazySingleton<ApiClient>(
        () => ApiClient(),
  );

  sl.registerLazySingleton<BaseNetworkInfo>(
        () => NetworkInfoImpl(),
  );

  //============ AUTH FEATURE ============//

  // DataSources
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl(), sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => IsLoggedInUseCase(sl()));

  // BLoC
  sl.registerFactory(
        () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      isLoggedInUseCase: sl(),
    ),
  );

  //============ ANNOUNCEMENT FEATURE ============//

  // DataSources - Mock kullanıyoruz (backend hazır olunca değiştireceğiz)
  sl.registerLazySingleton<AnnouncementRemoteDataSource>(
        () => AnnouncementMockDataSource(),
  );

  // Repositories
  sl.registerLazySingleton<AnnouncementRepository>(
        () => AnnouncementRepositoryImpl(sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetAllAnnouncementsUseCase(sl()));
  sl.registerLazySingleton(() => GetAnnouncementByIdUseCase(sl()));
  sl.registerLazySingleton(() => CreateAnnouncementUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAnnouncementUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAnnouncementUseCase(sl()));

  // BLoC
  sl.registerFactory(
        () => AnnouncementBloc(
      getAllAnnouncementsUseCase: sl(),
      getAnnouncementByIdUseCase: sl(),
      createAnnouncementUseCase: sl(),
      updateAnnouncementUseCase: sl(),
      deleteAnnouncementUseCase: sl(),
    ),
  );
}