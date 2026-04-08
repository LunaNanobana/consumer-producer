
import 'package:flutter/material.dart';
import 'package:flutter_application_1/consumer/my_links_screen.dart';
import 'package:provider/provider.dart';
import 'mock_data.dart';
import '../../main_providers.dart';
import 'link_approved_screen.dart';
import 'account_screen.dart';
import 'notifications_screen.dart';
import 'messenger_screen.dart';
import 'cart_screen.dart';
import '../../role_selection_screen.dart';

class LinkRequestScreen extends StatefulWidget {
  const LinkRequestScreen({super.key});

  @override
  State<LinkRequestScreen> createState() => _LinkRequestScreenState();
}

class _LinkRequestScreenState extends State<LinkRequestScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final cartCount = Provider.of<CartProvider>(context).items.length;

    // LIVE FILTER LOGIC
    final filteredSuppliers = mockSuppliers.where((supplier) {
      final name = supplier.businessName.toLowerCase();
      final query = searchQuery.toLowerCase();
      return name.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                (route) => false,
              );
            }
          },
        ),
        title: const Text('Find Suppliers'),
        actions: [
          // Notifications
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
              ),
              const Positioned(
                right: 8, top: 8,
                child: CircleAvatar(radius: 6, backgroundColor: Colors.red, child: Text('2', style: TextStyle(fontSize: 10, color: Colors.white))),
              ),
            ],
          ),
          // Messages
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.message),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MessengerScreen())),
              ),
              const Positioned(
                right: 8, top: 8,
                child: CircleAvatar(radius: 6, backgroundColor: Colors.red, child: Text('1', style: TextStyle(fontSize: 10, color: Colors.white))),
              ),
            ],
          ),
          // Cart
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
              ),
              if (cartCount > 0)
                Positioned(
                  right: 8, top: 8,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text('$cartCount', style: const TextStyle(fontSize: 10, color: Colors.white)),
                  ),
                ),
            ],
          ),
          // Account
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountScreen())),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: const Border(bottom: BorderSide()),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Suppliers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Request access to view catalogs', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: const InputDecoration(
                hintText: 'Search suppliers...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // Tabs
          Container(
            decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Available'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MyLinksScreen()));
                    },
                    child: const Text('My Links'),
                  ),
                ),
              ],
            ),
          ),

          // Supplier list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredSuppliers.length,
              itemBuilder: (context, index) {
                final supplier = filteredSuppliers[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.store, color: Theme.of(context).primaryColor),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    supplier.businessName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  if (supplier.verified) const Chip(label: Text('Verified')),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                supplier.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 8),

                              Row(
                                children: [
                                  Text('${supplier.rating}'),
                                  const SizedBox(width: 8),
                                  Text('(${supplier.reviewCount})', style: const TextStyle(color: Colors.grey)),
                                  const SizedBox(width: 8),
                                  const Text('•'),
                                  const SizedBox(width: 8),
                                  Text(supplier.categories.join(', '), style: const TextStyle(color: Colors.grey)),
                                ],
                              ),

                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: () {
                                  final supplierType =
                                      supplier.businessName == 'Fresh Catch Seafood'
                                          ? 'mock'
                                          : 'db';

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LinkApprovedScreen(
                                        supplierType: supplierType,
                                        supplierId: supplier.id,
                                        supplierName: supplier.businessName,
                                        supplierDescription: supplier.description,
                                        supplierRating: supplier.rating,
                                        supplierReviewCount: supplier.reviewCount,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.link),
                                label: const Text('Request Access'),
                                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 36)),
                              ),
                            ],
                          ),
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
