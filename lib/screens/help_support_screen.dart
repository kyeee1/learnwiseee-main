import 'package:flutter/material.dart';
import '../theme.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _FaqItem {
  _FaqItem(this.question, this.answer, {this.expanded = false});
  final String question;
  final String answer;
  bool expanded;
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  final List<_FaqItem> _faqs = [
    _FaqItem(
      'How does the AI video / study tutor work?',
      'The AI Tutor analyzes your performance across courses and answers your specific questions '
          'dynamically, sourcing verified academic databases.',
      expanded: true,
    ),
    _FaqItem(
      'What export and study formats are available?',
      'You can export summaries and quizzes as PDF, DOCX, or plain text, and sync flashcards to your planner.',
    ),
    _FaqItem(
      'Can I customize team study collaboration?',
      'Yes — create a study group, invite classmates by email, and share notes, quizzes, and planners together.',
    ),
    _FaqItem(
      'Is my studying data private and secure?',
      'All notes and quiz data are encrypted in transit and at rest, and are never shared with third parties.',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _sendFeedback() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Send Feedback'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(
              hintText: 'Tell us what\'s on your mind...'),
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
                const SnackBar(
                    content: Text('Thanks! Your feedback has been sent.')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _liveChat() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_rounded, color: AppColors.primary, size: 40),
            SizedBox(height: 12),
            Text('Connecting you to Live AI Chat support...',
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  void _emailSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Opening mail app to support@learnwise.edu...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleFaqs = _query.trim().isEmpty
        ? _faqs
        : _faqs
            .where(
                (f) => f.question.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
          title: const Text('Help & Support',
              style: TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _query = v),
            decoration: const InputDecoration(
              hintText: 'Search help articles, topics...',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: 22),
          const Text('Frequently Asked Questions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          ...visibleFaqs.map((faq) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: context.adaptiveBorder),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: faq.expanded,
                    title: Text(faq.question,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14)),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    onExpansionChanged: (open) =>
                        setState(() => faq.expanded = open),
                    children: [
                      Text(faq.answer,
                          style: const TextStyle(
                              color: AppColors.subtitle, height: 1.4)),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 20),
          const Text('Still Need Help?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ContactCard(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Live AI Chat',
                  subtitle: 'Get assistance instantly',
                  onTap: _liveChat,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _ContactCard(
                  icon: Icons.mail_outline_rounded,
                  title: 'Email Support',
                  subtitle: 'Response within 24 hours',
                  onTap: _emailSupport,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
              onPressed: _sendFeedback, child: const Text('Send Feedback')),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.adaptiveField,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    color: context.adaptiveSoftPrimary,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(height: 10),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style:
                      const TextStyle(color: AppColors.subtitle, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}
