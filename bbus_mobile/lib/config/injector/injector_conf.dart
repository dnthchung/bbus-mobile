part of 'injector.dart';

final sl = GetIt.instance;
void initializeDependencies() {
  // Auth
  AuthDependency.initAuth();
  _initNotificaiton();
  _initChangePassword();
  _initBus();
  _initMap();
  _initChildren();
  _initCheckpoint();
  _initRequest();
  _initDriver();
  //core
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(
      () => SecureLocalStorage(sl<FlutterSecureStorage>()));
  sl.registerLazySingleton<NotificationService>(() => NotificationService());
  sl.registerSingleton<DioClient>(DioClient());
  sl.registerLazySingleton(() => WebSocketService());
  sl.registerLazySingleton(() => MultiWebSocketService());
  sl.registerLazySingleton(() => CurrentUserCubit());
}

void _initNotificaiton() {
  sl..registerLazySingleton(() => NotificationCubit(sl()));
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
    ..registerLazySingleton(() => GetMapRoute(sl()))
    // Bloc
    ..registerFactory(() => LocationTrackingCubit(sl(), sl()));
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
    ..registerLazySingleton(() => GetRequestList(sl()))
    ..registerLazySingleton(() => SendAbsentRequest(sl()))
    ..registerLazySingleton(() => SendChangeCheckpointReq(sl()))
    ..registerLazySingleton(() => SendNewCheckpointReq(sl()))
    ..registerLazySingleton(() => RequestTypeCubit(sl()))
    ..registerFactory(() => RequestListCubit(sl()));
}

_initDriver() {
  sl
    ..registerLazySingleton<ScheduleDatasource>(
        () => ScheduleDatasourceImpl(sl(), sl()))
    ..registerLazySingleton<StudentListDatasource>(
        () => StudentListDatasourceImpl(sl()))
    ..registerLazySingleton<ScheduleRepository>(
        () => ScheduleRepositoryImpl(sl()))
    ..registerLazySingleton<StudentListRepository>(
        () => StudentListRepositoryImpl(sl(), sl(), sl()))
    ..registerLazySingleton(() => GetBusSchedule(sl()))
    ..registerLazySingleton(() => GetStudentStream(sl()))
    ..registerLazySingleton(() => MarkAttendance(sl()))
    ..registerLazySingleton(() => EndSchedule(sl()))
    ..registerLazySingleton(() => StudentListCubit(sl(), sl(), sl()));
}

_initBus() {
  sl
    ..registerLazySingleton<BusDatasource>(() => BusDatasourceImpl(sl()))
    ..registerLazySingleton<BusRepository>(() => BusRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetBusDetail(sl()));
}
