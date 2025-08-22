import 'package:flutter/material.dart';
import 'package:patient/presentation/chatbot/widgets/message_bubble.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  Widget _buildSearchField() {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 30),
        child:  TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            hintText: 'Search',
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
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
      body: const SingleChildScrollView(
        child: Column(
          children: [
            MessageBubble(message: 'Hello', isUserMessage: true),
            MessageBubble(message: 'Hello', isUserMessage: false),
          ],
        ),
      )
    );
  }
}