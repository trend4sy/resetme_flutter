import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../main.dart';
import '../../../data/models/user_profile.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _page = 0;
  final _answers = <String, dynamic>{};

  final _questions = [
    _Question(
      'ما هدفك الأساسي؟',
      ['تقليل التوتر', 'تحسين النوم', 'فهم المزاج', 'كل ما سبق'],
      'primary_goal',
    ),
    _Question(
      'متى تكون المشكلة أكبر؟',
      ['صباحًا', 'أثناء العمل', 'مساءً', 'قبل النوم'],
      'worst_time',
    ),
    _Question(
      'كم دقيقة تستطيع الالتزام يوميًا؟',
      ['3', '5', '10', '15'],
      'daily_commitment',
    ),
    _Question(
      'ما أكثر سبب للتوتر؟',
      ['عمل', 'دراسة', 'مال', 'علاقات', 'صحة', 'غير واضح'],
      'stress_cause',
    ),
    _Question(
      'وقت النوم المعتاد؟',
      ['قبل 10 مساءً', '10-11 مساءً', '11-12 مساءً', 'بعد 12 صباحًا'],
      'bedtime',
    ),
    _Question(
      'ما تفضيلك؟',
      ['صوت فقط', 'نص', 'تنفس بصري', 'مزيج'],
      'preferred_style',
    ),
  ];

  void _selectAnswer(String answer) {
    final key = _questions[_page].key;
    _answers[key] = answer;
    if (_page < _questions.length - 1) {
      setState(() => _page++);
    } else {
      _complete();
    }
  }

  void _complete() {
    final profile = UserProfile(
      onboardingCompleted: true,
      primaryGoal: _answers['primary_goal'] as String?,
      worstTime: _answers['worst_time'] as String?,
      dailyCommitmentMinutes: int.tryParse(_answers['daily_commitment'] as String? ?? '5') ?? 5,
      topStressCause: _answers['stress_cause'] as String?,
      bedtime: _answers['bedtime'] as String?,
      preferredStyle: _answers['preferred_style'] as String?,
    );
    AppDependencies.hiveService.saveProfile(profile);
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    if (_page == 0) {
      return _buildWelcome();
    }
    return _buildQuestion();
  }

  Widget _buildWelcome() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ResetMe', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.comfort)),
              SizedBox(height: 16),
              Text(
                'افهم توترك. نم أفضل.\nابدأ بروتين قصير يناسب يومك',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 8),
              Text(
                '6 أسئلة فقط لبناء خطتك الشخصية',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => setState(() => _page = 1),
                child: Text('ابدأ'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion() {
    final q = _questions[_page];

    return Scaffold(
      appBar: AppBar(
        title: Text('خطوة $_page من ${_questions.length}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => setState(() => _page--),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_page) / _questions.length,
              backgroundColor: AppColors.comfort.withOpacity(0.2),
              color: AppColors.comfort,
            ),
            SizedBox(height: 40),
            Text(q.question, style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 32),
            ...q.options.map((opt) => Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    side: BorderSide(color: AppColors.comfort.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _selectAnswer(opt),
                  child: Text(opt, style: TextStyle(fontSize: 16)),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _Question {
  final String question;
  final List<String> options;
  final String key;

  _Question(this.question, this.options, this.key);
}
