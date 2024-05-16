import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

typedef SocketConnectCallback = void Function(String);

typedef ReceivedMessageListener = void Function(String, String);

class SocketHelper {
  static Socket? _socket;

  static Map<String, ReceivedMessageListener> _receivedMessageListeners = {};

  static void connect(
    String host,
    int port, {
    required VoidCallback onClose,
    required SocketConnectCallback onConnect,
  }) async {
    try {
      _socket = await Socket.connect(host, port);
      _socket?.cast<List<int>>().transform(utf8.decoder).listen(
        _receivedMsgHandler,
        onError: (e) {
          // print("onError: $e");
          onClose.call();
        },
        onDone: onClose,
        cancelOnError: true,
      );
    } on SocketException catch (e) {
      onConnect.call(e.toString());
      return;
    } catch (e) {
      onConnect.call(e.toString());
      return;
    }

    onConnect.call("连接成功");
  }

  static void close() {
    _receivedMessageListeners.clear();
    _socket?.close();
    _socket?.destroy();
  }

  static void sendMessage(String msg, ReceivedMessageListener listener) {
    _receivedMessageListeners.remove(msg);
    _receivedMessageListeners[msg] = listener;

    _socket?.writeln(msg);
    _socket?.flush();
  }

  static void _receivedMsgHandler(String msg) {
    final last = _receivedMessageListeners.entries.last;
    last.value.call(last.key, msg);
  }
}
