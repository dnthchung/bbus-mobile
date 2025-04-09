part of 'injector.dart';

final sl = GetIt.instance;
void initializeDependencies() {
  // Auth
  AuthDependency.initAuth();
  _initChangePassword();
  _initMap();
  _initChildren();
  _initCheckpoint();
  _initRequest();
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

void _initMap() {
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

void _initChildren() {
  sl
    ..registerLazySingleton<ChildrenDatasource>(
        () => ChildrenDatasourceImpl(sl(), sl()))
    ..registerLazySingleton<ChildrenRepository>(
        () => ChildrenRepositoryImpl(sl()))
    ..registerLazySingleton(() => Getchildrenlist(sl()))
    ..registerFactory(() => ChildrenListCubit(sl()));
}

void _initCheckpoint() {
  sl
    // Datasource
    ..registerLazySingleton<CheckpointDatasource>(
        () => CheckpointDatasourceImpl(sl()))
    // Repo
    ..registerLazySingleton<CheckpointRepository>(
        () => CheckpointRespositoryImpl(sl()))
    // Usecases
    ..registerLazySingleton(() => GetCheckpointList(sl()))
    ..registerLazySingleton(() => RegisterCheckpoint(sl()))
    // Bloc
    ..registerFactory(() => CheckpointListCubit(sl()));
}

void _initRequest() {
  sl
    ..registerLazySingleton<RequestRemoteDatasource>(
        () => RequestRemoteDatasourceImpl(sl()))
    ..registerLazySingleton<RequestRepository>(
        () => RequestRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetAllRequestType(sl()))
    ..registerLazySingleton(() => RequestTypeCubit(sl()));
}
