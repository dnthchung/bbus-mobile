import 'dart:async';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:flutter/material.dart';

enum DialogStatus { success, error, warning }

class ResultDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String? cancelText;
  final DialogStatus? status;

  const ResultDialog({
    Key? key,
    required this.title,
    required this.message,
    this.confirmText = "OK",
    this.cancelText,
    this.status,
  }) : super(key: key);

  // Get icon and color based on status
  IconData get _icon {
    switch (status) {
      case DialogStatus.success:
        return Icons.check_circle;
      case DialogStatus.error:
        return Icons.cancel;
      case DialogStatus.warning:
        return Icons.warning;
      default:
        return Icons.info; // Placeholder, but won't be used when status is null
    }
  }

  Color get _iconColor {
    switch (status) {
      case DialogStatus.success:
        return Colors.green;
      case DialogStatus.error:
        return Colors.red;
      case DialogStatus.warning:
        return Colors.orange;
      default:
        return Colors.transparent; // No color when status is null
    }
  }

  Color get _bgColor {
    switch (status) {
      case DialogStatus.success:
        return Colors.green.withOpacity(0.2);
      case DialogStatus.error:
        return Colors.red.withOpacity(0.2);
      case DialogStatus.warning:
        return Colors.orange.withOpacity(0.2);
      default:
        return Colors.transparent; // Hide when status is null
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04,
          ),
          padding: const EdgeInsets.only(
            top: 32,
            left: 16,
            right: 16,
            bottom: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.0),
              Text(
                title,
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    decoration: TextDecoration.none),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0),
              Text(
                message,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (cancelText != null)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                          ),
                          side: BorderSide(color: TColors.primary),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          cancelText!,
                          style:
                              TextStyle(fontSize: 16, color: TColors.primary),
                        ),
                      ),
                    ),
                  if (cancelText != null)
                    SizedBox(
                      width: 10.0,
                    ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(
                        confirmText,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (status != null)
          Positioned(
            top: -28,
            child: CircleAvatar(
              minRadius: 16,
              maxRadius: 28,
              backgroundColor: _bgColor,
              child: Icon(
                _icon,
                size: 28,
                color: _iconColor,
              ),
            ),
          ),
      ],
    );
  }

  // Static method to show the dialog with options
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    DialogStatus? status,
    String confirmText = "OK",
    String? cancelText,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => ResultDialog(
        title: title,
        message: message,
        status: status,
        confirmText: confirmText,
        cancelText: cancelText,
      ),
    );
  }
}
