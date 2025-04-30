import 'package:bbus_mobile/common/entities/local_notification_model.dart';
import 'package:bbus_mobile/common/notifications/notification_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationService _notificationService;
  NotificationCubit(this._notificationService)
      : super(NotificationState(notifications: [], hasUnread: false)) {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final notifs = await _notificationService.loadUserNotifications();
    final hasUnread = notifs.any((n) => !n.isRead);
    emit(NotificationState(notifications: notifs, hasUnread: hasUnread));
  }

  Future<void> markAllAsRead() async {
    await _notificationService.markAllAsRead();
    await loadNotifications(); // Refresh state after marking
  }

  Future<void> markOneAsRead(LocalNotificationModel notification) async {
    await _notificationService.markOneAsRead(notification);
    await loadNotifications(); // Refresh state after marking
  }

  Future<void> deleteAllRead() async {
    await _notificationService.deleteAllRead();
    await loadNotifications(); // Refresh state after marking
  }

  Future<void> deleteAll() async {
    await _notificationService.deleteAll();
    await loadNotifications(); // Refresh state after marking
  }

  Future<void> addNotification(LocalNotificationModel notification) async {
    final currentList = List<LocalNotificationModel>.from(state.notifications);
    currentList.insert(0, notification);
    emit(NotificationState(notifications: currentList, hasUnread: true));
  }
}
