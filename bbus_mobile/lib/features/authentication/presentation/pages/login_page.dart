import 'package:bbus_mobile/common/notifications/cubit/notification_cubit.dart';
import 'package:bbus_mobile/common/notifications/notification_service.dart';
import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/config/routes/routes.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/core/constants/app_text.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bbus_mobile/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
        body: Center(
            child: isSmallScreen
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      _Logo(),
                      _FormContent(),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Row(
                      children: const [
                        Expanded(child: _Logo()),
                        Expanded(
                          child: Center(child: _FormContent()),
                        ),
                      ],
                    ),
                  )));
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image(
          image: AssetImage('assets/logos/logo.png'),
          width: 100,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Welcome to BBUS!",
            textAlign: TextAlign.center,
            style: isSmallScreen
                ? Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: TColors.primary)
                : Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: TColors.primary),
          ),
        )
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void _login() {
    if (_formKey.currentState!.validate()) {
      final phoneNumber = _phoneController.text.trim();
      final password = _passwordController.text.trim();
      context.read<AuthCubit>().login(phoneNumber, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _phoneController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppText.phoneEmpty;
                }
                bool phoneValid = RegExp(r"^\d{10,15}").hasMatch(value);
                if (!phoneValid) {
                  return AppText.phoneValidateError;
                }
                return null;
              },
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: AppText.phoneLabel,
                hintText: AppText.enterPhone,
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppText.passwordEmpty;
                }

                if (value.length < 6) {
                  return AppText.passwordValidateError;
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                  labelText: AppText.passwordLabel,
                  hintText: AppText.enterPassword,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )),
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  context.pushNamed(RouteNames.forgotPassword);
                },
                child: Text(
                  'Quên mật khẩu?',
                  style: TextStyle(color: TColors.darkPrimary),
                ),
              ),
            ),
            // _gap(),
            // CheckboxListTile(
            //   value: _rememberMe,
            //   onChanged: (value) {
            //     if (value == null) return;
            //     setState(() {
            //       _rememberMe = value;
            //     });
            //   },
            //   title: const Text('Remember me'),
            //   controlAffinity: ListTileControlAffinity.leading,
            //   dense: true,
            //   contentPadding: const EdgeInsets.all(0),
            // ),
            _gap(),
            // BlocBuilder to show loading state
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthLoginLoading) {
                  return const CircularProgressIndicator();
                }
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    onPressed: _login,
                    child: Text(
                      AppText.loginButton,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
            BlocListener<AuthCubit, AuthState>(
              listener: (context, state) async {
                if (state is AuthLoginSucess) {
                  print(state.data.role);
                  if (state.data.role?.toLowerCase() == 'parent') {
                    await sl<NotificationService>()
                        .init(context.read<NotificationCubit>());
                    final fcmToken =
                        await sl<NotificationService>().getFcmToken();
                    logger.i('FCM Token: $fcmToken');
                    context.goNamed(RouteNames.parentChildren);
                  } else if (state.data.role?.toLowerCase() == 'driver') {
                    context.goNamed(RouteNames.driverSchedule);
                  } else {
                    context.goNamed(RouteNames.driverStudent);
                  }
                } else if (state is AuthLoginFailure) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  });
                }
              },
              child: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
