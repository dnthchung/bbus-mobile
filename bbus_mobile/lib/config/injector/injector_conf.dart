part of 'injector.dart';

final sl = GetIt.instance;
void initializeDependencies() {
  // Auth
  AuthDependency.initAuth();
  HistoryDependency.initHistory();
  StudentListDependency.initStudentList();
  _initChangePassword();
  _initMapTracking();
  //core
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(
      () => SecureLocalStorage(sl<FlutterSecureStorage>()));
  sl.registerSingleton<DioClient>(DioClient());
  sl.registerLazySingleton(() => WebSocketService());
  sl.registerLazySingleton(() => CurrentUserCubit());
}

void _initChangePassword() {
  sl
    // Datasource
    ..registerLazySingleton<ChangePasswordRemoteDatasource>(
        () => ChangePasswordRemoteDatasourceImpl(sl()))
    // Repo
    ..registerLazySingleton<ChangePasswordRepository>(
        () => ChangePasswordRepositoryImpl(sl(), sl()))
    // Usecases
    ..registerLazySingleton(() => ChangePasswordUsecase(sl()))
    // Bloc
    ..registerFactory(() => ChangePasswordCubit(sl()));
}

void _initMapTracking() {
  sl
    // Datasource
    ..registerLazySingleton<LocationSocketDatasource>(
        () => LocationSocketDatasourceImpl(sl()))
    // Repo
    ..registerLazySingleton<MapRepository>(() => MapRepositoryImpl(sl()))
    // Usecases
    ..registerLazySingleton(() => GetLiveLocation(sl()))
    // Bloc
    ..registerFactory(() => LocationTrackingCubit(sl()));
}
