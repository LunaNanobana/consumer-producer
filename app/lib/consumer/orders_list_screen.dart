
import 'package:flutter/material.dart';
import 'mock_data.dart';
import 'link_request_screen.dart';  

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      {'id': 'ORD-2025-003', 'supplier': 'Fresh Catch Seafood', 'date': 'Oct 17, 2025', 'status': 'pending', 'total': 206589.60, 'items': 2},
      {'id': 'ORD-2025-002', 'supplier': 'Green Valley Farms', 'date': 'Oct 14, 2025', 'status': 'delivered', 'total': 269977.50, 'items': 2},
      {'id': 'ORD-2025-001', 'supplier': 'Fresh Catch Seafood', 'date': 'Oct 10, 2025', 'status': 'confirmed', 'total': 812026.50, 'items': 2, 'deliveryDate': 'Oct 18, 2025'},
    ];

    IconData? getStatusIcon(String status) {
      switch (status) {
        case 'delivered':
          return Icons.check_circle;
        case 'confirmed':
          return Icons.access_time;
        default:
          return Icons.local_shipping;
      }
    }

    Color? getStatusColor(String status) {
      switch (status) {
        case 'delivered':
          return Colors.green;
        case 'confirmed':
          return Colors.blue;
        default:
          return Colors.grey;
      }
    }

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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LinkRequestScreen()),
                        );
                      },
                    ),
                    const Expanded(
                      child: Text('My Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
                  ],
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ElevatedButton(onPressed: () {}, child: const Text('All Orders')),
                      const SizedBox(width: 8),
                      OutlinedButton(onPressed: () {}, child: const Text('Pending')),
                      const SizedBox(width: 8),
                      OutlinedButton(onPressed: () {}, child: const Text('Delivered')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Orders List 
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(getStatusIcon(order['status'] as String), color: getStatusColor(order['status'] as String), size: 20),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(order['id'] as String),
                                    Text(order['date'] as String, style: const TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                            Chip(label: Text((order['status'] as String).toUpperCase())),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text('Supplier', style: TextStyle(color: Colors.grey)),
                        Text(order['supplier'] as String),
                        const Divider(height: 24),

                        if (index == 0) ...[
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Wild Salmon Fillet × 10 kg', style: TextStyle(color: Colors.grey)), Text(currencyFormat.format(112455.00))]),
                          const SizedBox(height: 8),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Tomato × 6 kg', style: TextStyle(color: Colors.grey)), Text(currencyFormat.format(72000.00))]),
                          const Divider(),
                        ] else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${order['items']} items', style: const TextStyle(color: Colors.grey)),
                            ],
                          ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(currencyFormat.format(order['total'] as num), style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        if (order['deliveryDate'] != null) const SizedBox(height: 8),
                        if (order['deliveryDate'] != null) Text('Delivery: ${order['deliveryDate']}', style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('View Details'))),
                            const SizedBox(width: 8),
                            Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Reorder'))),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}