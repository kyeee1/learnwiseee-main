import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import 'settings_screen.dart';
import 'help_support_screen.dart';
import 'bookmarks_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _editProfile(BuildContext context) {
    final state = AppScope.of(context);
    final nameController = TextEditingController(text: state.userName);
    final emailController = TextEditingController(text: state.userEmail);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Full name')),
            const SizedBox(height: 12),
            TextField(
                controller: emailController,
                decoration: const InputDecoration(hintText: 'Email address')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(100, 44)),
            onPressed: () {
              final name = nameController.text.trim();
              final email = emailController.text.trim();
              state.updateProfile(
                name: name.isEmpty ? state.userName : name,
                email: email.isEmpty ? state.userEmail : email,
              );
              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out of LearnWise?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                minimumSize: const Size(100, 44)),
            onPressed: () {
              AppScope.of(context).logout();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            colors: [Color(0xFF6C2BD9), Color(0xFF6C63FF)]),
                      ),
                      child: Center(
                        child: Text(
                          state.userName.isNotEmpty
                              ? state.userName[0].toUpperCase()
                              : 'A',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () => _editProfile(context),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                              color: AppColors.primary, shape: BoxShape.circle),
                          child: const Icon(Icons.edit_rounded,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(state.userName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800)),
                Text(state.userEmail,
                    style: const TextStyle(color: AppColors.subtitle)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _StatCard(label: 'Courses', value: '${state.allCourses.length}'),
              const SizedBox(width: 12),
              const _StatCard(label: 'Streak', value: '5 days'),
              const SizedBox(width: 12),
              const _StatCard(label: 'Badges', value: '3'),
            ],
          ),
          const SizedBox(height: 24),
          _MenuTile(
            icon: Icons.person_outline_rounded,
            label: 'Edit Profile',
            onTap: () => _editProfile(context),
          ),
          _MenuTile(
            icon: Icons.bookmark_border_rounded,
            label: 'Bookmarks',
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BookmarksScreen())),
          ),
          _MenuTile(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
          _MenuTile(
            icon: Icons.help_outline_rounded,
            label: 'Help & Support',
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HelpSupportScreen())),
          ),
          _MenuTile(
            icon: Icons.logout_rounded,
            label: 'Log Out',
            color: AppColors.danger,
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
            color: context.adaptiveField,
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Text(value,
                style:
                    const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
            const SizedBox(height: 4),
            Text(label,
                style:
                    const TextStyle(color: AppColors.subtitle, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.color});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tileColor = color ?? context.adaptiveText;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: tileColor),
              const SizedBox(width: 16),
              Expanded(
                  child: Text(label,
                      style: TextStyle(
                          color: tileColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15))),
              Icon(Icons.chevron_right_rounded,
                  color: tileColor.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}
