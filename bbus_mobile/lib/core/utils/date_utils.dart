import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:intl/intl.dart';

int dobStringToAge(String dobString) {
  try {
    final dob = DateTime.parse(dobString);
    final today = DateTime.now();
    int age = today.year - dob.year;

    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  } catch (e) {
    // In case the string is not a valid date
    print('Invalid DOB format: $dobString');
    return 0;
  }
}

final df = DateFormat('yyyy-MM-dd');
DateTime fromStringToDate(String date) {
  return df.parse(date);
}

String fromDatetoString(DateTime date) {
  return df.format(date);
}

String formatStringDate(String date) {
  try {
    final dateTime = DateTime.parse(date); // Parses ISO 8601 format
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime.toLocal());
  } catch (e) {
    logger.e('Error formatting date: $date', error: e);
    return date; // Return the original string if parsing fails
  }
}

bool isNowBetween(DateTime start, DateTime end) {
  final now = DateTime.now();
  logger.d('isNowBetween: $now, start: $start, end: $end');
  return now.isAfter(start) && now.isBefore(end);
}

DateTime parseAsLocal(String input) {
  // Remove timezone part if exists
  final cleanedInput = input.split('+').first;
  print(cleanedInput);
  return DateTime.parse(cleanedInput);
}
