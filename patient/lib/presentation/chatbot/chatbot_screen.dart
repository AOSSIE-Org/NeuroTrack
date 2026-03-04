import 'dart:async';
import 'package:flutter/material.dart';
import 'package:patient/core/services/voice_service.dart';
import 'package:patient/presentation/chatbot/widgets/message_bubble.dart';

import 'util/chat_manager.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _textController = TextEditingController();
  final VoiceService _voiceService = VoiceService.instance;

  bool _isListening = false;
  int _lastSpokenMessageCount = 0;

  StreamSubscription<String>? _speechSubscription;
  StreamSubscription<bool>? _listeningSubscription;
  StreamSubscription<List<ChatMessageModel>>? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _voiceService.initialize();

    _speechSubscription = _voiceService.speechStream.listen((text) {
      if (text.isNotEmpty) {
        _textController.text = text;
        _handleSend();
      }
    });

    _listeningSubscription = _voiceService.listeningStream.listen((isListening) {
      setState(() => _isListening = isListening);
    });

    _messageSubscription = ChatManager.instance.messageStream.skip(1).listen((messages) {
      if (messages.isEmpty) return;
      final last = messages.last;
      if (messages.length > _lastSpokenMessageCount &&
          last.type != ChatMessageType.user &&
          last.type != ChatMessageType.typing) {
        _lastSpokenMessageCount = messages.length;
        _voiceService.speak(last.text);
      }
    });
  }

  void _handleSend() {
    final String inputText = _textController.text.trim();
    if (inputText.isEmpty) return;

    ChatManager.instance.addMessage(inputText, ChatMessageType.user);
    ChatManager.instance.sendResponseFromChatbot(inputText);
    _textController.clear();
    setState(() {});
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _voiceService.stopListening();
    } else {
      final started = await _voiceService.startListening();
      if (!started && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microphone unavailable. Please check permissions.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Widget _buildSearchField() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 30),
      child: TextField(
        controller: _textController,
        textInputAction: TextInputAction.send,
        onSubmitted: (_) => _handleSend(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          hintText: 'Type or speak a message',
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none_rounded,
                  color: _isListening ? Colors.red : const Color(0xff7A86F8),
                ),
                onPressed: _toggleListening,
                tooltip: _isListening ? 'Stop listening' : 'Speak',
              ),
              IconButton(
                icon: const Icon(Icons.send_rounded),
                color: const Color(0xff7A86F8),
                onPressed: _handleSend,
                tooltip: 'Send',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _speechSubscription?.cancel();
    _listeningSubscription?.cancel();
    _messageSubscription?.cancel();
    _voiceService.stopListening();
    _voiceService.stopSpeaking();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: _buildSearchField(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff7A86F8),
        title: const Text(
          'NeuroBot',
           style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<List<ChatMessageModel>>(
        stream: ChatManager.instance.messageStream,
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final ChatMessageModel message = snapshot.data![index];
                if (message.type == ChatMessageType.typing) {
                  return const TypingBubble();
                }
                return MessageBubble(
                  message: message.text,
                  isUserMessage: message.type == ChatMessageType.user,
                );
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      )
    );
  }
}