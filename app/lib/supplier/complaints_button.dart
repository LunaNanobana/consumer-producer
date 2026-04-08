import 'package:flutter/material.dart';
import 'complaint.dart';

class ComplaintsButton extends StatelessWidget {
  final VoidCallback? onOpenChat;

  const ComplaintsButton({super.key, this.onOpenChat});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 255, 251, 217),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        splashColor: Colors.amber,
        hoverColor: const Color.fromARGB(255, 255, 221, 129),
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          _showComplaint(context);
        },
        child: Row(
          children: <Widget>[
            _title(),
            _state(),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 6, right: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text(
              'text a lot of text',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            Text(
              'tect too much tect',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _state() {
    return Container();
  }

  Future<void> _showComplaint(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const ComplaintDialog(description: 'Some complaint text'),
    );

    if (result == 'chat') {
      if (onOpenChat != null) onOpenChat!();
    } else if (result == 'completed') {
      // TODO: Delete the complaint
    } else if (result == 'escalated') {
      // TODO: Escalate the complaint
    }
  }
}
