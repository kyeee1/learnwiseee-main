import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import 'bookmarks_screen.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  DateTime _weekAnchor =
      DateTime(2026, 10, 18); // Wed 18 Oct 2026, matching mockup
  int _selectedDayOffset = 0;

  static const _dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  List<DateTime> get _weekDates {
    final monday =
        _weekAnchor.subtract(Duration(days: _weekAnchor.weekday - 1));
    return List.generate(6, (i) => monday.add(Duration(days: i)));
  }

  void _changeWeek(int delta) {
    setState(() => _weekAnchor = _weekAnchor.add(Duration(days: 7 * delta)));
  }

  void _addTask() {
    final titleController = TextEditingController();
    final timeController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Add Task',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 18),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      hintText: 'Task title (e.g. Chemistry: Chapter 4)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(
                      hintText: 'Time (e.g. 6:00 PM - 7:00 PM)'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isEmpty) return;
                    AppScope.of(context).addTask(
                      titleController.text.trim(),
                      timeController.text.trim().isEmpty
                          ? 'All day'
                          : timeController.text.trim(),
                    );
                    Navigator.pop(sheetContext);
                  },
                  child: const Text('Add Task'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final dates = _weekDates;
    final monthLabel = _monthYearLabel(_weekAnchor);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Planner',
            style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const BookmarksScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTask,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Task',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(monthLabel,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800)),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: () => _changeWeek(-1),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: () => _changeWeek(1),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(6, (i) {
              final selected = i == _selectedDayOffset;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDayOffset = i),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Text(_dayLabels[i],
                            style: TextStyle(
                                fontSize: 12,
                                color: selected
                                    ? Colors.white70
                                    : AppColors.subtitle)),
                        const SizedBox(height: 6),
                        Text('${dates[i].day}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: selected
                                  ? Colors.white
                                  : context.adaptiveText,
                            )),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          const Divider(height: 32),
          const Text("Today's Schedule",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          if (state.tasks.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('No tasks yet — tap "Add Task" to plan your day.',
                  style: TextStyle(color: AppColors.subtitle)),
            )
          else
            ...state.tasks.map((t) => Dismissible(
                  key: ValueKey(t.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                        color: AppColors.danger,
                        borderRadius: BorderRadius.circular(16)),
                    child:
                        const Icon(Icons.delete_rounded, color: Colors.white),
                  ),
                  onDismissed: (_) => state.removeTask(t.id),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: t.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border(left: BorderSide(color: t.color, width: 4)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  decoration: t.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: t.isDone
                                      ? AppColors.subtitle
                                      : context.adaptiveText,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(t.time,
                                  style: const TextStyle(
                                      color: AppColors.subtitle, fontSize: 13)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined,
                              color: AppColors.primary),
                          onPressed: () {
                            final titleController =
                                TextEditingController(text: t.title);
                            final timeController =
                                TextEditingController(text: t.time);
                            showDialog(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                title: const Text('Edit Task'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: titleController,
                                      decoration: const InputDecoration(
                                          labelText: 'Task title'),
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: timeController,
                                      decoration: const InputDecoration(
                                          labelText: 'Time'),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton.icon(
                                    onPressed: () {
                                      state.removeTask(t.id);
                                      Navigator.pop(dialogContext);
                                    },
                                    icon: const Icon(
                                        Icons.delete_outline_rounded),
                                    label: const Text('Delete'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      state.updateTask(
                                        t.id,
                                        title: titleController.text,
                                        time: timeController.text,
                                      );
                                      Navigator.pop(dialogContext);
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Checkbox(
                          value: t.isDone,
                          activeColor: t.color,
                          onChanged: (_) => state.toggleTaskDone(t.id),
                        ),
                      ],
                    ),
                  ),
                )),
          const SizedBox(height: 8),
          const Text('Upcoming Assignments',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ...state.assignments.map((a) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: context.adaptiveField,
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 10, color: AppColors.danger),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a['title']!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(a['due']!,
                              style: const TextStyle(
                                  color: AppColors.subtitle, fontSize: 12)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() => state.assignments.remove(a));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('"${a['title']}" marked complete')),
                        );
                      },
                      child: const Icon(Icons.check_circle_outline_rounded,
                          color: AppColors.subtitle),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 90),
        ],
      ),
    );
  }

  String _monthYearLabel(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
