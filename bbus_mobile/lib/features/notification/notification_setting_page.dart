import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:flutter/material.dart';

class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({super.key});

  @override
  State<NotificationSettingPage> createState() =>
      _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  bool newMessage = true;
  bool scheduleUpdate = false;
  bool systemAlert = true;

  void _saveSettings() {
    // Implement save logic (to storage or API)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Settings Saved")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cài đặt thông báo",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: TColors.accent),
          ),
          SizedBox(
            height: 20,
          ),
          CheckboxListTile(
            title: const Text(
              "Thông báo đón",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              "Nhận thông báo khi con bạn lên xe.",
              style: TextStyle(color: TColors.textSecondary),
            ),
            value: newMessage,
            onChanged: (value) {
              setState(() {
                newMessage = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text(
              "Thông báo trả",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              "Nhận thông báo khi con bạn xuống xe.",
              style: TextStyle(color: TColors.textSecondary),
            ),
            value: scheduleUpdate,
            onChanged: (value) {
              setState(() {
                scheduleUpdate = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text(
              "Thông báo đến trường",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              "Nhận thông báo khi con bạn đến trường.",
              style: TextStyle(color: TColors.textSecondary),
            ),
            value: systemAlert,
            onChanged: (value) {
              setState(() {
                systemAlert = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text(
              "Thông báo rời trường",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              "Nhận thông báo khi con bạn rời trường.",
              style: TextStyle(color: TColors.textSecondary),
            ),
            value: systemAlert,
            onChanged: (value) {
              setState(() {
                systemAlert = value!;
              });
            },
          ),
          const SizedBox(height: 30),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7, // 70% width
              child: ElevatedButton(
                onPressed: _saveSettings,
                child: const Text(
                  "Lưu cài đặt",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
