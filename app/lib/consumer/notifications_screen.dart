
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  List<Map<String, dynamic>> notifications = [
    {
      'id': '1',
      'type': 'order_confirmed',
      'title': 'Order Confirmed',
      'message': 'Fresh Catch Seafood And KAZAKH FRESH confirmed your order #ORD-2025-003',
      'time': '5 min ago',
      'read': false,
      'icon': Icons.check_circle,
      'color': Colors.green,
      'bgColor': Colors.green[100]
    },
    {
      'id': '2',
      'type': 'message',
      'title': 'New Message',
      'message': 'You have a new message from Fresh Catch Seafood',
      'time': '1 hour ago',
      'read': false,
      'icon': Icons.message,
      'color': Colors.blue,
      'bgColor': Colors.blue[100]
    },
    {
      'id': '3',
      'type': 'order_delivered',
      'title': 'Order Delivered',
      'message': 'Your order #ORD-2025-002 has been delivered',
      'time': '2 hours ago',
      'read': true,
      'icon': Icons.local_shipping,
      'color': Colors.green,
      'bgColor': Colors.green[100]
    },
    {
      'id': '4',
      'type': 'link_approved',
      'title': 'Link Request Approved',
      'message': 'KAZAKH FRESH approved your link request',
      'time': '5 minutes ago',
      'read': true,
      'icon': Icons.check_circle,
      'color': Colors.green,
      'bgColor': Colors.green[100]
    },
    {
      'id': '5',
      'type': 'link_approved',
      'title': 'Link Request Approved',
      'message': 'Fresh Catch Seafood approved your link request',
      'time': '5 minutes ago',
      'read': true,
      'icon': Icons.check_circle,
      'color': Colors.green,
      'bgColor': Colors.green[100]
    },
  ];

  int get unreadCount => notifications.where((n) => !(n['read'] as bool)).length;

  void markAllAsRead() {
    setState(() {
      for (var n in notifications) {
        n['read'] = true;
      }
    });
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
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    if (unreadCount > 0) ...[
                      const SizedBox(width: 8),
                      Chip(
                        label: Text('$unreadCount new'),
                        backgroundColor: Colors.red,
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ElevatedButton(onPressed: () {}, child: const Text('All')),
                      const SizedBox(width: 8),
                      OutlinedButton(onPressed: () {}, child: const Text('Unread')),
                      const SizedBox(width: 8),
                      OutlinedButton(onPressed: () {}, child: const Text('Orders')),
                      const SizedBox(width: 8),
                      OutlinedButton(onPressed: () {}, child: const Text('Messages')),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Notifications List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final n = notifications[index];
                final bool isRead = n['read'] as bool;

                return Card(
                  color: !isRead ? Colors.blue[50] : null,
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: n['bgColor'] as Color?,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(n['icon'] as IconData?, color: n['color'] as Color?),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            n['title'] as String,
                            style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.bold),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                          ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(n['message'] as String),
                        const SizedBox(height: 4),
                        Text(n['time'] as String, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    onTap: () {
                      if (!isRead) {
                        setState(() {
                          n['read'] = true;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: const Border(top: BorderSide()),
            ),
            child: OutlinedButton(
              onPressed: unreadCount > 0 ? markAllAsRead : null, 
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: BorderSide(color: unreadCount > 0 ? Colors.blue : Colors.grey),
              ),
              child: Text(
                'Mark All as Read',
                style: TextStyle(color: unreadCount > 0 ? Colors.blue : Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}