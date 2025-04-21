import 'dart:async';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:bbus_mobile/core/utils/logger.dart';

class MultiWebSocketService {
  final Map<String, WebSocketChannel> _channels = {};
  final Map<String, StreamController<String>> _controllers = {};

  MultiWebSocketService._privateConstructor();

  static final MultiWebSocketService _instance =
      MultiWebSocketService._privateConstructor();

  factory MultiWebSocketService() => _instance;

  Future<void> connect(String key, String url) async {
    if (_channels.containsKey(key)) return;

    final channel = IOWebSocketChannel.connect(url);
    final controller = StreamController<String>.broadcast();

    channel.stream.listen((message) {
      logger.i('[$key] $message');
      controller.add(message);
    }, onDone: () {
      logger.i('[$key] WebSocket closed');
      _channels.remove(key);
      _controllers.remove(key);
      controller.close();
    }, onError: (error) {
      logger.e('[$key] WebSocket error: $error');
      _channels.remove(key);
      _controllers.remove(key);
      controller.close();
    });

    _channels[key] = channel;
    _controllers[key] = controller;
  }

  void sendMessage(String key, String message) {
    final channel = _channels[key];
    if (channel != null) {
      channel.sink.add(message);
    }
  }

  Stream<String>? getMessageStream(String key) => _controllers[key]?.stream;

  Future<void> close(String key) async {
    final channel = _channels[key];
    final controller = _controllers[key];

    await channel?.sink.close();
    await controller?.close();

    _channels.remove(key);
    _controllers.remove(key);
  }

  Future<void> closeAll() async {
    for (final key in _channels.keys) {
      await _channels[key]?.sink.close();
      await _controllers[key]?.close();
    }
    _channels.clear();
    _controllers.clear();
  }
}
