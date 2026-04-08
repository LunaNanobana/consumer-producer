import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'complaints_grid.dart';
import 'messanger_page.dart';
import 'my_page.dart';
import 'complaint_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentPageIndex = 0;

  void _switchToTab(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titles = const [
      'Dashboard',
      'Messages',
      'My Account',
    ];

    return ChangeNotifierProvider(
      create: (_) {
        final prov = ComplaintsProvider(totalGoal: 100);
        // optional: preload some example complaints
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
            // Dashboard (complaints)
            ComplaintsGrid(
              onChatPressed: () => _switchToTab(1),
            ),
            const MessangerPage(),
            const MyAccountPage(),
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
              icon: Icon(CupertinoIcons.person_circle),
              label: 'My Page',
            ),
          ],
        ),
      ),
    );
  }
}
