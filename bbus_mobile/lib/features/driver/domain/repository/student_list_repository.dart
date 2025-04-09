import 'dart:async';
import 'dart:convert';

import 'package:bbus_mobile/common/entities/child.dart';
import 'package:bbus_mobile/common/websocket/websocket_service.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:dartz/dartz.dart';

abstract class StudentListRepository {
  Stream<List<ChildEntity>> getStudentListStream();
}

class StudentListRepositoryImpl implements StudentListRepository {
  final WebSocketService _webSocketService;
  final Map<String, ChildEntity> _students = {};
  StreamController<List<ChildEntity>>? _studentController;
  StudentListRepositoryImpl(this._webSocketService);
  @override
  Stream<List<ChildEntity>> getStudentListStream() async* {
    _studentController ??= StreamController<List<ChildEntity>>.broadcast();

    _webSocketService.messageStream.listen((String message) {
      try {
        final decoded = json.decode(message);

        if (decoded is Map<String, dynamic>) {
          final student = ChildEntity.fromJson(decoded);
          _students[student.id!] = student;
          _studentController?.add(_students.values.toList());
        } else {
          logger.w("Received message is not a valid JSON object: $message");
        }
      } catch (e, stacktrace) {
        logger.e("Error decoding WebSocket message",
            error: e, stackTrace: stacktrace);
      }
    });
  }
}
