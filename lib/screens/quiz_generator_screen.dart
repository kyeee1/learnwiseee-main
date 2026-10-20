import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';

class QuizGeneratorScreen extends StatefulWidget {
  const QuizGeneratorScreen({super.key});

  @override
  State<QuizGeneratorScreen> createState() => _QuizGeneratorScreenState();
}

class _QuizGeneratorScreenState extends State<QuizGeneratorScreen> {
  final _topicController = TextEditingController();
  bool _generating = false;

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  Future<void> _generateQuiz() async {
    final topic = _topicController.text.trim();
    if (topic.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a quiz topic or subject')),
      );
      return;
    }
    final state = AppScope.of(context);
    setState(() => _generating = true);
    await Future.delayed(
        const Duration(milliseconds: 900)); // simulate AI generation
    if (!mounted) return;
    setState(() => _generating = false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _QuizReadySheet(
        topic: topic,
        difficulty: state.quizDifficulty,
        questionType: state.quizQuestionType,
        questionCount: state.quizQuestionCount,
        timeLimit:
            state.quizTimeLimitEnabled ? state.quizTimeLimitMinutes : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          const Text('AI Quiz Generator',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text('Create custom flashcards & tests powered by AI',
              style: TextStyle(color: AppColors.subtitle)),
          const SizedBox(height: 26),
          const Text('Quiz Topic / Subject',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          TextField(
            controller: _topicController,
            decoration: const InputDecoration(
                hintText: 'e.g. Thermodynamics or French Verbs'),
          ),
          const SizedBox(height: 22),
          const Text('Difficulty Level',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Row(
            children: ['Easy', 'Medium', 'Hard']
                .map((level) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _ChoiceChipButton(
                          label: level,
                          selected: state.quizDifficulty == level,
                          onTap: () => state.setQuizDifficulty(level),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 22),
          const Text('Question Types',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ['Multiple Choice', 'True/False', 'Short Answer']
                .map((type) => _ChoiceChipButton(
                      label: type,
                      selected: state.quizQuestionType == type,
                      onTap: () => state.setQuizQuestionType(type),
                    ))
                .toList(),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Number of Questions',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  Text('Choose between 5 and 50',
                      style:
                          TextStyle(color: AppColors.subtitle, fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  _RoundIconButton(
                      icon: Icons.remove, onTap: state.decrementQuizQuestions),
                  SizedBox(
                    width: 36,
                    child: Text('${state.quizQuestionCount}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 16)),
                  ),
                  _RoundIconButton(
                      icon: Icons.add,
                      onTap: state.incrementQuizQuestions,
                      filled: true),
                ],
              ),
            ],
          ),
          const Divider(height: 34),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Add Time Limit',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  Text('${state.quizTimeLimitMinutes} minutes',
                      style: const TextStyle(
                          color: AppColors.subtitle, fontSize: 12)),
                ],
              ),
              Switch(
                value: state.quizTimeLimitEnabled,
                onChanged: state.toggleQuizTimeLimit,
              ),
            ],
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _generating ? null : _generateQuiz,
            child: _generating
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.4, color: Colors.white),
                  )
                : const Text('Generate Quiz'),
          ),
        ],
      ),
    );
  }
}

class _ChoiceChipButton extends StatelessWidget {
  const _ChoiceChipButton(
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : context.adaptiveField,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? Colors.white : context.adaptiveText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton(
      {required this.icon, required this.onTap, this.filled = false});
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: filled ? context.adaptiveSoftPrimary : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
              color: filled ? Colors.transparent : context.adaptiveBorder),
        ),
        child: Icon(icon,
            size: 18, color: filled ? AppColors.primary : context.adaptiveText),
      ),
    );
  }
}

class _QuizReadySheet extends StatelessWidget {
  const _QuizReadySheet({
    required this.topic,
    required this.difficulty,
    required this.questionType,
    required this.questionCount,
    required this.timeLimit,
  });

  final String topic;
  final String difficulty;
  final String questionType;
  final int questionCount;
  final int? timeLimit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                  color: context.adaptiveSoftPrimary, shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_rounded,
                  color: AppColors.primary, size: 40),
            ),
          ),
          const SizedBox(height: 18),
          Text('Your "$topic" quiz is ready!',
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(
            '$questionCount $questionType questions • $difficulty difficulty'
            '${timeLimit != null ? ' • $timeLimit min limit' : ''}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.subtitle),
          ),
          const SizedBox(height: 22),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Starting quiz session...')),
              );
            },
            child: const Text('Start Quiz'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Edit Settings'),
          ),
        ],
      ),
    );
  }
}
