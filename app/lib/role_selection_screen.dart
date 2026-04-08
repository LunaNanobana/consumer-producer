// lib/screens/role_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main_providers.dart';  
import 'login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _selectRole(BuildContext context, String role) {

    Provider.of<UserProvider>(context, listen: false).setRole(role);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text('SCP', style: TextStyle(color: Colors.white, fontSize: 24)),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Welcome!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text('Select your role to continue', style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 48),

            // Role Cards
            Column(
              children: [
                _roleCard(
                  context,
                  title: 'Consumer',
                  subtitle: 'Restaurant or hotel purchasing food products',
                  icon: Icons.person,
                  color: Colors.blue[100]!,
                  iconColor: Colors.blue,
                  onTap: () => _selectRole(context, 'consumer'),
                ),
                const SizedBox(height: 16),
                _roleCard(
                  context,
                  title: 'Supplier',
                  subtitle: 'Food supplier managing products and orders',
                  icon: Icons.store,
                  color: Colors.green[100]!,
                  iconColor: Colors.green,
                  onTap: () => _selectRole(context, 'supplier'),
                ),
                const SizedBox(height: 16),
                _roleCard(
                  context,
                  title: 'Admin',
                  subtitle: 'Platform administrator managing users and operations',
                  icon: Icons.security,
                  color: Colors.purple[100]!,
                  iconColor: Colors.purple,
                  onTap: () => _selectRole(context, 'admin'),
                ),
              ],
            ),
            const Spacer(),
            const Text('B2B Food Marketplace Platform', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _roleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, size: 32, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(subtitle, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
