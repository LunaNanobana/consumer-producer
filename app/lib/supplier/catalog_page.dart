import 'package:flutter/material.dart';

class AccentButton extends StatelessWidget {
  final String title;
  final Function() onTap;

  const AccentButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        minimumSize: const Size(0, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late final List<Product> _products;

  @override
  void initState() {
    super.initState();
    _products = [
      Product(
        id: '001',
        name: 'Apples',
        imageUrl: '',
      ),
      Product(
        id: '002',
        name: 'Olive Oil',
        imageUrl: '',
      ),
      Product(
        id: '003',
        name: 'Tomatoes',
        imageUrl: '',
      ),
      Product(
        id: '004',
        name: 'Milk',
        imageUrl: '',
      ),
    ];
  }

  Widget _buildProductCard(int index, Product p) {
    const double baseImageWidth = 84.0;
    const double baseActionWidth = 120.0;
    const double indexWidth = 28.0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: 100,
        child: LayoutBuilder(builder: (context, constraints) {
          final double maxW = constraints.maxWidth;

          final double actionWidth = (maxW * 0.26).clamp(80.0, baseActionWidth);

          final double imageWidth = (maxW * 0.18).clamp(64.0, baseImageWidth);

          final double detailsWidth = maxW - imageWidth - actionWidth - indexWidth - 40;
          final double finalDetailsWidth = detailsWidth > 80 ? detailsWidth : 80.0;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: indexWidth,
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: SizedBox(
                  width: imageWidth,
                  height: double.infinity,
                  child: p.imageUrl.startsWith('http')
                      ? Image.network(
                          p.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image, size: 40),
                          ),
                        )
                      : Image.asset(p.imageUrl, fit: BoxFit.cover),
                ),
              ),

              SizedBox(
                width: finalDetailsWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'ID: ${p.id}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: actionWidth,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: AccentButton(
                          title: 'Info',
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Product Info'),
                                content: Text('Info for ${p.name} (id: ${p.id})'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: AccentButton(
                          title: 'Edit',
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Edit Product'),
                                content: Text('Edit screen for ${p.name} (id: ${p.id})'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _onAddPressed() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Product'),
        content: const Text('Add product action tapped.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 12, bottom: 80),
        itemCount: _products.length,
        itemBuilder: (context, i) => _buildProductCard(i, _products[i]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 117, 74, 27),
        foregroundColor: Colors.white,
        onPressed: _onAddPressed,
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
