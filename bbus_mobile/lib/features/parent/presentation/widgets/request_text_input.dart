import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:flutter/material.dart';

class RequestTextInput extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  const RequestTextInput(
      {super.key, required this.hintText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: TColors.primary,
          ),
        ),
        hintText: hintText,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is missing!";
        }
        return null;
      },
    );
  }
}
