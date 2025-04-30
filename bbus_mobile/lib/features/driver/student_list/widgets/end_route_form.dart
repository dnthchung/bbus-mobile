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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
              'Kết thúc chuyến',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _feedbackController,
                decoration: const InputDecoration(
                  labelText: 'Phản hồi',
                  hintText: 'Viết phản hồi tại đây...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Vui lòng nhập phản hồi'
                    : null,
                maxLines: 3,
              ),
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
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                      ),
                    ),
                    child: const Text('Hủy'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final feedback = _feedbackController.text.trim();
                      if (_formKey.currentState?.validate() ?? false) {
                        Navigator.of(context).pop();
                        widget.onSubmit?.call(feedback);
                      }
                    },
                    child: const Text('Xác nhận'),
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
