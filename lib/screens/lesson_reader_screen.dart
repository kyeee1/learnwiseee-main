import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';

class LessonReaderScreen extends StatefulWidget {
  const LessonReaderScreen({super.key, required this.course});

  final CourseResult course;

  @override
  State<LessonReaderScreen> createState() => _LessonReaderScreenState();
}

class _LessonReaderScreenState extends State<LessonReaderScreen> {
  int _currentSection = 0;

  Widget _buildLessonCallout({
    required IconData icon,
    required String title,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.adaptiveSoftPrimary,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  text,
                  style: TextStyle(
                    height: 1.45,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonParagraph(String paragraph) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    if (paragraph.startsWith('### ')) {
      return Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 10),
        child: Text(
          paragraph.substring(4),
          style: TextStyle(
            fontSize: 16,
            height: 1.35,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      );
    }

    if (paragraph.startsWith('## ')) {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 12),
        child: Text(
          paragraph.substring(3),
          style: TextStyle(
            fontSize: 19,
            height: 1.3,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      );
    }

    final lines = paragraph.split('\n');
    final isList = lines.every(
      (line) => line.startsWith('- ') || RegExp(r'^\d+\. ').hasMatch(line),
    );
    if (isList) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: lines.map((line) {
            final numbered = RegExp(r'^(\d+)\. (.*)$').firstMatch(line);
            final content = numbered?.group(2) ?? line.substring(2);
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    child: Text(
                      numbered == null ? '•' : '${numbered.group(1)}.',
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      content.replaceAll('**', ''),
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    }

    const takeawayLabel = '**Why it matters:**';
    if (paragraph.startsWith(takeawayLabel)) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: textColor,
            ),
            children: [
              const TextSpan(
                text: 'Why it matters: ',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              TextSpan(text: paragraph.substring(takeawayLabel.length).trim()),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        paragraph.replaceAll('**', ''),
        style: TextStyle(
          fontSize: 16,
          height: 1.6,
          color: textColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sections = widget.course.lessonSections;
    final section = sections[_currentSection];
    final progress = (_currentSection + 1) / sections.length;
    final isLastSection = _currentSection == sections.length - 1;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.course.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lesson ${_currentSection + 1} of ${sections.length}',
                        style: const TextStyle(
                          color: AppColors.subtitle,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${(progress * 100).round()}%',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: context.adaptiveSoftPrimary,
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                children: [
                  // Lesson Header
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'LESSON ${_currentSection + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          section.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Lesson Content
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withValues(
                              alpha: context.isDarkMode ? 0.2 : 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: context.adaptiveSoftPrimary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.menu_book_rounded,
                                color: AppColors.primary,
                                size: 21,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Lesson Content',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ...section.body
                            .split('\n\n')
                            .map(_buildLessonParagraph),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),
                  _buildLessonCallout(
                    icon: Icons.check_circle_outline_rounded,
                    title: 'Key idea',
                    text: section.keyTakeaway,
                  ),

                  const SizedBox(height: 14),
                  _buildLessonCallout(
                    icon: Icons.edit_note_rounded,
                    title: 'Try it yourself',
                    text: section.practicePrompt,
                  ),

                  const SizedBox(height: 26),

                  // Navigation Buttons
                  Row(
                    children: [
                      if (_currentSection > 0)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _currentSection--;
                              });
                            },
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              size: 20,
                            ),
                            label: const Text('Previous'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              side: const BorderSide(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      if (_currentSection > 0) const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (!isLastSection) {
                              setState(() {
                                _currentSection++;
                              });
                            } else {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/home',
                                (route) => false,
                              );
                            }
                          },
                          icon: Icon(
                            isLastSection
                                ? Icons.check_rounded
                                : Icons.arrow_forward_rounded,
                            size: 20,
                          ),
                          label: Text(
                            isLastSection ? 'Finish Lesson' : 'Continue',
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 54),
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
