
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main_providers.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Account')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 60)),
            const SizedBox(height: 20),
            Text(user.name.isEmpty ? 'Guest User' : user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(user.email, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Full Name'),
                subtitle: Text(user.name.isEmpty ? 'Not set' : user.name),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                subtitle: Text(user.email),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.business),
                title: const Text('Role'),
                subtitle: Text(user.role.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}