import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample notifications list (Replace with Bloc state later)
    final List<Map<String, dynamic>> notifications = [
      {
        "title": "Xe đến điểm trả",
        "body": "Xe buýt của Lan đã về đến điểm đón",
        "unread": true,
        "timestamp": DateTime.now().subtract(const Duration(minutes: 10)),
      },
      {
        "title": "Xe rời trường",
        "body": "Xe buýt của Lan từ trường học đã xuất phát",
        "unread": false,
        "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        "title": "Xe đến trường",
        "body": "Xe buýt của Lan đã đến trường",
        "unread": true,
        "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông báo"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];

          return Card(
            elevation: (notification["unread"] as bool) ? 4 : 1,
            color: (notification["unread"] as bool)
                ? Colors.blue.shade50
                : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notification["title"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: (notification["unread"] as bool)
                              ? Colors.blue
                              : Colors.black,
                        ),
                      ),
                      Text(
                        DateFormat('MMM d, h:mm a')
                            .format(notification["timestamp"] as DateTime),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(notification["body"]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
