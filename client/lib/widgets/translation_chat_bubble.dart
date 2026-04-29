import 'package:flutter/material.dart';
import '../models/message.dart';

class TranslationChatBubble extends StatefulWidget {
  final Message message;
  final bool isMe;

  const TranslationChatBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  State<TranslationChatBubble> createState() => _TranslationChatBubbleState();
}

class _TranslationChatBubbleState extends State<TranslationChatBubble> {
  bool _showOriginal = false;

  @override
  Widget build(BuildContext context) {
    // Logic: 
    // If user is receiver (!isMe), show translated_text by default.
    // If user is sender (isMe), show original_text by default.
    final String primaryText = widget.isMe 
        ? widget.message.originalText 
        : (widget.message.translatedText ?? widget.message.originalText);

    final String secondaryText = widget.isMe
        ? (widget.message.translatedText ?? widget.message.originalText)
        : widget.message.originalText;

    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          _showOriginal = !_showOriginal;
        });
      },
      child: Align(
        alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.isMe ? Colors.green[100] : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                primaryText,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              if (_showOriginal) ...[
                const Divider(height: 16, color: Colors.grey),
                Text(
                  secondaryText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
