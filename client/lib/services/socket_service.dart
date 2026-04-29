import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/message.dart';

class SocketService {
  late IO.Socket _socket;
  final _messageController = StreamController<Message>.broadcast();

  Stream<Message> get messageStream => _messageController.stream;

  void connect(String serverUrl, String userId) {
    _socket = IO.io(serverUrl, 
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect()
        .build()
    );

    _socket.onConnect((_) {
      print('Connected to socket server. Identifying as: $userId');
      _socket.emit('identify', userId);
    });

    _socket.on('receive_message', (data) {
      final message = Message.fromJson(data);
      _messageController.add(message);
    });

    _socket.on('message_sent', (data) {
       final message = Message.fromJson(data);
       _messageController.add(message);
    });

    _socket.onDisconnect((_) => print('Disconnected from socket server'));
  }

  void sendMessage(String senderId, String receiverId, String text, String sourceLang, String targetLang) {
    final payload = {
      'senderId': senderId,
      'receiverId': receiverId,
      'originalText': text,
      'sourceLang': sourceLang,
      'targetLang': targetLang,
    };
    _socket.emit('send_message', payload);
  }

  void dispose() {
    _messageController.close();
    _socket.dispose();
  }
}
