import 'package:bbus_mobile/features/change_password/cubit/change_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<ChangePasswordCubit, ChangePasswordState>(
          listener: (context, state) {
            if (state is ChangePasswordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đổi mật khẩu thành công!')),
              );
            } else if (state is ChangePasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _currentPasswordController,
                  decoration: InputDecoration(labelText: 'Mật khẩu cũ'),
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? 'Mật khẩu cũ trống!' : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Mật khẩu mới'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    if (value.length < 8) {
                      return 'Mật khẩu cần chứa ít nhất 8 ký tự';
                    }
                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return 'Mật khẩu cần chứa ít nhất 1 chữ cái viết hoa';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration:
                      InputDecoration(labelText: 'Xác nhận mật khẩu mới'),
                  obscureText: true,
                  validator: (value) => value != _passwordController.text
                      ? 'Mật khẩu không khớp'
                      : null,
                ),
                SizedBox(height: 20),
                BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is ChangePasswordLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context
                                    .read<ChangePasswordCubit>()
                                    .changePassword(
                                        _currentPasswordController.text.trim(),
                                        _passwordController.text.trim(),
                                        _confirmPasswordController.text.trim());
                              }
                            },
                      child: state is ChangePasswordLoading
                          ? CircularProgressIndicator()
                          : Text('Thay đổi'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
