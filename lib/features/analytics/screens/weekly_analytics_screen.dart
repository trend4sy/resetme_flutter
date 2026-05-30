import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../main.dart';
import '../../../data/models/weekly_analysis.dart';

class WeeklyAnalyticsScreen extends StatefulWidget {
  const WeeklyAnalyticsScreen({super.key});

  @override
  State<WeeklyAnalyticsScreen> createState() => _WeeklyAnalyticsScreenState();
}

class _WeeklyAnalyticsScreenState extends State<WeeklyAnalyticsScreen> {
  WeeklyAnalysis? _analysis;

  @override
  void initState() {
    super.initState();
    _analysis = AppDependencies.analyticsRepo.generateWeeklyAnalysis();
  }

  @override
  Widget build(BuildContext context) {
    if (_analysis == null) {
      return Scaffold(
        appBar: AppBar(title: Text('التحليل الأسبوعي')),
        body: Center(child: Text('لا توجد بيانات كافية')),
      );
    }

    final a = _analysis!;

    return Scaffold(
      appBar: AppBar(title: Text('التحليل الأسبوعي')),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          _buildSummaryCards(a),
          SizedBox(height: 24),
          _buildChart(a),
          SizedBox(height: 24),
          if (a.strongestPattern != null) _buildPatternCard(a),
          SizedBox(height: 16),
          _buildInsights(a),
          SizedBox(height: 16),
          _buildNextWeekSuggestion(a),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(WeeklyAnalysis a) {
    return Row(
      children: [
        Expanded(child: _statCard('التوتر', '${a.avgStress}/10', AppColors.stressColor(a.avgStress.round()))),
        SizedBox(width: 12),
        Expanded(child: _statCard('المزاج', '${a.avgMood}/5', AppColors.moodColor(a.avgMood.round()))),
        SizedBox(width: 12),
        Expanded(child: _statCard('النوم', '${a.avgSleepQuality?.toStringAsFixed(1) ?? "--"}/10', AppColors.sleepColor(a.avgSleepQuality?.round() ?? 5))),
      ],
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(WeeklyAnalysis a) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('اتجاهات الأسبوع', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 4),
            Text('التوتر مقابل النوم', style: Theme.of(context).textTheme.bodySmall),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: a.dailySummaries.isEmpty
                ? Center(child: Text('بيانات غير كافية'))
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: a.dailySummaries.asMap().entries.map((e) =>
                            FlSpot(e.key.toDouble(), e.value.avgStress)
                          ).toList(),
                          color: AppColors.stressColor(7),
                          barWidth: 2,
                          dotData: FlDotData(show: true),
                          isCurved: true,
                        ),
                        LineChartBarData(
                          spots: a.dailySummaries.where((d) => d.sleepQuality != null).toList().asMap().entries.map((e) =>
                            FlSpot(e.key.toDouble(), e.value.sleepQuality!)
                          ).toList(),
                          color: AppColors.sleepDark,
                          barWidth: 2,
                          dotData: FlDotData(show: true),
                          isCurved: true,
                        ),
                      ],
                    ),
                  ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendDot(AppColors.stressColor(7), 'التوتر'),
                SizedBox(width: 24),
                _legendDot(AppColors.sleepDark, 'النوم'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildPatternCard(WeeklyAnalysis a) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.psychology, color: AppColors.alertWarm),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('النمط الأوضح', style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 4),
                  Text(a.strongestPattern ?? '', style: Theme.of(context).textTheme.bodyMedium),
                  if (a.bestExerciseName != null) ...[
                    SizedBox(height: 8),
                    Text('أفضل ما ساعدك: ${a.bestExerciseName}', style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsights(WeeklyAnalysis a) {
    final dominantCause = AppDependencies.moodRepo.getMostCommonCause();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('أكثر سبب للتوتر', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.help_outline, color: AppColors.comfort),
                SizedBox(width: 8),
                Text(dominantCause ?? 'غير محدد', style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextWeekSuggestion(WeeklyAnalysis a) {
    return Card(
      color: AppColors.comfort.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.auto_awesome, color: AppColors.comfort),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('اقتراح للأسبوع القادم', style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 4),
                  Text(a.nextWeekSuggestion ?? '', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
