import 'package:bbus_mobile/common/cubit/cubit/current_user_cubit.dart';
import 'package:bbus_mobile/core/cache/secure_local_storage.dart';
import 'package:bbus_mobile/core/network/api_interceptors.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/features/authentication/di/auth_dependency.dart';
import 'package:bbus_mobile/features/change_password/data/datasources/change_password_remote_datasource.dart';
import 'package:bbus_mobile/features/change_password/data/repository/change_password_repository_impl.dart';
import 'package:bbus_mobile/features/change_password/domain/cubit/change_password_cubit.dart';
import 'package:bbus_mobile/features/change_password/domain/repository/change_password_repository.dart';
import 'package:bbus_mobile/features/change_password/domain/usecase/change_password_usecase.dart';
import 'package:bbus_mobile/features/child_feature.dart/di/history_dependency.dart';
import 'package:bbus_mobile/features/driver/di/student_list_dependency.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

part 'injector_conf.dart';
