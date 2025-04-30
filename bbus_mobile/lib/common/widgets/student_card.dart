import 'package:bbus_mobile/common/entities/student.dart';
import 'package:bbus_mobile/common/widgets/result_dialog.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/features/driver/student_list/cubit/student_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentCard extends StatelessWidget {
  final StudentEntity student;
  final bool routeEnded;
  final bool isAssistant;
  const StudentCard({
    super.key,
    required this.student,
    required this.routeEnded,
    required this.isAssistant,
  });
  String getCustomStatus() {
    if ((student.checkin == null || student.checkin!.isEmpty) &&
        (student.checkout == null || student.checkout!.isEmpty)) {
      return 'Vắng';
    } else if ((student.checkin != null && student.checkin!.isNotEmpty) &&
        (student.checkout == null || student.checkout!.isEmpty)) {
      return 'Trên xe';
    } else {
      return 'Đã trả về';
    }
  }

  void _openMarkAttendanceModal(
      BuildContext context, String attendanceType) async {
    // showDialog(
    //   context: context,
    //   builder: (_) => CameraPopup(
    //     cameras: sl<List<CameraDescription>>(),
    //     onNext: (XFile image) async {
    //       final Uint8List bytes = await image.readAsBytes();
    //       print('Captured image path: ${image.path}');
    //       FormData formData = FormData.fromMap({
    //         'file': MultipartFile.fromBytes(bytes,
    //             filename: '$studentId-${DateTime.now()}.jpg')
    //       });
    //     },
    //   ),
    // );
    final result = await ResultDialog.show(
      context,
      title: 'Điểm danh',
      message:
          'Bạn có chắc chắn muốn điểm danh học sinh ${student.studentName}?',
      cancelText: 'Hủy',
    );
    print('User Ok: $result');
    if (result!) {
      if (attendanceType == 'checkin') {
        context
            .read<StudentListCubit>()
            .markAttendance(student.id!, DateTime.now(), null);
      } else {
        context
            .read<StudentListCubit>()
            .markAttendance(student.id!, null, DateTime.now());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.network(
                    student.avatarUrl!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Image(
                        image: AssetImage('assets/images/default_child.png'),
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${student.studentName} (${student.rollNumber})',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                student.checkpointName ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: getCustomStatus() == "Trên xe"
                                        ? TColors.secondary
                                        : getCustomStatus() == "Đã trả về"
                                            ? Colors.orange
                                            : Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(getCustomStatus()),
                              ],
                            ),
                            const Spacer(),
                            !isAssistant
                                ? SizedBox()
                                : (student.checkin == null &&
                                        student.checkout == null &&
                                        !routeEnded)
                                    // )
                                    ? ElevatedButton(
                                        onPressed: () {
                                          _openMarkAttendanceModal(
                                              context, 'checkin');
                                        },
                                        child: Text('Checkin'))
                                    : (student.checkin != null &&
                                            student.checkout == null &&
                                            !routeEnded)
                                        // )
                                        ? ElevatedButton(
                                            onPressed: () {
                                              _openMarkAttendanceModal(
                                                  context, 'checkout');
                                            },
                                            child: Text('Checkout'))
                                        : SizedBox(),
                            // else
                            //   Container(
                            //     padding: const EdgeInsets.symmetric(
                            //         horizontal: 12, vertical: 6),
                            //     decoration: BoxDecoration(
                            //       color: Colors.grey.shade300,
                            //       borderRadius: BorderRadius.circular(8),
                            //     ),
                            //     child: Text(
                            //       status,
                            //       style: const TextStyle(
                            //           fontSize: 14,
                            //           fontWeight: FontWeight.w500),
                            //     ),
                            //   ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
