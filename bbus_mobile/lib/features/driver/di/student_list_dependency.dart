import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/features/driver/student_list/cubit/student_list_cubit.dart';

class StudentListDependency {
  StudentListDependency._();
  static void initStudentList() {
    // Bloc
    sl..registerFactory<StudentListCubit>(() => StudentListCubit());
  }
}
