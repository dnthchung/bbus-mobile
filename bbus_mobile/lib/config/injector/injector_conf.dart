part of 'injector.dart';

final sl = GetIt.instance;
void initializeDependencies() {
  // Auth
  AuthDependency.initAuth();
  HistoryDependency.initHistory();
  StudentListDependency.initStudentList();
  //core
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(
      () => SecureLocalStorage(sl<FlutterSecureStorage>()));
  sl.registerSingleton<DioClient>(DioClient());
  sl.registerLazySingleton(() => CurrentUserCubit());
}
