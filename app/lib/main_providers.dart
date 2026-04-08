import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



class UserProvider extends ChangeNotifier {
  // Private fields
  String _name = "";
  String _email = "";
  String _role = "";
  String _token = "";

  // GETTERS
  String get name => _name.isEmpty ? "Guest User" : _name;
  String get email => _email.isEmpty ? "guest@example.com" : _email;
  String get role => _role;
  String get token => _token;

  // SET ROLE (used before signup)
  void setRole(String role) {
    _role = role;
    notifyListeners();
  }

  // Set user data after login/signup
  void setUser(Map<String, dynamic> data) {
    _name = data["name"] ?? "";
    _email = data["email"] ?? "";
    _role = data["role"] ?? "";
    _token = data["token"] ?? "";

    notifyListeners();
  }

  // Logout
  void logout() {
    _name = "";
    _email = "";
    _role = "";
    _token = "";
    notifyListeners();
  }
}





class CartItem {
  final Map<String, dynamic> product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}
class Order {
  final String id;
  final DateTime date;
  final String supplierName;
  final List<CartItem> items;
  final double total;
  final String status; 
  final DateTime? deliveryDate;
  final String? notes;

  Order({
    required this.id,
    required this.date,
    required this.supplierName,
    required this.items,
    required this.total,
    this.status = 'pending',
    this.deliveryDate,
    this.notes,
  });
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  bool read;
  final IconData icon;
  final Color color;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    this.read = false,
    required this.icon,
    required this.color,
  });
}

class AppProvider with ChangeNotifier {
  final List<CartItem> _cart = [];
  final List<Order> _orders = [];
  final List<NotificationItem> _notifications = [];

  List<CartItem> get cart => List.unmodifiable(_cart);
  List<Order> get orders => List.unmodifiable(_orders);
  List<NotificationItem> get notifications => List.unmodifiable(_notifications);
  int get unreadCount => _notifications.where((n) => !n.read).length;

  void addToCart(Map<String, dynamic> product, int qty) {
    final existing = _cart.indexWhere((i) => i.product['id'] == product['id']);
    if (existing >= 0) {
      _cart[existing].quantity += qty;
    } else {
      _cart.add(CartItem(product: product, quantity: qty));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.removeWhere((i) => i.product['id'] == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int qty) {
    final item = _cart.firstWhere((i) => i.product['id'] == productId, orElse: () => CartItem(product: {}, quantity: 0));
    if (item.quantity > 0) {
      item.quantity = qty;
      if (qty <= 0) removeFromCart(productId);
      notifyListeners();
    }
  }

  void placeOrder({
    required String supplierName,
    required DateTime? deliveryDate,
    required String notes,
  }) {
    final order = Order(
      id: 'ORD-${DateTime.now().year}-${(_orders.length + 1).toString().padLeft(3, '0')}',
      date: DateTime.now(),
      supplierName: supplierName,
      items: List.from(_cart),
      total: _cart.fold(0.0, (sum, i) => sum + (i.product['price'] as num) * i.quantity) * 1.12,
      deliveryDate: deliveryDate,
      notes: notes.isEmpty ? null : notes,
    );

    _orders.insert(0, order);
    _cart.clear();

    // Add notification
    addNotification(
      title: "Order Placed!",
      message: "Your order $order.id has been sent to $supplierName",
      icon: Icons.check_circle,
      color: Colors.green,
    );

    notifyListeners();
  }

  void addNotification({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
  }) {
    _notifications.insert(
      0,
      NotificationItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        message: message,
        time: DateTime.now(),
        icon: icon,
        color: color,
      ),
    );
    notifyListeners();
  }

  void markAsRead(String id) {
    final notif = _notifications.firstWhere((n) => n.id == id, orElse: () => NotificationItem(id: '', title: '', message: '', time: DateTime.now(), icon: Icons.info, color: Colors.grey));
    if (!notif.read) {
      notif.read = true;
      notifyListeners();
    }
  }

  void markAllRead() {
    for (var n in _notifications) {
      n.read = true;
    }
    notifyListeners();
  }

  void reorder(Order order) {
    for (var item in order.items) {
      addToCart(item.product, item.quantity);
    }
    addNotification(
      title: "Reordered!",
      message: "Items from ${order.id} added back to cart",
      icon: Icons.shopping_cart,
      color: Colors.blue,
    );
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) {
      final price = (item.product['price'] as num?)?.toDouble() ?? 0.0;
      return sum + (price * item.quantity);
    });
  }

  void add(Map<String, dynamic> product, int quantity) {
    final existingIndex = _items.indexWhere((item) => item.product['id'] == product['id']);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void remove(String productId) {
    _items.removeWhere((item) => item.product['id'] == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    final item = _items.firstWhere((i) => i.product['id'] == productId, orElse: () => CartItem(product: {}, quantity: 0));
    if (item.quantity > 0) {
      item.quantity = newQuantity;
      if (item.quantity <= 0) {
        remove(productId);
      } else {
        notifyListeners();
      }
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }


}

