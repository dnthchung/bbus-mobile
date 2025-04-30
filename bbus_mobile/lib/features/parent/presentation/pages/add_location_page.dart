import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/features/parent/domain/usecases/send_new_checkpoint_req.dart';
import 'package:bbus_mobile/features/parent/presentation/cubit/request_list/request_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddLocationPage extends StatefulWidget {
  const AddLocationPage({Key? key}) : super(key: key);

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reasonController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final reason = _reasonController.text.trim();
      final res =
          await sl<SendNewCheckpointReq>().call(SendNewCheckpointReqParams(
        '5c8da669-43e7-4e20-91a2-d53234ddd2f0',
        reason,
      ));
      setState(() {
        _isLoading = false;
      });
      res.fold((l) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.message)),
        );
      }, (r) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Yêu cầu đã được gửi thành công!")),
        );
        _reasonController.clear();
        context.pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn khác'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 4.0,
            children: [
              Text(
                'Bộ phận xử lý sẽ phản hồi trong vòng 48 giờ. Để tránh bị xem là SPAM, nếu gửi nhiều đơn/email cho cùng một nội dung, thời gian phản hồi sẽ tính theo công thức: Số đơn x 48h. Vì vậy, phụ huynh vui lòng cân nhắc trước khi gửi lặp lại để được hỗ trợ nhanh chóng.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Nội dung',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Điền nội dung vào đây'
                    : null,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleSubmit,
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
            ],
          ),
        ),
      ),
    );
  }
}
