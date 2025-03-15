import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/child_feature.dart/domain/entities/daily_schedule.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial());
  Future<void> getDailySchedule(DateTime date) async {
    if (isClosed) return;
    emit(HistoryLoading());
    logger.d(date.toIso8601String());
    try {
      DateTime normalizedInputDate = DateTime(date.year, date.month, date.day);
      // Find the schedule matching the selected date
      DailyScheduleEntity? schedule = mockDailySchedules.firstWhere(
        (schedule) {
          DateTime scheduleDate = DateTime.parse(schedule.date!);
          return scheduleDate.year == normalizedInputDate.year &&
              scheduleDate.month == normalizedInputDate.month &&
              scheduleDate.day == normalizedInputDate.day;
        },
        orElse: () => DailyScheduleEntity(
            id: -1,
            date: normalizedInputDate
                .toIso8601String()), // Default empty schedule
      );
      if (schedule.id != -1) {
        emit(HistorySuccess(schedule));
      } else {
        emit(HistoryEmpty());
      }
    } catch (e) {
      emit(HistoryFailure("Failed to load schedule"));
    }
  }
}
