part of 'notification_cubit.dart';

@immutable
sealed class NotificationState extends Equatable {
  const NotificationState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationUpdated extends NotificationState {
  final List<NotificationEntity> notifications;
  NotificationUpdated(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}
