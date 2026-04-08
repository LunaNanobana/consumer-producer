
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessengerScreen extends StatelessWidget {
  const MessengerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messenger'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Text('KF', style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
            title: const Text('KAZAKH FRESH'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatDetailScreen(supplierName: 'KAZAKH FRESH', avatar: 'KF'),
              ),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Text('FC', style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
            title: const Text('Fresh Catch Seafood'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatDetailScreen(supplierName: 'Fresh Catch Seafood', avatar: 'FC'),
              ),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Text('A', style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
            title: const Text('Admin'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatDetailScreen(supplierName: 'Admin', avatar: 'A'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatDetailScreen extends StatefulWidget {
  final String supplierName;
  final String avatar;

  const ChatDetailScreen({super.key, required this.supplierName, required this.avatar});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [
    {'sender': 'supplier', 'message': 'Hello! Thank you for your order. We will process it shortly.', 'time': '10:30 AM'},
  ];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      messages.add({
        'sender': 'consumer',
        'message': _controller.text.trim(),
        'time': DateFormat('HH:mm').format(DateTime.now()),
      });
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: const Border(bottom: BorderSide()),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Text(widget.avatar, style: TextStyle(color: Theme.of(context).primaryColor)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.supplierName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Text('Online', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
              ],
            ),
          ),
          // Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isConsumer = message['sender'] == 'consumer';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: isConsumer ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!isConsumer)
                        CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          child: Text(widget.avatar, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12)),
                        ),
                      if (!isConsumer) const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: isConsumer ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isConsumer ? Theme.of(context).primaryColor : Colors.grey[200],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            constraints: const BoxConstraints(maxWidth: 260),
                            child: Text(
                              message['message'] as String,
                              style: TextStyle(color: isConsumer ? Colors.white : Colors.black),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(message['time'] as String, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      if (isConsumer) const SizedBox(width: 8),
                    ],
                  ),
                );
              },
            ),
          ),
          // Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: const Border(top: BorderSide()),
            ),
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      messages.add({
                        'sender': 'consumer',
                        'message': 'Would you want to write a review/complaint',
                        'time': DateFormat('HH:mm').format(DateTime.now()),
                      });
                    });
                  },
                  child: const Text('Would you want to write a review/complaint'),
                ),
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.attach_file), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.image), onPressed: () {}),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
