part of 'forgot_password_cubit.dart';

@immutable
sealed class ForgotPasswordState {}

final class ForgotPasswordInitial extends ForgotPasswordState {}

final class ForgotPasswordLoading extends ForgotPasswordState {}

final class OtpSent extends ForgotPasswordState {
  final int phomeNumber;
  OtpSent(this.phomeNumber);
}

class OtpCountdownTick extends ForgotPasswordState {
  final int secondsRemaining;
  OtpCountdownTick(this.secondsRemaining);
}

class OtpExpired extends ForgotPasswordState {}

final class OtpVerified extends ForgotPasswordState {
  final String sessionId;
  OtpVerified(this.sessionId);
}

final class PasswordResetSuccess extends ForgotPasswordState {}

final class PasswordResetError extends ForgotPasswordState {
  final String message;
  PasswordResetError(this.message);
}

final class OtpVerifiedError extends ForgotPasswordState {
  final String message;
  OtpVerifiedError(this.message);
}

final class ForgotPasswordError extends ForgotPasswordState {
  final String message;
  ForgotPasswordError(this.message);
}

final class ForgotPasswordSuccess extends ForgotPasswordState {}
