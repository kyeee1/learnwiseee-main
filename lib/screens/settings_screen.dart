import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(
          title: Text(state.text('settings'),
              style: const TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          const _SectionLabel('APPEARANCE'),
          _SettingsCard(
            children: [
              _SwitchRow(
                icon: Icons.dark_mode_rounded,
                iconColor: const Color(0xFF6C63FF),
                label: 'Dark Mode',
                value: state.isDarkMode,
                onChanged: state.toggleDarkMode,
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          color: context.adaptiveSoftPrimary,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.text_fields_rounded,
                          color: AppColors.primary, size: 18),
                    ),
                    const SizedBox(width: 12),
                    const Text('Font Size',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const Spacer(),
                    const Text('A',
                        style:
                            TextStyle(fontSize: 12, color: AppColors.subtitle)),
                    SizedBox(
                      width: 110,
                      child: Slider(
                        value: state.fontScale,
                        onChanged: state.setFontScale,
                        activeColor: AppColors.primary,
                      ),
                    ),
                    const Text('A',
                        style:
                            TextStyle(fontSize: 18, color: AppColors.subtitle)),
                  ],
                ),
              ),
            ],
          ),
          const _SectionLabel('ACCOUNT'),
          _SettingsCard(
            children: [
              _NavRow(
                icon: Icons.language_rounded,
                label: state.text('language'),
                trailing: state.language,
                onTap: () => _pickLanguage(context, state),
              ),
              const Divider(height: 1),
              _NavRow(
                icon: Icons.person_outline_rounded,
                label: 'Edit Profile',
                onTap: () => Navigator.pop(context),
              ),
              const Divider(height: 1),
              _NavRow(
                icon: Icons.lock_outline_rounded,
                label: 'Change Password',
                onTap: () => _changePassword(context),
              ),
            ],
          ),
          const _SectionLabel('NOTIFICATIONS'),
          _SettingsCard(
            children: [
              _SwitchRow(
                icon: Icons.notifications_active_rounded,
                iconColor: const Color(0xFF6C63FF),
                label: 'Push Notifications',
                value: state.pushNotifications,
                onChanged: state.togglePushNotifications,
              ),
              const Divider(height: 1),
              _SwitchRow(
                icon: Icons.mail_outline_rounded,
                iconColor: const Color(0xFF6C63FF),
                label: 'Email Updates',
                value: state.emailUpdates,
                onChanged: state.toggleEmailUpdates,
              ),
              const Divider(height: 1),
              _SwitchRow(
                icon: Icons.thumb_up_alt_outlined,
                iconColor: const Color(0xFF6C63FF),
                label: 'Study Reminders',
                value: state.studyReminders,
                onChanged: state.toggleStudyReminders,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text('LearnWise v2.4.1 (Stable Build)',
                style: TextStyle(color: AppColors.subtitle, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  void _pickLanguage(BuildContext context, AppState state) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Wrap(
          children:
              ['English', 'Filipino', 'Spanish', 'French', 'Japanese', 'Korean']
                  .map((lang) => ListTile(
                        title: Text(lang),
                        trailing: state.language == lang
                            ? const Icon(Icons.check, color: AppColors.primary)
                            : null,
                        onTap: () {
                          state.setLanguage(lang);
                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
        ),
      ),
    );
  }

  void _changePassword(BuildContext context) {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Current password'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newController,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'New password'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(100, 44)),
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password updated successfully')),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(text,
          style: const TextStyle(
              color: AppColors.subtitle,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 0.6)),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(18)),
      child: Column(children: children),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow(
      {required this.icon,
      required this.label,
      this.trailing,
      required this.onTap});
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: context.adaptiveSoftPrimary,
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Text(label,
                    style: const TextStyle(fontWeight: FontWeight.w600))),
            if (trailing != null)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(trailing!,
                    style: const TextStyle(color: AppColors.subtitle)),
              ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.subtitle),
          ],
        ),
      ),
    );
  }
}
