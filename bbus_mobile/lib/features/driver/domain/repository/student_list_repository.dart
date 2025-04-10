import 'dart:async';
import 'dart:convert';

import 'package:bbus_mobile/common/entities/student.dart';
import 'package:bbus_mobile/common/websocket/websocket_service.dart';
import 'package:bbus_mobile/core/cache/secure_local_storage.dart';
import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/driver/datasources/student_list_datasource.dart';

abstract class StudentListRepository {
  Stream<List<StudentEntity>> getStudentListStream();
  Future<void> start(String busId, int direction);
  Future<void> stop();
  Future<List<StudentEntity>> fetchInitialList(int direction);
}

class StudentListRepositoryImpl implements StudentListRepository {
  final WebSocketService _webSocketService;
  final SecureLocalStorage _secureLocalStorage;
  final StudentListDatasource _studentListDatasource;
  final Map<String, StudentEntity> _students = {};
  StreamController<List<StudentEntity>>? _controller;
  bool _isConnected = false;
  int? _currentDirection;
  StudentListRepositoryImpl(this._webSocketService, this._secureLocalStorage,
      this._studentListDatasource);
  // 'uuid/direction/student-status' with 0 means pick up, 1 means drop off
  // const topic = 'a86c203c-4774-430d-821d-9668832aaace/0/student-status';
  @override
  Future<void> start(String busId, int direction) async {
    if (_isConnected && _currentDirection == direction) return;

    if (_isConnected && _currentDirection != direction) {
      await stop();
    }
    final userId = await _secureLocalStorage.load(key: 'userId');

    await _webSocketService.connect(
        '${ApiConstants.socketAddress}/$busId/$direction/student-status');

    _controller = StreamController<List<StudentEntity>>.broadcast();
    _webSocketService.messageStream.listen(_handleMessage);

    _isConnected = true;
    _currentDirection = direction;
  }

  void _handleMessage(String message) {
    try {
      logger.i(message);
      final decoded = json.decode(message);

      if (decoded is List) {
        for (var item in decoded) {
          final student = StudentEntity.fromJson(item);
          _students[student.studentId!] = student;
        }
      } else if (decoded is Map<String, dynamic>) {
        final student = StudentEntity.fromJson(decoded);
        _students[student.studentId!] = student;
      } else if (decoded is String) {
        return;
      }

      _controller?.add(_students.values.toList());
    } catch (e, stacktrace) {
      logger.e("Error decoding WebSocket message",
          error: e, stackTrace: stacktrace);
    }
  }

  @override
  Stream<List<StudentEntity>> getStudentListStream() {
    _controller ??= StreamController<List<StudentEntity>>.broadcast();
    return _controller!.stream;
  }

  @override
  Future<void> stop() async {
    await _webSocketService.close();
    await _controller?.close();
    _controller = null;
    _students.clear();
    _isConnected = false;
    _currentDirection = null;
  }

  @override
  Future<List<StudentEntity>> fetchInitialList(int direction) async {
    final response = await _studentListDatasource.getStudentList();
    for (final s in response) {
      _students[s.studentId!] = s;
    }
    return response;
  }
}
