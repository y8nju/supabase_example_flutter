import 'package:flutter/material.dart';
import 'package:supabase_example/screens/account_screen.dart';
import 'package:supabase_example/screens/message_screen.dart';
import 'package:supabase_example/screens/note_screens.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            NoteScreen(),
            const ChatScreen(),
            const AccountScreen(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) => setState(() {
          _selectedIndex = value;
        }),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.edit_note_rounded),
            label: "Memo",
            selectedIcon: Icon(
              Icons.edit_note_rounded,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
          NavigationDestination(
            icon: const Icon(Icons.chat_rounded),
            label: "Message",
            selectedIcon: Icon(
              Icons.chat_rounded,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_circle_rounded),
            label: "Account",
            selectedIcon: Icon(
              Icons.account_circle_rounded,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
        ],
        animationDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}
