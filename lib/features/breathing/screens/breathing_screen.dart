import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/breathing_exercise.dart';
import '../../../main.dart';

class BreathingScreen extends StatefulWidget {
  final String exerciseId;
  const BreathingScreen({super.key, required this.exerciseId});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  BreathingExercise? _exercise;
  StreamSubscription? _subscription;
  bool _isActive = false;
  bool _isComplete = false;
  int _phaseTimeLeft = 0;
  int _currentPhase = 0;
  int _currentCycle = 0;
  int _totalCycles = 1;
  String _currentLabel = '';
  List<int> _phases = [];
  List<String> _labels = [];
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    _scaleAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _loadExercise();
  }

  void _loadExercise() {
    try {
      _exercise = BreathingExercise.all.firstWhere((e) => e.id == widget.exerciseId);
    } catch (_) {
      _exercise = BreathingExercise.all.first;
    }
    _phases = _exercise!.phases;
    _labels = _exercise!.phaseLabels;
    _totalCycles = _exercise!.totalCycles;
  }

  void _start() {
    setState(() => _isActive = true);
    final service = AppDependencies.breathingService;
    _subscription = service.startExercise(
      _phases, _labels, _totalCycles, widget.exerciseId,
    ).listen((state) {
      if (!mounted) return;
      setState(() {
        _currentPhase = state.currentPhase;
        _phaseTimeLeft = state.phaseTimeLeft;
        _currentCycle = state.currentCycle;
        _currentLabel = state.currentLabel;
        _isComplete = state.isComplete;
        _isActive = state.isActive;
      });
      _animateBreath(state.currentPhase, _phases);
    });
  }

  void _animateBreath(int phase, List<int> phases) {
    if (phase >= phases.length) return;
    final duration = Duration(seconds: phases[phase]);
    _animController.duration = duration;
    if (phase == 0 || phase == phases.length - 1) {
      _animController.forward(from: 0.3);
    } else {
      _animController.forward(from: 0.6);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    AppDependencies.breathingService.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_exercise?.title ?? ''),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            AppDependencies.breathingService.stop();
            context.pop();
          },
        ),
      ),
      body: Center(
        child: _isComplete ? _buildComplete() : _buildExercise(),
      ),
    );
  }

  Widget _buildExercise() {
    final phaseColors = [
      AppColors.comfort,
      AppColors.alertWarm,
      AppColors.sleepDark,
      AppColors.moodCalm,
    ];

    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isActive) ...[
            Text(
              'دورة $_currentCycle من $_totalCycles',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 32),
            AnimatedBuilder(
              animation: _scaleAnim,
              builder: (context, child) {
                final color = _currentPhase < phaseColors.length
                  ? phaseColors[_currentPhase] : AppColors.comfort;
                return Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.15),
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Transform.scale(
                    scale: 0.5 + (_scaleAnim.value * 0.5),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withOpacity(0.3),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$_phaseTimeLeft',
                              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: color),
                            ),
                            Text(_currentLabel, style: TextStyle(fontSize: 14, color: color)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ] else ...[
            Icon(Icons.air, size: 80, color: AppColors.comfort),
            SizedBox(height: 16),
            Text(_exercise?.description ?? '', textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text(_exercise?.benefit ?? '', textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 32),
            Text('${_totalCycles} دورات', style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 24),
          ],
          SizedBox(height: 32),
          if (!_isActive)
            ElevatedButton.icon(
              onPressed: _start,
              icon: Icon(Icons.play_arrow),
              label: Text('ابدأ التمرين'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildComplete() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, size: 80, color: AppColors.comfort),
        SizedBox(height: 16),
        Text('تم التمرين', style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(height: 8),
        Text('لقد أكملت $_totalCycles دورات', style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 32),
        ElevatedButton(
          onPressed: () => context.pop(),
          child: Text('تم'),
        ),
      ],
    );
  }
}
