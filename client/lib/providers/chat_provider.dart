import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/message.dart';
import '../services/socket_service.dart';

class ChatProvider with ChangeNotifier {
  final SocketService _socketService = SocketService();
  final List<Message> _messages = [];
  final _uuid = const Uuid();
  String _currentUserId = '';
  String _sourceLang = 'en';
  String _targetLang = 'es';

  List<Message> get messages => List.unmodifiable(_messages);
  String get currentUserId => _currentUserId;
  String get sourceLang => _sourceLang;
  String get targetLang => _targetLang;

  void setSourceLang(String lang) {
    _sourceLang = lang;
    notifyListeners();
  }

  void setTargetLang(String lang) {
    _targetLang = lang;
    notifyListeners();
  }

  void init(String serverUrl, String userId) {
    _currentUserId = userId;
    _socketService.connect(serverUrl, userId);
    _socketService.messageStream.listen((message) {
      // Check if message already exists (from optimistic UI or previous events)
      final index = _messages.indexWhere((m) => m.id == message.id || 
          (m.senderId == message.senderId && m.originalText == message.originalText && m.id.startsWith('temp-')));
      
      if (index != -1) {
        _messages[index] = message; // Update temporary message with real one from server
      } else {
        _messages.add(message);
      }
      notifyListeners();
    });
  }

  void sendMessage(String receiverId, String text, String sourceLang, String targetLang) {
    final tempId = 'temp-${_uuid.v4()}';
    final tempMessage = Message(
      id: tempId,
      senderId: _currentUserId,
      receiverId: receiverId,
      originalText: text,
      sourceLang: sourceLang,
      targetLang: targetLang,
      createdAt: DateTime.now(),
    );

    _messages.add(tempMessage);
    notifyListeners();

    _socketService.sendMessage(_currentUserId, receiverId, text, sourceLang, targetLang);
  }

  @override
  void dispose() {
    _socketService.dispose();
    super.dispose();
  }
}
