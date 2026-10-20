import 'package:flutter/material.dart';
import '../theme.dart';

class _OnboardingPageData {
  final IconData icon;
  final List<Color> gradient;
  final String title;
  final String description;

  const _OnboardingPageData({
    required this.icon,
    required this.gradient,
    required this.title,
    required this.description,
  });
}

const _pages = [
  _OnboardingPageData(
    icon: Icons.smart_toy_rounded,
    gradient: [Color(0xFFB8B3FF), Color(0xFF8880FF)],
    title: 'AI-Powered Study\nAssistant',
    description:
        'Stuck on a tricky math equation or complex physics formula? Chat with LearnWise AI anytime to get step-by-step, simple explanations.',
  ),
  _OnboardingPageData(
    icon: Icons.quiz_rounded,
    gradient: [Color(0xFF8AD8D0), Color(0xFF57B8C9)],
    title: 'Custom Quizzes\nIn Seconds',
    description:
        'Turn any topic into a personalized quiz. Choose the difficulty, question type, and length that fits how you like to study.',
  ),
  _OnboardingPageData(
    icon: Icons.event_note_rounded,
    gradient: [Color(0xFFFFC98A), Color(0xFFF29B4B)],
    title: 'Stay On Top Of\nYour Schedule',
    description:
        'Plan lessons, track assignments, and get reminders so you never miss a deadline again.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _next() {
    if (_index == _pages.length - 1) {
      _goToLogin();
    } else {
      _controller.nextPage(
          duration: const Duration(milliseconds: 320), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    final page = _pages[i];
                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: page.gradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child:
                                Icon(page.icon, size: 96, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              height: 1.2),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.subtitle,
                              height: 1.4),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) {
                  final active = i == _index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color:
                          active ? AppColors.primary : const Color(0xFFDCDCE6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _goToLogin,
                      child: const Text('Skip'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _next,
                      child: Text(
                          _index == _pages.length - 1 ? 'Get Started' : 'Next'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
