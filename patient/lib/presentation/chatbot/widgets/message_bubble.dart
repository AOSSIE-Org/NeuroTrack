import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isUserMessage;
  final EdgeInsetsGeometry? margin;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isUserMessage,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: isUserMessage 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        children: [
          if (!isUserMessage) ...[
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUserMessage 
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUserMessage ? 18 : 4),
                  bottomRight: Radius.circular(isUserMessage ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: isUserMessage 
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUserMessage) ...[
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}