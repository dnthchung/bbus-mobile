part of 'notification_cubit.dart';

class NotificationState extends Equatable {
  final List<LocalNotificationModel> notifications;
  final bool hasUnread;

  NotificationState({
    required this.notifications,
    required this.hasUnread,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [notifications];
}
