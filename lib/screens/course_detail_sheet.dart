import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import 'lesson_reader_screen.dart';

class CourseDetailSheet extends StatelessWidget {
  const CourseDetailSheet({super.key, required this.course});
  final CourseResult course;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final bookmarked = state.isBookmarked(course.title);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                  color: const Color(0xFFDCDCE6),
                  borderRadius: BorderRadius.circular(3)),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 130,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: course.gradientColors),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Icon(Icons.play_circle_fill_rounded,
                  color: Colors.white, size: 48),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(course.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800)),
              ),
              IconButton(
                onPressed: () {
                  state.toggleBookmark(BookmarkItem(
                    id: course.title,
                    type: BookmarkType.course,
                    title: course.title,
                    subtitle: course.author,
                    tag: 'Course',
                  ));
                },
                icon: Icon(
                  bookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          Text(course.author,
              style: const TextStyle(color: AppColors.subtitle)),
          const SizedBox(height: 12),
          Text(course.description, style: const TextStyle(height: 1.4)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.star_rounded,
                  color: Color(0xFFF2B84B), size: 18),
              const SizedBox(width: 4),
              Text('${course.rating}',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 16),
              const Icon(Icons.menu_book_rounded,
                  color: AppColors.subtitle, size: 18),
              const SizedBox(width: 4),
              Text('${course.lessons} Lessons',
                  style: const TextStyle(color: AppColors.subtitle)),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LessonReaderScreen(course: course),
                ),
              );
            },
            child: const Text('Start a Lesson'),
          ),
        ],
      ),
    );
  }
}
