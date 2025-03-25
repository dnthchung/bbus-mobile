import 'package:bbus_mobile/features/notification/domain/entity/notification_entity.dart';
import 'package:bbus_mobile/features/notification/domain/usecases/get_list_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetListNotifications _getListNotifications;
  List<NotificationEntity> notifications = [];
  NotificationCubit(this._getListNotifications) : super(NotificationInitial());
  void listenForNotifications() {
    emit(NotificationLoading());
    try {
      _getListNotifications.execute().listen((notification) {
        notifications.add(notification);
        emit(NotificationUpdated(List.from(notifications)));
      });
    } catch (e) {
      emit(NotificationError("Failed to fetch notifications"));
    }
  }
}
