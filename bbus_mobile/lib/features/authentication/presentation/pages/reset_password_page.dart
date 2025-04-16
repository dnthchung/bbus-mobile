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
            context.goNamed(RouteNames.login);
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
                  'Reset password',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          'Enter New Password',
                        ),
                        TextFormField(
                          controller: _newPasswordController,
                          decoration: InputDecoration(
                            hintText: 'New Password',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a new password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        Text(
                          'Confirm Password',
                        ),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            } else if (value != _newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ],
                    )),
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
                    'Send',
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
