import 'dart:async';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<String> _messageController =
      StreamController.broadcast();

  WebSocketService._privateConstructor();

  static final WebSocketService _instance =
      WebSocketService._privateConstructor();

  factory WebSocketService() {
    return _instance;
  }

  Future<void> connect(String url) async {
    if (_channel != null) return; // Prevent duplicate connections

    _channel = IOWebSocketChannel.connect(url);
    _channel!.stream.listen((message) {
      logger.i(message);
      _messageController.add(message);
    }, onDone: () {
      _channel = null; // Reset when closed
    }, onError: (error) {
      _channel = null; // Handle errors
    });
  }

  void sendMessage(String message) {
    if (_channel != null) {
      _channel!.sink.add(message);
    }
  }

  Stream<String> get messageStream => _messageController.stream;

  Future<void> close() async {
    await _channel?.sink.close();
    _channel = null;
  }
}
