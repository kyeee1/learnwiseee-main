import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _filter = 'All';
  static const _categories = ['All', 'Reminders', 'Courses', 'System'];

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final items = _filter == 'All'
        ? state.notifications
        : state.notifications.where((n) => n.category == _filter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications',
            style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: context.adaptiveBorder)),
              child: const Icon(Icons.more_horiz_rounded, size: 20),
            ),
            onPressed: () => _showMoreOptions(context, state),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 46,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final category = _categories[i];
                final selected = category == _filter;
                return GestureDetector(
                  onTap: () => setState(() => _filter = category),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          selected ? AppColors.primary : context.adaptiveField,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(category,
                        style: TextStyle(
                          color: selected ? Colors.white : context.adaptiveText,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text('You\'re all caught up!',
                        style: TextStyle(color: AppColors.subtitle)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final n = items[i];
                      return Dismissible(
                        key: ValueKey(n.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                              color: AppColors.danger,
                              borderRadius: BorderRadius.circular(16)),
                          child: const Icon(Icons.delete_rounded,
                              color: Colors.white),
                        ),
                        onDismissed: (_) => setState(() => state.notifications
                            .removeWhere((x) => x.id == n.id)),
                        child: GestureDetector(
                          onTap: () => state.markNotificationRead(n.id),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardTheme.color,
                              borderRadius: BorderRadius.circular(16),
                              border: n.isRead
                                  ? null
                                  : Border.all(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.4),
                                      width: 1.4),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: n.iconColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(n.icon,
                                      color: n.iconColor, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(n.title,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ),
                                          Text(n.timeAgo,
                                              style: const TextStyle(
                                                  color: AppColors.subtitle,
                                                  fontSize: 11)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(n.body,
                                          style: const TextStyle(
                                              color: AppColors.subtitle,
                                              fontSize: 13,
                                              height: 1.3)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions(BuildContext context, AppState state) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.done_all_rounded),
              title: const Text('Mark all as read'),
              onTap: () {
                state.markAllNotificationsRead();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.clear_all_rounded),
              title: const Text('Clear all notifications'),
              onTap: () {
                state.clearNotifications();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
