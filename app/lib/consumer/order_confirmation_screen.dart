import 'package:flutter/material.dart';
import 'package:flutter_application_1/main_providers.dart';
import 'orders_list_screen.dart';
import 'mock_data.dart';
class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

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
            child: const Center(child: Text('Order Confirmation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Success Icon
                  Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(color: Colors.green[100], shape: BoxShape.circle),
                        child: const Icon(Icons.check_circle, size: 40, color: Colors.green),
                      ),
                      const SizedBox(height: 16),
                      const Text('Order Placed Successfully!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('Your order has been sent to the supplier for confirmation', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Order Details
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Order #ORD-2025-003', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('Oct 17, 2025', style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                              Chip(label: const Text('Pending')),
                            ],
                          ),
                          const Divider(height: 32),
                          const Row(
                            children: [
                              Icon(Icons.local_shipping, color: Colors.grey, size: 20),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Supplier', style: TextStyle(color: Colors.grey)),
                                    Text('Fresh Catch Seafood'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            children: [
                              Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Requested Delivery', style: TextStyle(color: Colors.grey)),
                                    Text('Oct 20, 2025'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.grey, size: 20),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Delivery Address', style: TextStyle(color: Colors.grey)),
                                    Text('Grand Hotel & Spa\n100 Resort Way, Almaty, ALM'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 32),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Wild Salmon Fillet × 10 kg', style: TextStyle(color: Colors.grey)), Text(currencyFormat.format(112455.00))]),
                          const SizedBox(height: 8),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Tomato × 6 kg', style: TextStyle(color: Colors.grey)), Text(currencyFormat.format(72000.00))]),
                          const Divider(),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total'), Text(currencyFormat.format(206589.60))]),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Info
                  Card(
                    color: Colors.blue[50],
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('💡 The supplier will review and confirm your order. You\'ll receive a notification once it\'s confirmed.', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: const Border(top: BorderSide()),
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersListScreen()));
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('View My Orders'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            ),
          ),
        ],
      ),
    );
  }
}
