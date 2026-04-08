import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'accent_button.dart';
import 'complaint_provider.dart';

class MyManagerPage extends StatelessWidget {
  const MyManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<ComplaintsProvider>();

    const String name = 'Bruce';
    const String surname = 'Wayne';
    const String workerIndex = 'ID: 12345';

    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 117, 74, 27),
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: AssetImage(''),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Manage tapped')),
                        );
                      },
                      child: const Text(
                        'Manage',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 117, 74, 27),
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Settings tapped')),
                        );
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.black54,
                        size: 28,
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$name $surname',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        workerIndex,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Spacer(),

            Center(
              child: AccentButton(
                title: 'Exit',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
