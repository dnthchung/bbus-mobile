import 'dart:async';

import 'package:bbus_mobile/features/authentication/data/models/reset_password_model.dart';
import 'package:bbus_mobile/features/authentication/domain/usecases/get_otp_by_phone.dart';
import 'package:bbus_mobile/features/authentication/domain/usecases/reset_password.dart';
import 'package:bbus_mobile/features/authentication/domain/usecases/verify_otp.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final GetOtpByPhone _getOtpByPhone;
  final ResetPassword _resetPassword;
  final VerifyOtp _verifyOtp;
  final TextEditingController phoneController = TextEditingController();

  Timer? _otpTimer;
  static const int _otpDuration = 300;
  ForgotPasswordCubit(this._getOtpByPhone, this._resetPassword, this._verifyOtp)
      : super(ForgotPasswordInitial());
  void restart() {
    emit(ForgotPasswordInitial());
  }

  Future<void> sendOtpRequest(String phoneNumber) async {
    emit(ForgotPasswordLoading());
    final res = await _getOtpByPhone.call(phoneNumber);
    res.fold((l) => emit(ForgotPasswordError(l.message)), (r) {
      _startOtpCountdown();
      emit(ForgotPasswordSuccess());
    });
  }

  Future<void> verifyOtp(String otp) async {
    emit(ForgotPasswordLoading());
    if (state is OtpExpired) {
      emit(OtpVerifiedError('Otp Expired'));
      return;
    }
    final res =
        await _verifyOtp.call(VerifyOtpParams(phoneController.text, otp));
    res.fold((l) {
      emit(OtpVerifiedError(l.message));
      _otpTimer?.cancel();
    }, (r) => emit(OtpVerified(r)));
  }

  void _startOtpCountdown() {
    emit(OtpCountdownTick(_otpDuration));
    int timeLeft = _otpDuration;
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      timeLeft--;
      if (timeLeft > 0) {
        emit(OtpCountdownTick(timeLeft));
      } else {
        _otpTimer?.cancel();
        emit(OtpExpired());
      }
    });
  }

  Future<void> resetPassword(
      {required String sessionId,
      required String newPassword,
      required String confirmPassword}) async {
    emit(ForgotPasswordLoading());
    final res = await _resetPassword.call(ResetPasswordModel(
        sessionId: sessionId,
        password: newPassword,
        confirmPassword: confirmPassword));
    res.fold((l) => emit(PasswordResetError(l.message)),
        (r) => emit(PasswordResetSuccess()));
  }

  @override
  Future<void> close() {
    phoneController.dispose();
    return super.close();
  }
}
