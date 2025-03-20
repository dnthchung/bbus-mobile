part of 'injector.dart';

final sl = GetIt.instance;
void initializeDependencies() {
  // Auth
  AuthDependency.initAuth();
  HistoryDependency.initHistory();
  StudentListDependency.initStudentList();
  _initChangePassword();
  //core
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(
      () => SecureLocalStorage(sl<FlutterSecureStorage>()));
  sl.registerSingleton<DioClient>(DioClient());
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
