import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'accent_button.dart';
import 'complaint_provider.dart';

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ComplaintsProvider>();

    const String name = 'Bruce';
    const String surname = 'Wayne';
    const String workerIndex = 'ID: 12345';

    final int currentGoal = provider.currentGoal;
    final int totalGoal = provider.goalTotal;

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

            const SizedBox(height: 32),
            const Text(
              'Goal Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (totalGoal == 0) ? 0 : currentGoal / totalGoal,
              backgroundColor: Colors.grey[300],
              color: const Color.fromARGB(255, 117, 74, 27),
              minHeight: 10,
            ),
            const SizedBox(height: 8),
            Text(
              '$currentGoal / $totalGoal',
              style: const TextStyle(fontSize: 16, color: Colors.black),
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
