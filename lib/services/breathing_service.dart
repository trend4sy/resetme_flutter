import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BreathingState {
  final String exerciseId;
  final int currentPhase;
  final int phaseTimeLeft;
  final int currentCycle;
  final int totalCycles;
  final bool isActive;
  final bool isComplete;
  final List<int> phases;
  final List<String> phaseLabels;

  BreathingState({
    this.exerciseId = '',
    this.currentPhase = 0,
    this.phaseTimeLeft = 0,
    this.currentCycle = 0,
    this.totalCycles = 1,
    this.isActive = false,
    this.isComplete = false,
    this.phases = const [],
    this.phaseLabels = const [],
  });

  BreathingState copyWith({
    String? exerciseId,
    int? currentPhase,
    int? phaseTimeLeft,
    int? currentCycle,
    int? totalCycles,
    bool? isActive,
    bool? isComplete,
    List<int>? phases,
    List<String>? phaseLabels,
  }) {
    return BreathingState(
      exerciseId: exerciseId ?? this.exerciseId,
      currentPhase: currentPhase ?? this.currentPhase,
      phaseTimeLeft: phaseTimeLeft ?? this.phaseTimeLeft,
      currentCycle: currentCycle ?? this.currentCycle,
      totalCycles: totalCycles ?? this.totalCycles,
      isActive: isActive ?? this.isActive,
      isComplete: isComplete ?? this.isComplete,
      phases: phases ?? this.phases,
      phaseLabels: phaseLabels ?? this.phaseLabels,
    );
  }

  double get progress {
    if (totalCycles == 0) return 0;
    return (currentCycle + (phases.isNotEmpty ? currentPhase / phases.length : 0)) / totalCycles;
  }

  String get currentLabel => phaseLabels.isNotEmpty && currentPhase < phaseLabels.length
    ? phaseLabels[currentPhase] : '';
}

class BreathingService {
  StreamController<BreathingState>? _controller;
  Timer? _timer;

  Stream<BreathingState> startExercise(
    List<int> phases,
    List<String> labels,
    int totalCycles,
    String exerciseId,
  ) {
    _controller = StreamController<BreathingState>.broadcast();
    _startPhase(phases, labels, totalCycles, exerciseId);
    return _controller!.stream;
  }

  void _startPhase(
    List<int> phases,
    List<String> labels,
    int totalCycles,
    String exerciseId,
    int cycleIndex = 0,
    int phaseIndex = 0,
  ) {
    if (cycleIndex >= totalCycles) {
      _controller?.add(BreathingState(
        isActive: false,
        isComplete: true,
        totalCycles: totalCycles,
        phases: phases,
        phaseLabels: labels,
        exerciseId: exerciseId,
        currentCycle: totalCycles,
      ));
      _controller?.close();
      return;
    }

    var timeLeft = phases[phaseIndex];
    _controller?.add(BreathingState(
      exerciseId: exerciseId,
      currentPhase: phaseIndex,
      phaseTimeLeft: timeLeft,
      currentCycle: cycleIndex,
      totalCycles: totalCycles,
      isActive: true,
      phases: phases,
      phaseLabels: labels,
    ));

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      timeLeft--;
      _controller?.add(BreathingState(
        exerciseId: exerciseId,
        currentPhase: phaseIndex,
        phaseTimeLeft: timeLeft,
        currentCycle: cycleIndex,
        totalCycles: totalCycles,
        isActive: true,
        phases: phases,
        phaseLabels: labels,
      ));

      if (timeLeft <= 0) {
        timer.cancel();
        final nextPhase = phaseIndex + 1;
        if (nextPhase >= phases.length) {
          _startPhase(phases, labels, totalCycles, exerciseId, cycleIndex + 1, 0);
        } else {
          _startPhase(phases, labels, totalCycles, exerciseId, cycleIndex, nextPhase);
        }
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _controller?.close();
  }

  void dispose() {
    stop();
  }
}
