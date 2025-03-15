part of 'history_cubit.dart';

@immutable
abstract class HistoryState extends Equatable {
  const HistoryState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class HistoryInitial extends HistoryState {}

final class HistoryLoading extends HistoryState {}

final class HistoryEmpty extends HistoryState {}

final class HistorySuccess extends HistoryState {
  final DailyScheduleEntity dailySchedule;
  const HistorySuccess(this.dailySchedule);
}

final class HistoryFailure extends HistoryState {
  final String message;
  const HistoryFailure(this.message);
}
