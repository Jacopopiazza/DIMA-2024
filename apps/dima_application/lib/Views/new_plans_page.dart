import 'package:flutter/material.dart';

class NewPlansPage extends StatefulWidget {
  const NewPlansPage({super.key});

  @override
  _NewPlansPageState createState() => _NewPlansPageState();
}

class _NewPlansPageState extends State<NewPlansPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // This function handles the send action.
  void _sendMessage() {
    final String message = _controller.text;
    if (message.isNotEmpty) {
      // Process or display the message as needed.
      print('Sending: $message');
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Expanded container used as a placeholder for the conversation.
        Expanded(
          child: Container(
            color: Colors.grey[100],
            child: const Center(child: Text('Conversation goes here')),
          ),
        ),
        // Bottom container that has the input field and the send button.
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          color: Colors.grey[200],
          child: Row(
            children: [
              // Input field for text.
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Tell me everything...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Button to send the message.
              ElevatedButton(
                onPressed: _sendMessage,
                child: const Text('Generate Diet'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
