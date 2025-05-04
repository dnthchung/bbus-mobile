import 'package:bbus_mobile/config/routes/routes.dart';
import 'package:bbus_mobile/features/authentication/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordPage extends StatelessWidget {
  final String sessionId;
  final _formKey = GlobalKey<FormState>();
  ResetPasswordPage({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    final _newPasswordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();
    return SafeArea(
      child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is PasswordResetSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Đổi mật khẩu mới thành công!')),
            );
            context.goNamed(RouteNames.login);
            context.read<ForgotPasswordCubit>().restart();
          } else if (state is ForgotPasswordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  context.goNamed(RouteNames.login);
                },
                icon: Icon(Icons.clear)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Đổi mật khẩu mới',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      spacing: 8.0,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nhập mật khẩu mới',
                        ),
                        TextFormField(
                          controller: _newPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Mật khẩu mới',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Xin hãy nhập mật khẩu mới';
                            } else if (value.length < 8) {
                              return 'Mật khẩu cần ít nhất 8 ký tự';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Text(
                          'Xác nhận mật khẩu mới',
                        ),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Nhập lại mật khẩu',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Xin hãy xác nhận mật khẩu mới';
                            } else if (value != _newPasswordController.text) {
                              return 'Mật khẩu xác nhận không khớp';
                            }
                            return null;
                          },
                        ),
                      ],
                    )),
                SizedBox(
                  height: 8.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<ForgotPasswordCubit>().resetPassword(
                          sessionId: sessionId,
                          newPassword: _newPasswordController.text,
                          confirmPassword: _confirmPasswordController.text);
                    }
                  },
                  child: Text(
                    'Gửi',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
