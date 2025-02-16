import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;
Future<void> initializeDependencies() async {
  sl.registerSingleton(() => DioClient());
}
