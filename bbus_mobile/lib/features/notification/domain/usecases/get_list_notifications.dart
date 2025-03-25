import 'package:bbus_mobile/features/notification/domain/entity/notification_entity.dart';
import 'package:bbus_mobile/features/notification/domain/repository/notification_repository.dart';

class GetListNotifications {
  final NotificationRepository _notificationRepository;
  GetListNotifications(this._notificationRepository);

  Stream<NotificationEntity> execute() {
    return _notificationRepository.notificationStream;
  }
}
