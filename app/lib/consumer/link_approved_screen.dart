
import 'package:flutter/material.dart';
import 'browse_products_screen.dart';

class LinkApprovedScreen extends StatelessWidget {
  final String supplierType; 
  final String supplierId; 
  final String supplierName;
  final String? supplierDescription;
  final double? supplierRating;
  final int? supplierReviewCount;

  const LinkApprovedScreen({
    super.key,
    required this.supplierType,
    required this.supplierId,
    required this.supplierName,
    this.supplierDescription,
    this.supplierRating,
    this.supplierReviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
            child: Center(child: Text('Link Status', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ),
          // Content
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(color: Colors.green[100], shape: BoxShape.circle),
                      child: const Icon(Icons.check_circle, size: 40, color: Colors.green),
                    ),
                    const SizedBox(height: 24),
                    const Text('Access Granted!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      '$supplierName has approved your link request. You can now view their catalog and place orders.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                              child: Icon(Icons.store, color: Theme.of(context).primaryColor),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(supplierName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(supplierDescription ?? 'Premium supplier', style: const TextStyle(color: Colors.grey)),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text('⭐ ${supplierRating?.toStringAsFixed(1) ?? '4.8'}'),
                                      const SizedBox(width: 8),
                                      Text('(${supplierReviewCount ?? 142} reviews)', style: const TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BrowseProductsScreen(
                              supplierType: supplierType,
                              supplierId: supplierId,
                              supplierName: supplierName,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Browse Catalog'),
                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
