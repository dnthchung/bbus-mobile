import 'package:flutter/material.dart';

Future<String?> showChangeCheckpointReasonDialog(BuildContext context) {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<bool> _errorNotifier = ValueNotifier(false);

  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Lý do thay đổi điểm đón'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: _errorNotifier,
              builder: (context, hasError, child) {
                return TextField(
                  controller: _controller,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Nhập lý do...',
                    border: const OutlineInputBorder(),
                    errorText: hasError ? 'Vui lòng nhập lý do' : null,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(null),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final reason = _controller.text.trim();
              if (reason.isEmpty) {
                _errorNotifier.value = true;
              } else {
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
