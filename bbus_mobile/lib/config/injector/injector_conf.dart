part of 'injector.dart';
final sl = GetIt.instance;
void initializeDependencies() {
  sl.registerSingleton<DioClient>(DioClient());
  sl.registerLazySingleton(()=>AuthCubit());
}
