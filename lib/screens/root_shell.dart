import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'ai_hub_screen.dart';
import 'planner_screen.dart';
import 'profile_screen.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _tabIndex = 0;

  static const _screens = [
    HomeScreen(),
    SearchScreen(),
    AiHubScreen(),
    PlannerScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _tabIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (i) => setState(() => _tabIndex = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded), label: 'Learn'),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome_rounded), label: 'AI Tutor'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_rounded), label: 'Planner'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
