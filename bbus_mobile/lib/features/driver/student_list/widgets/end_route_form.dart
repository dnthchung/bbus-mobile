import 'package:flutter/material.dart';

class EndRouteModal extends StatefulWidget {
  final void Function(String feedback)? onSubmit;
  final VoidCallback? onCancel;

  const EndRouteModal({
    Key? key,
    this.onSubmit,
    this.onCancel,
  }) : super(key: key);

  @override
  State<EndRouteModal> createState() => _EndRouteModalState();
}

class _EndRouteModalState extends State<EndRouteModal> {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'End Route',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _feedbackController,
              decoration: const InputDecoration(
                labelText: 'Feedback',
                hintText: 'Write your feedback here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onCancel?.call();
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final feedback = _feedbackController.text.trim();
                      Navigator.of(context).pop();
                      widget.onSubmit?.call(feedback);
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
