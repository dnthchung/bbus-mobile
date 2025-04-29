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
