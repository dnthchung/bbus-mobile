import 'package:bbus_mobile/config/routes/routes.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/features/authentication/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerifyPage extends StatefulWidget {
  final String phoneNumber;
  const OtpVerifyPage({super.key, required this.phoneNumber});

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  final _otpController = TextEditingController();
  bool _isOtpComplete = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is OtpVerified) {
          context.pushReplacementNamed(RouteNames.resetPassword,
              pathParameters: {'sessionId': state.sessionId});
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
                context.pop();
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SvgPicture.asset(
              //   AppImages.scanIcon,
              //   height: 65.0, // Adjust the size of the icon if necessary
              //   width: 65.0,
              // ), // Add your logo here
              const SizedBox(height: 20),
              Text(
                'OTP Verification',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'We have sent an OTP on given number ${widget.phoneNumber}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                  builder: (context, state) {
                if (state is OtpCountdownTick) {
                  return Text(
                    '00:${state.secondsRemaining.toString().padLeft(2, '0')}',
                    style: TextStyle(color: TColors.primary),
                  );
                } else if (state is OtpExpired) {
                  return Text('Your otp has expired please resend');
                }
                return SizedBox.shrink();
              }),
              SizedBox(height: MediaQuery.of(context).size.width * 0.04),
              PinCodeTextField(
                appContext: context,
                length: 4,
                controller: _otpController,
                onChanged: (value) {
                  setState(() {
                    _isOtpComplete = value.length == 4;
                  });
                },
                autoDismissKeyboard: true,
                enablePinAutofill: true,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(15),
                  fieldHeight: 75,
                  fieldWidth: 75,
                  activeColor: TColors.accent,
                  activeFillColor: Colors.white,
                  selectedColor: TColors.accent,
                  selectedFillColor: TColors.primary,
                  inactiveColor: Colors.grey,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text('Dont receive the OTP? '),
                  GestureDetector(
                    onTap: () {
                      _otpController.clear();
                      context
                          .read<ForgotPasswordCubit>()
                          .sendOtpRequest(widget.phoneNumber);
                    },
                    child: Text(
                      'RESEND OTP',
                      style: TextStyle(
                        color: TColors.primary,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isOtpComplete
                    ? () {
                        context
                            .read<ForgotPasswordCubit>()
                            .verifyOtp(_otpController.text);
                      }
                    : null,
                child: Text('VERIFY'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
