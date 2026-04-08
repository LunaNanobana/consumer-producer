import 'package:flutter/material.dart';
import 'chat_page.dart';

class MessangerPage extends StatelessWidget {
  const MessangerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> chats = [
      {
        'name': 'Clark Kent',
        'lastMessage': 'Hey, how’s it going?',
        'time': '10:45 AM',
      },
      {
        'name': 'Jim Gordon',
        'lastMessage': 'Got your message, thanks!',
        'time': 'Yesterday',
      },
      {
        'name': 'League of Justice',
        'lastMessage': 'We’ll get back to you shortly.',
        'time': '2 days ago',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 117, 74, 27),
              child: Text(
                chat['name']![0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              chat['name']!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              chat['lastMessage']!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              chat['time']!,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatPage(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}