import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AbsentRequestPage extends StatefulWidget {
  @override
  _AbsentRequestPageState createState() => _AbsentRequestPageState();
}

class _AbsentRequestPageState extends State<AbsentRequestPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedChild;
  DateTimeRange? absentPeriod;
  String? reason;

  final List<String> children = ['John Doe', 'Emma Smith', 'Liam Brown'];

  void _pickAbsentPeriod() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      setState(() {
        absentPeriod = picked;
      });
    }
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Absent request submitted successfully!")),
      );

      // Handle the submission (API call or database save)
      print("Child: $selectedChild");
      print("Absent Period: ${absentPeriod?.start} - ${absentPeriod?.end}");
      print("Reason: $reason");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Absent Request"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Child Selection
              DropdownButtonFormField<String>(
                value: selectedChild,
                decoration: InputDecoration(labelText: "Select Child"),
                items: children.map((child) {
                  return DropdownMenuItem(
                    value: child,
                    child: Text(child),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedChild = value),
                validator: (value) =>
                    value == null ? "Please select a child" : null,
              ),
              SizedBox(height: 16),

              // Absent Period Picker
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Absent Period",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: _pickAbsentPeriod,
                controller: TextEditingController(
                  text: absentPeriod == null
                      ? ""
                      : "${absentPeriod!.start.toLocal()} - ${absentPeriod!.end.toLocal()}",
                ),
                validator: (value) =>
                    absentPeriod == null ? "Please select a period" : null,
              ),
              SizedBox(height: 16),

              // Reason Input
              TextFormField(
                decoration: InputDecoration(labelText: "Reason"),
                maxLines: 3,
                onChanged: (value) => reason = value,
                validator: (value) => (value == null || value.isEmpty)
                    ? "Please provide a reason"
                    : null,
              ),
              SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitRequest,
                  child: Text("Submit Request"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
