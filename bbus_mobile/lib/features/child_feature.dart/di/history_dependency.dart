import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/features/child_feature.dart/history/cubit/history_cubit.dart';

class HistoryDependency {
  HistoryDependency._();
  static void initHistory() {
    sl
      // Datasource

      // Usecases

      // Bloc
      ..registerFactory<HistoryCubit>(() => HistoryCubit());
  }
}
