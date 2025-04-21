import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/features/parent/domain/usecases/send_absent_request.dart';
import 'package:bbus_mobile/features/parent/presentation/cubit/children_list/children_list_cubit.dart';
import 'package:bbus_mobile/features/parent/presentation/cubit/request_list/request_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  bool _isLoading = false;

  void _pickAbsentPeriod() async {
    DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 1),
        fieldStartLabelText: 'Từ Ngày',
        fieldEndLabelText: 'Đến Ngày',
        saveText: 'Lưu',
        cancelText: 'Hủy',
        confirmText: 'Chấp nhận');
    if (picked != null) {
      setState(() {
        absentPeriod = picked;
      });
    }
  }

  void _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      final res = await sl<SendAbsentRequest>().call(SendAbsentRequestParams(
          selectedChild,
          '7fba6d6c-137f-428c-958f-fe6160469be8',
          reason,
          '${absentPeriod!.start.toString().split(" ")[0]}',
          '${absentPeriod!.end.toString().split(" ")[0]}'));
      setState(() {
        _isLoading = false;
      });
      res.fold((l) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.message)),
        );
      }, (r) async {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đơn báo nghỉ được gửi thành công!")),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final cubit = context.read<RequestListCubit>();
    print('Cubit found: $cubit');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đơn báo nghỉ"),
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
              BlocBuilder<ChildrenListCubit, ChildrenListState>(
                builder: (context, state) {
                  if (state is ChildrenListSuccess) {
                    return DropdownButtonFormField<String>(
                      value: selectedChild,
                      decoration: InputDecoration(labelText: "Chọn con"),
                      items: state.data.map((child) {
                        return DropdownMenuItem(
                          value: child.id,
                          child: Text(child.name!),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => selectedChild = value),
                      validator: (value) =>
                          value == null ? "Xin hay chọn tên 1 con" : null,
                    );
                  }
                  return SizedBox();
                },
              ),
              SizedBox(height: 16),

              // Absent Period Picker
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Thời gian nghỉ",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: _pickAbsentPeriod,
                controller: TextEditingController(
                  text: absentPeriod == null
                      ? ""
                      : "${absentPeriod!.start.toString().split(" ")[0]} - ${absentPeriod!.end.toString().split(" ")[0]}",
                ),
                validator: (value) => absentPeriod == null
                    ? "XIn hãy chọn khoản thời gian nghỉ"
                    : null,
              ),
              SizedBox(height: 16),

              // Reason Input
              TextFormField(
                decoration: InputDecoration(
                    labelText: "Lý do", alignLabelWithHint: true),
                maxLines: 3,
                onChanged: (value) => reason = value,
                validator: (value) => (value == null || value.isEmpty)
                    ? "Xin hãy điền lý do"
                    : null,
              ),
              SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitRequest,
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text("Gửi"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
