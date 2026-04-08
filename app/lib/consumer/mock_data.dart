import 'package:intl/intl.dart';

class Product {
  final String id;
  final String name;
  final List<String> images;
  final double rating;
  final double price;
  final String unit;
  final int minimumOrderQuantity;
  final String supplierId;
  final String supplierName;
  final String description;
  final String category;
  final int stock;
  final int reviewCount;



  Product({
    required this.id,
    required this.name,
    required this.images,
    required this.rating,
    required this.price,
    required this.unit,
    required this.minimumOrderQuantity,
    required this.supplierId,
    required this.supplierName,
    required this.description,
    required this.category,
    required this.stock,
    required this.reviewCount,
  });

  static int? get length => null;



}

class Supplier {
  final String id;
  final String businessName;
  final bool verified;
  final String description;
  final double rating;
  final int reviewCount;
  final List<String> categories;

  Supplier({
    required this.id,
    required this.businessName,
    required this.verified,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.categories,
  });
}

final List<Product> mockProducts = [
  Product(
    id: 'p1',
    name: 'Wild Salmon Fillet',
    images: ['assets/images/salmon.jpg'],
    rating: 4.8,
    price: 11245.5,
    unit: 'kg',
    minimumOrderQuantity: 10,
    supplierId: 's1',
    supplierName: 'Fresh Catch Seafood',
    description: 'Fresh wild-caught salmon fillets',
    category: 'Fish',
    stock: 500,
    reviewCount: 142,
  ),
  Product(
    id: 'p2',
    name: 'Premium Shrimp',
    images: ['assets/images/shrimp.jpg'],
    rating: 4.7,
    price: 8325.0,
    unit: 'kg',
    minimumOrderQuantity: 5,
    supplierId: 's1',
    supplierName: 'Fresh Catch Seafood',
    description: 'Large premium shrimp, peeled and deveined',
    category: 'Seafood',
    stock: 300,
    reviewCount: 98,
  ),
];

final List<Supplier> mockSuppliers = [
  Supplier(
    id: 's1',
    businessName: 'Fresh Catch Seafood',
    verified: true,
    description: 'Premium seafood supplier with fresh daily catches',
    rating: 4.8,
    reviewCount: 142,
    categories: ['Fish', 'Seafood'],
  ),
  Supplier(
    id: 's2',
    businessName: 'KAZAKH FRESH',
    verified: true,
    description: 'Organic produce and dairy products',
    rating: 4.9,
    reviewCount: 210,
    categories: ['Dairy', 'Produce'],
  ),
];

final NumberFormat currencyFormat = NumberFormat.currency(locale: 'ru_KZ', symbol: '₸', customPattern: '₸#,###.##');
