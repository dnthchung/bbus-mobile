import 'package:flutter/material.dart';

Future<String?> showChangeCheckpointReasonDialog(BuildContext context) {
  final TextEditingController _controller = TextEditingController();

  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Lý do thay đổi điểm đón'),
        content: TextField(
          controller: _controller,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Nhập lý do...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(null),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final reason = _controller.text.trim();
              if (reason.isNotEmpty) {
                Navigator.of(dialogContext).pop(reason);
              }
            },
            child: const Text('Gửi'),
          ),
        ],
      );
    },
  );
}
