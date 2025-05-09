part of 'current_user_cubit.dart';

@immutable
sealed class CurrentUserState extends Equatable {
  const CurrentUserState();
  @override
  List<Object?> get props => [];
}

final class CurrentUserInitial extends CurrentUserState {}

final class CurrentUserUpdating extends CurrentUserState {}

final class CurrentUserLoggedIn extends CurrentUserState {
  final UserEntity user;
  CurrentUserLoggedIn(this.user);

  @override
  List<Object?> get props => [user];
}

final class CurrentUserUpdated extends CurrentUserState {
  final UserEntity user;
  CurrentUserUpdated(this.user);

  @override
  List<Object?> get props => [user];
}
