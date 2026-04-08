import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../api_service.dart'; 

class MyLinksScreen extends StatelessWidget {
  const MyLinksScreen({super.key});


  Future<List<dynamic>> loadLinks() async {
    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}/api/my-links/'),
      headers: ApiService.headers, 
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); 
    } else {
      throw Exception('Failed to load links: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Links'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: loadLinks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: () => (context as Element).markNeedsBuild(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No links yet. Start connecting with suppliers!'),
            );
          }

          final links = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: links.length,
            itemBuilder: (context, i) {
              final link = links[i];

              final String supplierName = link['supplier']['name'] ??
                  link['supplier_name'] ??
                  link['name'] ??
                  'Unknown Supplier';

              final String status = link['status'] ?? 'pending';
              final bool isConnected = status.toLowerCase() == 'connected' ||
                  status.toLowerCase() == 'accepted';

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isConnected ? Colors.green : Colors.orange,
                    child: Text(supplierName[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(supplierName),
                  subtitle: Text(isConnected ? 'Active connection' : 'Waiting for approval'),
                  trailing: Chip(
                    label: Text(
                      isConnected ? 'Connected' : 'Pending',
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: isConnected ? Colors.green[100] : Colors.orange[100],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}