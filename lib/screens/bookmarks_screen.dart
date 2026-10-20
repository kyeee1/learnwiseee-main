import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  BookmarkType _filter = BookmarkType.course;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final items = state.bookmarks.where((b) => b.type == _filter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Courses',
                  selected: _filter == BookmarkType.course,
                  onTap: () => setState(() => _filter = BookmarkType.course),
                ),
                const SizedBox(width: 10),
                _FilterChip(
                  label: 'Notes',
                  selected: _filter == BookmarkType.note,
                  onTap: () => setState(() => _filter = BookmarkType.note),
                ),
                const SizedBox(width: 10),
                _FilterChip(
                  label: 'Quizzes',
                  selected: _filter == BookmarkType.quiz,
                  onTap: () => setState(() => _filter = BookmarkType.quiz),
                ),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      'No bookmarked ${_filter.name}s yet.',
                      style: const TextStyle(color: AppColors.subtitle),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final item = items[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            color: context.adaptiveField,
                            borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [
                                  Color(0xFF2193B0),
                                  Color(0xFF6DD5ED)
                                ]),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.menu_book_rounded,
                                  color: Colors.white),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: context.adaptiveSoftPrimary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(item.tag,
                                        style: const TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(item.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  Text(item.subtitle,
                                      style: const TextStyle(
                                          color: AppColors.subtitle,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.bookmark_rounded,
                                  color: AppColors.primary),
                              onPressed: () {
                                setState(() => state.bookmarks
                                    .removeWhere((b) => b.id == item.id));
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : context.adaptiveField,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.white : context.adaptiveText,
                fontWeight: FontWeight.w700)),
      ),
    );
  }
}
