import 'package:flutter/material.dart';
import 'package:therapist/presentation/chatbot/widgets/message_bubble.dart';
import 'package:therapist/core/services/voice_service.dart';

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
  bool _isSpeaking = false;
  bool _isVoiceMode = false;

  @override
  void initState() {
    super.initState();
    _voiceService.initialize();
    _setupVoiceListeners();
  }

  void _setupVoiceListeners() {
    _voiceService.listeningStream.listen((isListening) {
      setState(() {
        _isListening = isListening;
      });
    });

    _voiceService.speakingStream.listen((isSpeaking) {
      setState(() {
        _isSpeaking = isSpeaking;
      });
    });

    _voiceService.speechStream.listen((speechText) {
      if (speechText.isNotEmpty) {
        _textController.text = speechText;
        _handleSend();
      }
    });
  }

  void _handleSend() {
    final String inputText = _textController.text.trim();
    if (inputText.isEmpty) return;

    ChatManager.instance.addMessage(inputText, ChatMessageType.user);
    ChatManager.instance.sendResponseFromChatbot(inputText, isVoiceMode: _isVoiceMode);
    _textController.clear();
    setState(() {});
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _voiceService.stopListening();
    } else {
      await _voiceService.startListening();
    }
  }

  Future<void> _speakLastBotMessage() async {
    final messages = ChatManager.instance.currentMessages;
    if (messages.isNotEmpty) {
      final lastBotMessage = messages.lastWhere(
        (msg) => msg.type == ChatMessageType.chatbot,
        orElse: () => const ChatMessageModel('', ChatMessageType.chatbot),
      );
      if (lastBotMessage.text.isNotEmpty) {
        await _voiceService.speak(lastBotMessage.text);
      }
    }
  }

  void _toggleVoiceMode() {
    setState(() {
      _isVoiceMode = !_isVoiceMode;
    });
  }

  Widget _buildSearchField() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 30),
      child: Row(
        children: [
          GestureDetector(
            onTap: _toggleListening,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _isListening ? Colors.red : const Color(0xff7A86F8),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (_isListening ? Colors.red : const Color(0xff7A86F8)).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          Expanded(
            child: TextField(
              controller: _textController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _handleSend(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: _isListening ? 'Listening...' : 'Type your message',
                hintStyle: TextStyle(
                  color: _isListening ? Colors.red : Colors.grey,
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
                        _isVoiceMode ? Icons.volume_up : Icons.volume_off,
                        color: _isVoiceMode ? const Color(0xff7A86F8) : Colors.grey,
                      ),
                      onPressed: _toggleVoiceMode,
                      tooltip: _isVoiceMode ? 'Voice Mode ON' : 'Voice Mode OFF',
                    ),
                    // Send button
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
          ),
          
          const SizedBox(width: 8),
          
          GestureDetector(
            onTap: _speakLastBotMessage,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _isSpeaking ? Colors.green : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isSpeaking ? Icons.volume_up : Icons.volume_down,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _voiceService.stopListening();
    _voiceService.stopSpeaking();
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
        backgroundColor: Colors.purple,
        title: Row(
          children: [
            const Text(
              'NeuroBot',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            if (_isVoiceMode)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            if (_isListening)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            if (_isSpeaking)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
          ],
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