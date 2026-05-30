import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../main.dart';
import '../../../data/models/routine.dart';
import '../../../data/models/soundscape.dart';

class SleepRoutineScreen extends StatefulWidget {
  const SleepRoutineScreen({super.key});

  @override
  State<SleepRoutineScreen> createState() => _SleepRoutineScreenState();
}

class _SleepRoutineScreenState extends State<SleepRoutineScreen> {
  Routine? _activeRoutine;
  bool _showSounds = false;
  String? _selectedSoundId;

  @override
  void initState() {
    super.initState();
    _activeRoutine = AppDependencies.routineRepo.getRoutineById('sleep_basic');
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = AppDependencies.subscriptionService.isPremium;
    final sounds = Soundscape.all(isPremium);

    return Scaffold(
      appBar: AppBar(title: Text('استعد للنوم')),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Text('روتين الليلة', style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: 8),
          Text(
            '${_activeRoutine?.totalMinutes ?? 14} دقائق',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 24),
            if (_activeRoutine != null)
            ..._activeRoutine!.steps.map((step) => Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    _stepIcon(step.type),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(step.title, style: Theme.of(context).textTheme.titleMedium),
                          SizedBox(height: 4),
                          Text('${step.durationMinutes} دقائق', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                    if (_activeRoutine!.isPremium && !isPremium)
                      Icon(Icons.lock, size: 16, color: AppColors.textSecondary),
                  ],
                ),
              ),
            )),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _startSleepRoutine,
              icon: Icon(Icons.nightlight_round),
              label: Text('ابدأ روتين النوم'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sleepDark,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('الأصوات المحيطية', style: Theme.of(context).textTheme.titleLarge),
              TextButton(
                onPressed: () => setState(() => _showSounds = !_showSounds),
                child: Text(_showSounds ? 'إخفاء' : 'عرض'),
              ),
            ],
          ),
          if (_showSounds)
            ...sounds.map((sound) => Card(
              child: ListTile(
                leading: Icon(Icons.music_note, color: AppColors.comfort),
                title: Text(sound.name),
                subtitle: Text('${sound.durationMinutes} دقيقة'),
                trailing: _selectedSoundId == sound.id
                  ? Icon(Icons.stop_circle, color: AppColors.error)
                  : Icon(Icons.play_circle, color: AppColors.comfort),
                onTap: () {
                  if (_selectedSoundId == sound.id) {
                    AppDependencies.audioService.stop();
                    setState(() => _selectedSoundId = null);
                  } else if (!sound.isPremium || isPremium) {
                    AppDependencies.audioService.playSound(sound.assetPath);
                    setState(() => _selectedSoundId = sound.id);
                  } else {
                    context.push('/premium');
                  }
                },
              ),
            )),
          SizedBox(height: 32),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('روتين إضافي', style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 12),
                  ListTile(
                    title: Text('نوم عميق'),
                    subtitle: Text('روتين كامل — 33 دقيقة'),
                    trailing: isPremium
                      ? Icon(Icons.lock_open)
                      : Icon(Icons.lock, color: AppColors.textSecondary),
                    onTap: isPremium
                      ? () => setState(() {
                          _activeRoutine = AppDependencies.routineRepo.getRoutineById('sleep_deep');
                        })
                      : () => context.push('/premium'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepIcon(RoutineStepType type) {
    switch (type) {
      case RoutineStepType.breathing: return Icon(Icons.air, color: AppColors.comfort, size: 32);
      case RoutineStepType.journal: return Icon(Icons.edit_note, color: AppColors.alertWarm, size: 32);
      case RoutineStepType.sound: return Icon(Icons.music_note, color: AppColors.moodCalm, size: 32);
      case RoutineStepType.meditation: return Icon(Icons.self_improvement, color: AppColors.sleepDark, size: 32);
      case RoutineStepType.reflection: return Icon(Icons.lightbulb, color: AppColors.alertWarm, size: 32);
      case RoutineStepType.gratitude: return Icon(Icons.favorite, color: AppColors.success, size: 32);
    }
  }

  void _startSleepRoutine() {
    if (_activeRoutine == null) return;
    final firstStep = _activeRoutine!.steps.first;
    if (firstStep.exerciseId != null) {
      context.go('/breathing/${firstStep.exerciseId}');
    } else if (firstStep.type == RoutineStepType.journal) {
      context.go('/journal');
    }
  }
}
