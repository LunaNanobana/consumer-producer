import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'order_confirmation_screen.dart';
import 'mock_data.dart';
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

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
                const SizedBox(width: 8),
                const Text('Checkout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery Address
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.grey),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('Grand Hotel & Spa\n100 Resort Way, Miami, FL', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                          TextButton(onPressed: () {}, child: const Text('Change')),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Delivery Date
                  const Text('Preferred Delivery Date', style: TextStyle(fontWeight: FontWeight.bold)),

                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      hintText: 'Select date',
                      border: OutlineInputBorder(),
                    ),
                    onTap: () {
                    
                    },
                  ),
                  const SizedBox(height: 16),
                  // Order Notes
                  const Text('Order Notes (Optional)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Any special instructions...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Payment Method
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.credit_card, color: Colors.grey),
                              SizedBox(width: 12),
                              Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          RadioListTile(
                            title: const Text('Net 30 Terms'),
                            subtitle: const Text('Payment due in 30 days'),
                            value: true,
                            groupValue: true,
                            onChanged: (_) {},
                          ),
                          RadioListTile(
                            title: const Text('Credit Card'),
                            subtitle: const Text('Pay now with card'),
                            value: false,
                            groupValue: true,
                            onChanged: (_) {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Order Summary
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Wild Salmon Fillet × 10 kg', style: TextStyle(color: Colors.grey)), Text(currencyFormat.format(258646.50))]),
                          const SizedBox(height: 8),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Tomato × 6 kg', style: TextStyle(color: Colors.grey)), Text(currencyFormat.format(116550.00))]),
                          const Divider(),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Subtotal'), Text(currencyFormat.format(375196.50))]),
                          const SizedBox(height: 8),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('VAT (12%)', style: TextStyle(color: Colors.grey)), Text(currencyFormat.format(45023.58))]),
                          const Divider(),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total'), Text(currencyFormat.format(420220.08))]),
                        ],
                      ),
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
                Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderConfirmationScreen()));
              },
              icon: const Icon(Icons.check_circle),
              label: const Text('Place Order'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            ),
          ),
        ],
      ),
    );
  }
}
