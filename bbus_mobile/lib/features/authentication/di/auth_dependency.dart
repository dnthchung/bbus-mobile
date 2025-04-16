import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/features/authentication/data/datasources/auth_local_datasource.dart';
import 'package:bbus_mobile/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:bbus_mobile/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:bbus_mobile/features/authentication/domain/repository/auth_repository.dart';
import 'package:bbus_mobile/features/authentication/domain/usecases/check_logged_in_status_usecase.dart';
import 'package:bbus_mobile/features/authentication/domain/usecases/get_otp_by_phone.dart';
import 'package:bbus_mobile/features/authentication/domain/usecases/login_usecase.dart';
import 'package:bbus_mobile/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:bbus_mobile/features/authentication/domain/usecases/reset_password.dart';
import 'package:bbus_mobile/features/authentication/domain/usecases/verify_otp.dart';
import 'package:bbus_mobile/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:bbus_mobile/features/authentication/presentation/cubit/forgot_password/forgot_password_cubit.dart';

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
      ..registerLazySingleton(() => GetOtpByPhone(sl()))
      ..registerLazySingleton(() => VerifyOtp(sl()))
      ..registerLazySingleton(() => ResetPassword(sl()))
      // Bloc
      ..registerLazySingleton<AuthCubit>(
          () => AuthCubit(sl(), sl(), sl(), sl()))
      ..registerLazySingleton<ForgotPasswordCubit>(
          () => ForgotPasswordCubit(sl(), sl(), sl()));
  }
}
