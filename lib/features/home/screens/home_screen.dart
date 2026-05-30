import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../main.dart';
import '../../../data/models/routine.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _timeGreeting = 'صباح الخير';
  String? _suggestedRoutineTitle;
  List<RoutineStep>? _suggestedSteps;

  @override
  void initState() {
    super.initState();
    _initGreeting();
    _loadSuggestion();
  }

  void _initGreeting() {
    final hour = DateTime.now().hour;
    setState(() {
      if (hour < 12) _timeGreeting = 'صباح الخير';
      else if (hour < 18) _timeGreeting = 'مساء الخير';
      else _timeGreeting = 'مساء الخير';
    });
  }

  void _loadSuggestion() {
    final mood = AppDependencies.moodRepo.getTodayMood();
    if (mood != null) {
      final timeOfDay = DateTime.now().hour >= 18 ? 'مساء' : 'صباح';
      final routine = AppDependencies.routineRepo.recommendRoutine(
        mood.moodLevel >= 4 ? 'هادئ' : mood.moodLevel >= 3 ? 'مشتت' : 'متوتر',
        mood.stressLevel,
        mood.sleepQuality,
        timeOfDay,
      );
      setState(() {
        _suggestedRoutineTitle = routine?.title;
        _suggestedSteps = routine?.steps;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasCheckedIn = AppDependencies.moodRepo.hasCheckedInToday();

    return Scaffold(
      appBar: AppBar(
        title: Text('ResetMe'),
        actions: [
          IconButton(
            icon: Icon(Icons.analytics_outlined),
            onPressed: () => context.go('/analytics'),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Text(
            _timeGreeting,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          SizedBox(height: 8),
          Text(
            'كيف تشعر الآن؟',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _moodChip('هادئ', AppColors.moodCalm, Icons.spa),
              _moodChip('متوتر', AppColors.moodStressed, Icons.bolt),
              _moodChip('مرهق', AppColors.moodTired, Icons.battery_alert),
              _moodChip('حزين', AppColors.moodSad, Icons.sentiment_dissatisfied),
              _moodChip('مشتت', AppColors.moodDistracted, Icons.gps_off),
              _moodChip('لا أستطيع النوم', AppColors.moodCantSleep, Icons.nightlight),
            ],
          ),
          SizedBox(height: 24),
          if (hasCheckedIn && _suggestedRoutineTitle != null) ...[
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome, color: AppColors.alertWarm),
                        SizedBox(width: 8),
                        Text('اقتراح اليوم', style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '$_suggestedRoutineTitle — ${_suggestedSteps?.fold(0, (sum, s) => sum + s.durationMinutes) ?? 0} دقائق',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: 8),
                    ...?_suggestedSteps?.map((step) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Icon(Icons.circle, size: 6, color: AppColors.comfort),
                          SizedBox(width: 8),
                          Text('${step.title} — ${step.durationMinutes} دقائق'),
                        ],
                      ),
                    )),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _startRoutine(context),
                        icon: Icon(Icons.play_arrow),
                        label: Text('ابدأ الآن'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'لم تسجل حالتك اليوم',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'خذ دقيقة لتسجيل مزاجك وتوترك',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.push('/checkin'),
                      child: Text('سجل الآن'),
                    ),
                  ],
                ),
              ),
            ),
          ],
          SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: Icon(Icons.nightlight_round, color: AppColors.sleepDark),
              title: Text('روتين النوم'),
              subtitle: Text('استعد لنوم هادئ'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.go('/sleep'),
            ),
          ),
          SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(Icons.self_improvement, color: AppColors.comfort),
              title: Text('تمارين التنفس'),
              subtitle: Text('3 تقنيات لتخفيف التوتر'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.go('/breathing/box_breathing'),
            ),
          ),
          SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(Icons.edit_note, color: AppColors.alertWarm),
              title: Text('يوميات تفريغ'),
              subtitle: Text('فرغ أفكارك قبل النوم'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.go('/journal'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _moodChip(String label, Color color, IconData icon) {
    return ActionChip(
      avatar: Icon(icon, size: 18, color: color),
      label: Text(label, style: TextStyle(fontSize: 13)),
      onPressed: () {
        if (!AppDependencies.moodRepo.hasCheckedInToday()) {
          context.push('/checkin');
        }
      },
      side: BorderSide(color: color.withOpacity(0.3)),
      shape: StadiumBorder(),
    );
  }

  void _startRoutine(BuildContext context) {
    if (_suggestedSteps == null || _suggestedSteps!.isEmpty) return;
    final firstStep = _suggestedSteps!.first;
    if (firstStep.exerciseId != null) {
      context.go('/breathing/${firstStep.exerciseId}');
    } else if (firstStep.type == RoutineStepType.journal) {
      context.go('/journal');
    }
  }
}
