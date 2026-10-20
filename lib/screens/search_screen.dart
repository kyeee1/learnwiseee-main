import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import 'course_detail_sheet.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final results = _query.trim().isEmpty
        ? state.allCourses
        : state.allCourses
            .where((c) =>
                c.title.toLowerCase().contains(_query.toLowerCase()) ||
                c.author.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            const Text('Search', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            onPressed: () => _showMoreOptions(context),
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: context.adaptiveBorder)),
              child: const Icon(Icons.more_horiz_rounded, size: 20),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          TextField(
            controller: _controller,
            onChanged: (v) => setState(() => _query = v),
            onSubmitted: (v) => state.addRecentSearch(v),
            decoration: InputDecoration(
              hintText: 'Search courses, topics, tutors...',
              prefixIcon:
                  const Icon(Icons.search_rounded, color: AppColors.primary),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => setState(() {
                        _controller.clear();
                        _query = '';
                      }),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Searches',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              if (state.recentSearches.isNotEmpty)
                TextButton(
                  onPressed: () => setState(() => state.recentSearches.clear()),
                  child: const Text('Clear'),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: state.recentSearches
                .map((term) => GestureDetector(
                      onTap: () => setState(() {
                        _controller.text = term;
                        _query = term;
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: context.adaptiveBorder),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(term),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 24),
          const Text('Trending Today',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          ...state.trendingTopics.map((topic) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: context.adaptiveField,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => setState(() {
                      _controller.text = topic['title']!;
                      _query = topic['title']!;
                      state.addRecentSearch(topic['title']!);
                    }),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: context.adaptiveSoftPrimary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.trending_up_rounded,
                                color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(topic['title']!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700)),
                                Text(topic['subject']!,
                                    style: const TextStyle(
                                        color: AppColors.subtitle,
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded,
                              color: AppColors.subtitle),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
          const SizedBox(height: 14),
          const Text('Search Results',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          if (results.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No results for "$_query"',
                    style: const TextStyle(color: AppColors.subtitle)),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (context, i) {
                final course = results[i];
                return GestureDetector(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => CourseDetailSheet(course: course),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.adaptiveField,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 90,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: course.gradientColors)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(course.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13)),
                              const SizedBox(height: 2),
                              Text(course.author,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: AppColors.subtitle, fontSize: 11)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded,
                                      color: Color(0xFFF2B84B), size: 14),
                                  const SizedBox(width: 2),
                                  Text('${course.rating}',
                                      style: const TextStyle(fontSize: 11)),
                                  const Spacer(),
                                  Text('${course.lessons} Lessons',
                                      style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 10)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.filter_list_rounded),
              title: const Text('Filter results'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.sort_rounded),
              title: const Text('Sort by rating'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
