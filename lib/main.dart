import 'package:flutter/material.dart';
import 'app_state.dart';
import 'theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/root_shell.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const LearnWiseApp());
}

class LearnWiseApp extends StatefulWidget {
  const LearnWiseApp({super.key});

  @override
  State<LearnWiseApp> createState() => _LearnWiseAppState();
}

class _LearnWiseAppState extends State<LearnWiseApp>
    with SingleTickerProviderStateMixin {
  final AppState _appState = AppState();
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(_controller);

    return AppScope(
      state: _appState,
      child: AnimatedBuilder(
        animation: Listenable.merge([_appState, _controller]),
        builder: (context, _) {
          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: slideAnimation,
              child: MaterialApp(
                title: 'LearnWise',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode:
                    _appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                builder: (context, child) {
                  final mediaQuery = MediaQuery.of(context);
                  return MediaQuery(
                    data: mediaQuery.copyWith(
                      textScaler: TextScaler.linear(_appState.textScaleFactor),
                    ),
                    child: child!,
                  );
                },
                initialRoute: '/onboarding',
                routes: {
                  '/onboarding': (_) => const OnboardingScreen(),
                  '/login': (_) => const LoginScreen(),
                  '/signup': (_) => const SignUpScreen(),
                  '/home': (_) => const RootShell(),
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
