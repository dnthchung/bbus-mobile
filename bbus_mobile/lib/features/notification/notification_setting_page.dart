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
            "Notification Settings",
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
              "Pickup Notification",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              "Get notified when you receive a new message.",
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
              "Drop Notification",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              "Get notified when you receive a new message.",
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
              "Reached at School",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              "Get notified when you receive a new message.",
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
              "Left from School",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              "Get notified when you receive a new message.",
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
                  "Save Settings",
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
