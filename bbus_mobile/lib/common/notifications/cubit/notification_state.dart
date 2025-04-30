part of 'notification_cubit.dart';

class NotificationState {
  final List<LocalNotificationModel> notifications;
  final bool hasUnread;

  NotificationState({
    required this.notifications,
    required this.hasUnread,
  });
}
