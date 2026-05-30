import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class MeditationPlayerScreen extends StatefulWidget {
  final String meditationId;
  const MeditationPlayerScreen({super.key, required this.meditationId});

  @override
  State<MeditationPlayerScreen> createState() => _MeditationPlayerScreenState();
}

class _MeditationPlayerScreenState extends State<MeditationPlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  bool _isPlaying = false;
  int _remainingSeconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat(reverse: true);
    _remainingSeconds = 5 * 60;
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _animController.repeat(reverse: true);
        _startTimer();
      } else {
        _animController.stop();
        _timer?.cancel();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _timer?.cancel();
        setState(() => _isPlaying = false);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return Container(
                  width: 200 + (_animController.value * 40),
                  height: 200 + (_animController.value * 40),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.comfort.withOpacity(0.1 + _animController.value * 0.1),
                    border: Border.all(
                      color: AppColors.comfort.withOpacity(0.3 + _animController.value * 0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$minutes:$seconds',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w200,
                        color: AppColors.comfort,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 48),
            Text(
              'تنفس بهدوء...',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 48),
            FloatingActionButton.large(
              onPressed: _togglePlay,
              backgroundColor: AppColors.comfort,
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
