import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/chat_provider.dart';
import 'widgets/translation_chat_bubble.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: const TranslationChatApp(),
    ),
  );
}

class TranslationChatApp extends StatelessWidget {
  const TranslationChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translation Chat',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _login(BuildContext context, String userId, String receiverId) {
    context.read<ChatProvider>().init('http://localhost:3000', userId);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatScreen(receiverId: receiverId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _login(context, 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22'),
              child: const Text('Login as User A (to User B)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _login(context, 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'),
              child: const Text('Login as User B (to User A)'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String receiverId;
  const ChatScreen({super.key, required this.receiverId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  final Map<String, String> _languages = {
    'en': 'English',
    'es': 'Spanish',
    'fr': 'French',
    'zu': 'Zulu',
    'de': 'German',
    'it': 'Italian',
    'pt': 'Portuguese',
  };

  void _handleSend() {
    if (_controller.text.trim().isEmpty) return;
    
    final provider = context.read<ChatProvider>();
    provider.sendMessage(
      widget.receiverId,
      _controller.text.trim(),
      provider.sourceLang,
      provider.targetLang,
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Translation Chat')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[200],
            child: Consumer<ChatProvider>(
              builder: (context, provider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('Me: '),
                        DropdownButton<String>(
                          value: provider.sourceLang,
                          onChanged: (val) => provider.setSourceLang(val!),
                          items: _languages.entries.map((e) => DropdownMenuItem(
                            value: e.key,
                            child: Text(e.value),
                          )).toList(),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward),
                    Row(
                      children: [
                        const Text('Them: '),
                        DropdownButton<String>(
                          value: provider.targetLang,
                          onChanged: (val) => provider.setTargetLang(val!),
                          items: _languages.entries.map((e) => DropdownMenuItem(
                            value: e.key,
                            child: Text(e.value),
                          )).toList(),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: provider.messages.length,
                  itemBuilder: (context, index) {
                    final message = provider.messages[index];
                    return TranslationChatBubble(
                      message: message,
                      isMe: message.senderId == provider.currentUserId,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _handleSend,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
