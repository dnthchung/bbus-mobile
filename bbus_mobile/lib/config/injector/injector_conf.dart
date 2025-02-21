part of 'injector.dart';

final sl = GetIt.instance;
void initializeDependencies() {
  // Auth
  AuthDependency.initAuth();
  //core
  sl.registerSingleton<DioClient>(DioClient());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(
      () => SecureLocalStorage(sl<FlutterSecureStorage>()));
}
