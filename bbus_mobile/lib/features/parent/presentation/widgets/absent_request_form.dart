import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/core/utils/date_utils.dart';
import 'package:bbus_mobile/features/parent/presentation/widgets/request_text_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AbsentRequestForm extends StatefulWidget {
  const AbsentRequestForm({super.key});

  @override
  State<AbsentRequestForm> createState() => _AbsentRequestFormState();
}

class _AbsentRequestFormState extends State<AbsentRequestForm> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _fromDateController =
      TextEditingController(text: fromDatetoString(DateTime.now()));
  final TextEditingController _toDateController =
      TextEditingController(text: fromDatetoString(DateTime.now()));
  Future<void> _selectedDate(BuildContext context, bool isFromDate) async {
    DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
        initialDate: DateTime.now());
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDateController.text = picked.toString().split(" ")[0];
        } else {
          _toDateController.text = picked.toString().split(" ")[0];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Absent Form'),
        SizedBox(
          height: 20,
        ),
        RequestTextInput(hintText: 'Reason', controller: _reasonController),
        Row(
          spacing: 20.0,
          children: [
            TextField(
              controller: _fromDateController,
              decoration: InputDecoration(
                labelText: 'FROM DATE',
                filled: true,
                prefixIcon: Icon(Icons.calendar_today),
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: TColors.primary)),
              ),
              readOnly: true,
              onTap: () {
                _selectedDate(context, true);
              },
            ),
            TextField(
              controller: _toDateController,
              decoration: InputDecoration(
                labelText: 'TO DATE',
                filled: true,
                prefixIcon: Icon(Icons.calendar_today),
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: TColors.primary)),
              ),
              readOnly: true,
              onTap: () {
                _selectedDate(context, false);
              },
            ),
          ],
        )
      ],
    );
  }
}
