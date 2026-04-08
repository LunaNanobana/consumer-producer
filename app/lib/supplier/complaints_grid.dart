// lib/pages/dashboard/complaints_grid.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'complaint.dart';
import 'complaint_provider.dart';

class ComplaintsGrid extends StatelessWidget {
  final VoidCallback onChatPressed; // passed from DashboardPage

  const ComplaintsGrid({super.key, required this.onChatPressed});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ComplaintsProvider>();
    final complaints = provider.complaints;

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      cacheExtent: 100,
      itemCount: complaints.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 8,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (BuildContext context, int i) {
        final c = complaints[i];
        return _ComplaintCard(
          complaintText: c.text,
          createdAt: c.createdAt,
          onTap: () async {
            final result = await showDialog<String>(
              context: context,
              builder: (context) => ComplaintDialog(description: c.text),
            );

            if (result == 'chat') {
              onChatPressed();
            } else if (result == 'completed') {
              context.read<ComplaintsProvider>().completeComplaint(c.id);
            } else if (result == 'escalated') {
              context.read<ComplaintsProvider>().escalateComplaint(c.id);
            }
          },
        );
      },
    );
  }
}

class _ComplaintCard extends StatelessWidget {
  final String complaintText;
  final DateTime createdAt;
  final VoidCallback onTap;

  const _ComplaintCard({
    required this.complaintText,
    required this.createdAt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                complaintText,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}  ${createdAt.day}.${createdAt.month}.${createdAt.year}',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
