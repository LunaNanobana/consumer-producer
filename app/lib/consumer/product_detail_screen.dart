
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';                 
import 'package:provider/provider.dart';
import '../../main_providers.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late int quantity;


  String formatPrice(num amount) {
    return NumberFormat.currency(locale: 'ru_KZ', symbol: '₸').format(amount);
  }

  @override
  void initState() {
    super.initState();
    quantity = widget.product['minimumOrderQuantity'] ?? 5;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Product Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
             
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      product['image'] ?? 'https://via.placeholder.com/600',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 80),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                     
                        Text(
                          product['name'],
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),

                        // Price
                        Text(
                          '${formatPrice(product['price'])} / ${product['unit']}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Rating
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text('${product['rating'] ?? 4.8} • ${product['reviewCount'] ?? 142} reviews'),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Description
                        const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(product['description'] ?? 'Premium quality product from trusted supplier.'),

                        const SizedBox(height: 20),

                        // Info Boxes
                        Row(
                          children: [
                            Expanded(child: _infoBox('Minimum Order', '${product['minimumOrderQuantity']} ${product['unit']}')),
                            const SizedBox(width: 12),
                            Expanded(child: _infoBox('In Stock', '${product['stock'] ?? 500} ${product['unit']}')),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Supplier
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.store, color: Colors.blue),
                              const SizedBox(width: 12),
                              Text(product['supplierName'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar – Add to Cart
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10)],
              border: const Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              children: [
                // Quantity Selector
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (quantity > product['minimumOrderQuantity']) {
                            setState(() => quantity--);
                          }
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      SizedBox(
                        width: 60,
                        child: Center(
                          child: Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                      ),
                      IconButton(onPressed: () => setState(() => quantity++), icon: const Icon(Icons.add)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Add to Cart Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      cart.add(product, quantity);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added $quantity × ${product['name']} to cart!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: Text(
                      'Add • ${formatPrice(quantity * product['price'])}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}