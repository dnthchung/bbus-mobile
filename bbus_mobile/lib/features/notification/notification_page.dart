import 'package:bbus_mobile/common/entities/local_notification_model.dart';
import 'package:bbus_mobile/common/notifications/cubit/notification_cubit.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// final List<LocalNotificationModel> notifications = [
//   LocalNotificationModel(
//       title: 'Đổi thông tin xe',
//       body:
//           'Xe buýt của con Nguyễn Thị Huyền đã đổi sang xe số hiệu H011 vào ngày 2025-09-11',
//       timestamp: DateTime.now().subtract(const Duration(minutes: 10))),
//   LocalNotificationModel(
//       title: 'Lịch chạy xe mới',
//       body:
//           'Xe của con Nguyễn Thị Huyền đã có lịch chạy, bạn đã có thể bắt đầu theo dõi thông tin xe chạy',
//       timestamp: DateTime.now().subtract(const Duration(minutes: 10))),
//   LocalNotificationModel(
//       title: 'Mở đăng kí điểm đón',
//       body:
//           'Thời gian đăng kí điểm đón đã mở, vui lòng đăng ký trong thời gian từ ngày 2025-11-20 dến ngày 2025-11-30',
//       timestamp: DateTime.now().subtract(const Duration(minutes: 10))),
// ];

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample notifications list (Replace with Bloc state later)
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông báo"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              final cubit = context.read<NotificationCubit>();
              if (value == 'mark_all_read') {
                cubit.markAllAsRead();
              } else if (value == 'delete_all_read') {
                cubit
                    .deleteAllRead(); // 👈 You need to implement this in the cubit
              } else if (value == 'delete_all') {
                cubit.deleteAll(); // 👈 You need to implement this in the cubit
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'mark_all_read',
                child: Text('Đánh dấu đã đọc hết'),
              ),
              const PopupMenuItem<String>(
                // 👈 NEW
                value: 'delete_all_read',
                child: Text('Xoá tất cả đã đọc'),
              ),
              const PopupMenuItem<String>(
                // 👈 NEW
                value: 'delete_all',
                child: Text('Xoá tất cả thông báo'),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          final notifications = state.notifications;

          if (notifications.isEmpty) {
            return const Center(child: Text("Không có thông báo."));
          }

          return RefreshIndicator(
            onRefresh: () =>
                context.read<NotificationCubit>().loadNotifications(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];

                return GestureDetector(
                  // onTap: () {
                  //   // You can handle detailed navigation here if needed
                  //   showDialog(
                  //     context: context,
                  //     builder: (_) => AlertDialog(
                  //       title: Text(notif.title),
                  //       content: Text(notif.body),
                  //       actions: [
                  //         TextButton(
                  //           onPressed: () async {
                  //             context
                  //                 .read<NotificationCubit>()
                  //                 .markOneAsRead(notif);
                  //             context.pop();
                  //           },
                  //           child: const Text("Đóng"),
                  //         ),
                  //       ],
                  //     ),
                  //   );
                  // },
                  onDoubleTap: () {
                    if (!notif.isRead) {
                      context.read<NotificationCubit>().markOneAsRead(notif);
                    }
                  },
                  child: Card(
                    elevation: notif.isRead ? 1 : 4,
                    color: notif.isRead
                        ? Colors.grey.shade200
                        : Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                notif.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color:
                                      notif.isRead ? Colors.black : Colors.blue,
                                ),
                              ),
                              Text(
                                DateFormat('d MMM, HH:mm', 'vi_VN')
                                    .format(notif.timestamp),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(notif.body),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
