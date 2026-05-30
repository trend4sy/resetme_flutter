import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../main.dart';
import '../../../data/models/mood_entry.dart';
import '../../../data/models/routine.dart';

class CheckinScreen extends StatefulWidget {
  const CheckinScreen({super.key});

  @override
  State<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  int _currentStep = 0;
  int _mood = 3;
  int _stress = 5;
  int _sleepQuality = 5;
  String _cause = 'غير معروف';
  bool _completed = false;

  final List<String> _causes = AppConstants.stressCauses;

  void _submit() {
    final entry = MoodEntry(
      id: '',
      dateTime: DateTime.now(),
      moodLevel: _mood,
      stressLevel: _stress,
      sleepQuality: _sleepQuality,
      cause: _cause,
    );
    AppDependencies.moodRepo.saveMood(entry);
    setState(() => _completed = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_completed) return _buildComplete();

    return Scaffold(
      appBar: AppBar(
        title: Text('كيف حالك اليوم؟'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentStep + 1) / 4,
              backgroundColor: AppColors.comfort.withOpacity(0.2),
              color: AppColors.comfort,
            ),
            SizedBox(height: 32),
            Expanded(child: _buildStep()),
          ],
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0: return _buildMoodStep();
      case 1: return _buildStressStep();
      case 2: return _buildSleepStep();
      case 3: return _buildCauseStep();
      default: return SizedBox();
    }
  }

  Widget _buildMoodStep() {
    return Column(
      children: [
        Text('المزاج', style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(height: 8),
        Text('كيف كان مزاجك اليوم؟', style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (i) {
            final level = i + 1;
            final isSelected = _mood == level;
            return GestureDetector(
              onTap: () => setState(() {
                _mood = level;
                _currentStep++;
              }),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.moodColor(level) : AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.moodColor(level) : AppColors.textSecondary.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    ['😊', '🙂', '😐', '😟', '😢'][i],
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStressStep() {
    return Column(
      children: [
        Text('التوتر', style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(height: 8),
        Text('مستوى التوتر من 1 إلى 10', style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 32),
        Text('$_stress', style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: AppColors.stressColor(_stress))),
        Slider(
          value: _stress.toDouble(),
          min: 1,
          max: 10,
          divisions: 9,
          onChanged: (v) => setState(() => _stress = v.round()),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('هادئ', style: Theme.of(context).textTheme.bodySmall),
            Text('مرتفع جدًا', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        SizedBox(height: 32),
        ElevatedButton(
          onPressed: () => setState(() => _currentStep++),
          child: Text('التالي'),
        ),
      ],
    );
  }

  Widget _buildSleepStep() {
    return Column(
      children: [
        Text('النوم', style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(height: 8),
        Text('جودة نوم الليلة الماضية', style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 32),
        Text('$_sleepQuality', style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: AppColors.sleepColor(_sleepQuality))),
        Slider(
          value: _sleepQuality.toDouble(),
          min: 1,
          max: 10,
          divisions: 9,
          onChanged: (v) => setState(() => _sleepQuality = v.round()),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('سيئ', style: Theme.of(context).textTheme.bodySmall),
            Text('ممتاز', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        SizedBox(height: 32),
        ElevatedButton(
          onPressed: () => setState(() => _currentStep++),
          child: Text('التالي'),
        ),
      ],
    );
  }

  Widget _buildCauseStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('السبب', style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(height: 8),
        Text('ما أقرب سبب للتوتر؟', style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 24),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _causes.map((cause) {
            final isSelected = _cause == cause;
            return ChoiceChip(
              label: Text(cause),
              selected: isSelected,
              selectedColor: AppColors.comfort.withOpacity(0.3),
              onSelected: (s) => setState(() => _cause = cause),
            );
          }).toList(),
        ),
        Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _submit();
            },
            child: Text('تأكيد'),
          ),
        ),
      ],
    );
  }

  Widget _buildComplete() {
    Routine? recommended;
    if (_stress >= 7 || _mood <= 2) {
      recommended = AppDependencies.routineRepo.getRoutineById('stress_breathing');
    } else if (_sleepQuality < 5) {
      recommended = AppDependencies.routineRepo.getRoutineById('sleep_basic');
    } else {
      recommended = AppDependencies.routineRepo.getRoutineById('calm_morning');
    }

    return Scaffold(
      appBar: AppBar(title: Text('تم التسجيل')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 80, color: AppColors.comfort),
            SizedBox(height: 16),
            Text('تم تسجيل حالتك اليوم', style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 24),
            if (recommended != null) ...[
              _buildRecommendedCard(context, recommended!),
            ],
            SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go('/home'),
              child: Text('العودة للرئيسية'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedCard(BuildContext context, Routine routine) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: AppColors.alertWarm),
                SizedBox(width: 8),
                Text('اقتراح لك', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            SizedBox(height: 8),
            Text(routine.title, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 4),
            Text('${routine.totalMinutes} دقائق'),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.go('/breathing/${routine.steps.first.exerciseId ?? 'box_breathing'}'),
                icon: Icon(Icons.play_arrow),
                label: Text('ابدأ الروتين'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
