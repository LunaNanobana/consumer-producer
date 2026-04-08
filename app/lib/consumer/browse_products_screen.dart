
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../api_service.dart';
import '../../main_providers.dart';
import 'product_detail_screen.dart';
import 'notifications_screen.dart';
import 'messenger_screen.dart';
import 'cart_screen.dart';
import 'account_screen.dart';
import 'mock_data.dart' show mockProducts;

class BrowseProductsScreen extends StatefulWidget {
  final String? supplierType;
  final String? supplierId;
  final String? supplierName;

  const BrowseProductsScreen({
    super.key,
    this.supplierType,
    this.supplierId,
    this.supplierName,
  });

  @override
  State<BrowseProductsScreen> createState() => _BrowseProductsScreenState();
}

class _BrowseProductsScreenState extends State<BrowseProductsScreen> {
  List<Map<String, dynamic>> products = [];
  String searchQuery = "";
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    setState(() => loading = true);

    try {
      // MOCK SUPPLIER
      if (widget.supplierType == "mock" && widget.supplierId != null) {
        products = mockProducts
            .where((p) => p.supplierId == widget.supplierId)
            .map((p) => {
                  'id': p.id,
                  'name': p.name,
                  'image': p.images.isNotEmpty ? p.images[0] : null,
                  'price': p.price,
                  'unit': p.unit,
                  'minimumOrderQuantity': p.minimumOrderQuantity,
                  'stock': p.stock,
                  'supplierName': p.supplierName,
                  'description': p.description,
                })
            .toList();
      }

      // REAL SUPPLIER
      else if (widget.supplierId != null) {
        final response = await http.get(
          Uri.parse('${ApiService.baseUrl}/api/products/?supplier=${widget.supplierId}'),
          headers: ApiService.headers,
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          products = data.map((p) {
            return {
              'id': p['id'].toString(),
              'name': p['name'] ?? 'No name',
              'image': p['image'],
              'price': double.tryParse(p['price'].toString()) ?? 0.0,
              'unit': p['unit'] ?? 'kg',
              'minimumOrderQuantity': p['min_order_qty'] ?? 1,
              'stock': p['stock'] ?? 0,
              'supplierName': p['supplier_business_name'] ?? widget.supplierName ?? 'Supplier',
              'description': p['description'] ?? '',
            };
          }).toList();
        }
      }
    } catch (_) {}

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = Provider.of<CartProvider>(context).items.length;

    // LIVE FILTER
    final filtered = products.where((p) {
      final name = p['name'].toString().toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.supplierName ?? 'Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MessengerScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountScreen())),
          ),
        ],
      ),

      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? const Center(child: Text('No products found'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (context, i) {
                          final p = filtered[i];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailScreen(product: p),
                                ),
                              );
                            },
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      color: Colors.grey[300],
                                      child: p['image'] != null
                                          ? Image.asset(p['image'], fit: BoxFit.cover)
                                          : const Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p['name'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          p['supplierName'],
                                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${p['price'].toStringAsFixed(0)} ₸ / ${p['unit']}',
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
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
