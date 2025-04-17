import 'package:bbus_mobile/config/routes/routes.dart';
import 'package:bbus_mobile/core/constants/app_text.dart';
import 'package:bbus_mobile/features/authentication/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgotPasswordCubit>();
    final _phoneController = cubit.phoneController;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quên mật khẩu',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                'Yêu cầu xác thực sẽ được gửi qua email của bạn',
                style: TextStyle(fontSize: 15.5),
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    bool phoneValid =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value);
                    if (!phoneValid) {
                      return 'Email không hợp lệ';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.mail),
                    suffixIcon: IconButton(
                      onPressed: () {
                        cubit.phoneController.clear();
                      },
                      icon: Icon(Icons.clear),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print('validate');
                      context
                          .read<ForgotPasswordCubit>()
                          .sendOtpRequest(_phoneController.text.trim());
                      context.pushNamed(RouteNames.otpVerification,
                          pathParameters: {'phone': _phoneController.text});
                    }
                  },
                  child: Text(
                    'Lấy OTP',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
