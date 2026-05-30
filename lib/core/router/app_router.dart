import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/sleep/screens/sleep_routine_screen.dart';
import '../../features/analytics/screens/weekly_analytics_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/checkin/screens/checkin_screen.dart';
import '../../features/breathing/screens/breathing_screen.dart';
import '../../features/meditation/screens/meditation_player_screen.dart';
import '../../features/journal/screens/journal_screen.dart';
import '../../features/subscription/screens/subscription_screen.dart';

final GlobalKey<NavigatorState> _rootNavigator = GlobalKey<NavigatorState>();

GoRouter buildRouter(BuildContext context) {
  return GoRouter(
    navigatorKey: _rootNavigator,
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/sleep',
            name: 'sleep',
            builder: (context, state) => const SleepRoutineScreen(),
          ),
          GoRoute(
            path: '/mood',
            name: 'mood',
            builder: (context, state) => const WeeklyAnalyticsScreen(),
          ),
          GoRoute(
            path: '/sessions',
            name: 'sessions',
            builder: (context, state) => const SessionsScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/checkin',
        name: 'checkin',
        builder: (context, state) => const CheckinScreen(),
      ),
      GoRoute(
        path: '/breathing/:exerciseId',
        name: 'breathing',
        builder: (context, state) => BreathingScreen(
          exerciseId: state.pathParameters['exerciseId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/meditation/:meditationId',
        name: 'meditation',
        builder: (context, state) => MeditationPlayerScreen(
          meditationId: state.pathParameters['meditationId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/journal',
        name: 'journal',
        builder: (context, state) => const JournalScreen(),
      ),
      GoRoute(
        path: '/premium',
        name: 'premium',
        builder: (context, state) => const SubscriptionScreen(),
      ),
      GoRoute(
        path: '/analytics',
        name: 'analytics',
        builder: (context, state) => const WeeklyAnalyticsScreen(),
      ),
    ],
  );
}

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    if (location.startsWith('/sleep')) currentIndex = 1;
    else if (location.startsWith('/mood') || location.startsWith('/analytics')) currentIndex = 2;
    else if (location.startsWith('/sessions')) currentIndex = 3;
    else if (location.startsWith('/profile')) currentIndex = 4;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: child,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) {
          switch (i) {
            case 0: context.go('/home');
            case 1: context.go('/sleep');
            case 2: context.go('/mood');
            case 3: context.go('/sessions');
            case 4: context.go('/profile');
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.wb_sunny_outlined), activeIcon: Icon(Icons.wb_sunny), label: 'اليوم'),
          BottomNavigationBarItem(icon: Icon(Icons.nightlight_outlined), activeIcon: Icon(Icons.nightlight), label: 'النوم'),
          BottomNavigationBarItem(icon: Icon(Icons.insights_outlined), activeIcon: Icon(Icons.insights), label: 'المزاج'),
          BottomNavigationBarItem(icon: Icon(Icons.self_improvement_outlined), activeIcon: Icon(Icons.self_improvement), label: 'جلسات'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'أنا'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الجلسات')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.air, color: AppColors.comfort),
              title: Text('تمارين التنفس'),
              subtitle: Text('3 تقنيات'),
              onTap: () => context.go('/breathing/box_breathing'),
            ),
          ),
          SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(Icons.self_improvement, color: AppColors.comfort),
              title: Text('تأملات قصيرة'),
              subtitle: Text('12 جلسة'),
              onTap: () {},
            ),
          ),
          SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(Icons.edit_note, color: AppColors.comfort),
              title: Text('يوميات'),
              subtitle: Text('تفريغ وامتنان'),
              onTap: () => context.go('/journal'),
            ),
          ),
          SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(Icons.analytics_outlined, color: AppColors.comfort),
              title: Text('التحليل الأسبوعي'),
              subtitle: Text('متوسط التوتر والنوم والمزاج'),
              onTap: () => context.go('/analytics'),
            ),
          ),
        ],
      ),
    );
  }
}
