import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'messanger_page.dart';
import 'complaint_provider.dart';
import 'catalog_page.dart';
import 'my_page_manager.dart';

class Product {
  final String id;
  final String name;
  final double amount;
  final String unit;
  final DateTime dueDate;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.amount,
    required this.unit,
    required this.dueDate,
    required this.imageUrl,
  });
}

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPage();
}

class _OrdersPage extends State<OrdersPage> {
  int _currentPageIndex = 0;

  void _switchToTab(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  late final List<Product> _products;

  @override
  void initState() {
    super.initState();
    _products = [
      Product(
        id: '001',
        name: 'Apples',
        amount: 120.0,
        unit: 'kg',
        dueDate: DateTime.now().add(const Duration(days: 5)),
        imageUrl: '',
      ),
      Product(
        id: '002',
        name: 'Olive Oil',
        amount: 50.0,
        unit: 'l',
        dueDate: DateTime.now().add(const Duration(days: 14)),
        imageUrl: '',
      ),
      Product(
        id: '003',
        name: 'Tomatoes',
        amount: 80.5,
        unit: 'kg',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        imageUrl: '',
      ),
      Product(
        id: '004',
        name: 'Milk',
        amount: 200.0,
        unit: 'l',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        imageUrl: '',
      ),
    ];
  }

  String _twoDigits(int n) => n < 10 ? '0$n' : n.toString();
  String _formatDate(DateTime d) => '${d.year}-${_twoDigits(d.month)}-${_twoDigits(d.day)}';

  Widget _buildProductCard(Product p) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tapped ${p.name}')));
        },
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 100,
          child: LayoutBuilder(builder: (context, constraints) {
            const double imageWidth = 100;
            const double actionWidth = 44;

            final double detailsWidth = constraints.maxWidth - imageWidth - actionWidth - 24;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                  width: detailsWidth > 0 ? detailsWidth : 80,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                '${p.amount.toStringAsFixed(p.amount % 1 == 0 ? 0 : 1)} ${p.unit}',
                                style: const TextStyle(fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        Row(
                          children: [
                            const Icon(CupertinoIcons.clock, size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Due: ${_formatDate(p.dueDate)}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: p.dueDate.isBefore(DateTime.now()) ? Colors.redAccent : Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  width: actionWidth,
                  height: double.infinity,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Product action'),
                          content: Text('Action for ${p.name}'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.more_horiz),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _productListWidget({required VoidCallback onChatPressed}) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: const Color.fromARGB(255, 245, 240, 238),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.inventory_2_outlined),
              const SizedBox(width: 8),
              const Text('Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              Text('Total: ${_products.length}', style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            itemCount: _products.length,
            itemBuilder: (context, i) => _buildProductCard(_products[i]),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titles = const [
      'Dashboard',
      'Messages',
      'My Account',
      'Catalog',
    ];

    return ChangeNotifierProvider(
      create: (_) {
        final prov = ComplaintsProvider(totalGoal: 100);
        prov.preload([
          'Leaky pipe in 3rd floor restroom',
          'Broken light at entrance',
          'No hot water in unit 4A',
        ]);
        return prov;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            titles[_currentPageIndex],
            style: const TextStyle(color: Colors.white),
          ),
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 117, 74, 27),
        ),

        body: IndexedStack(
          index: _currentPageIndex,
          children: [
            _productListWidget(onChatPressed: () => _switchToTab(1)),
            const MessangerPage(),
            const CatalogPage(),
            const MyManagerPage(),
          ],
        ),
        
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPageIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color.fromARGB(255, 117, 74, 27),
          unselectedItemColor: Colors.grey,
          onTap: _switchToTab,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.doc),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble_2),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Catalog',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_circle),
              label: 'My Page',
            ),
          ],
        ),
      ),
    );
  }
}
