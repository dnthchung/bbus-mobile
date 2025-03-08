import 'package:bbus_mobile/common/cubit/cubit/current_user_cubit.dart';
import 'package:bbus_mobile/core/cache/secure_local_storage.dart';
import 'package:bbus_mobile/core/network/api_interceptors.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/features/authentication/di/auth_dependency.dart';
import 'package:bbus_mobile/features/child_feature.dart/di/history_dependency.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

part 'injector_conf.dart';
