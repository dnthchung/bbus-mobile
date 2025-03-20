import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/features/authentication/data/datasources/auth_local_datasource.dart';
import 'package:bbus_mobile/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:bbus_mobile/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:bbus_mobile/features/authentication/domain/repository/auth_repository.dart';
import 'package:bbus_mobile/features/authentication/domain/usecases/check_logged_in_status_usecase.dart';
import 'package:bbus_mobile/features/authentication/domain/usecases/login_usecase.dart';
import 'package:bbus_mobile/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:bbus_mobile/features/authentication/presentation/cubit/auth_cubit.dart';

class AuthDependency {
  AuthDependency._();
  static void initAuth() {
    sl
      // Datasource
      ..registerLazySingleton<AuthRemoteDatasource>(
          () => AuthRemoteDatasourceImpl(sl()))
      ..registerLazySingleton<AuthLocalDatasource>(
          () => AuthLocalDatasourceImpl(sl()))
      // Repository
      ..registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(sl(), sl(), sl()))
      // Usecases
      ..registerLazySingleton(() => LoginUsecase(sl()))
      ..registerLazySingleton(() => CheckLoggedInStatusUsecase(sl()))
      ..registerLazySingleton(() => LogoutUsecase(sl()))
      // Bloc
      ..registerLazySingleton<AuthCubit>(
          () => AuthCubit(sl(), sl(), sl(), sl()));
  }
}
