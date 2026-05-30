import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../main.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ResetMe Premium')),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.alertWarm.withOpacity(0.2),
                  ),
                  child: Icon(Icons.auto_awesome, size: 40, color: AppColors.alertWarm),
                ),
                SizedBox(height: 16),
                Text('افتح كل الميزات', style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: 8),
                Text(
                  'خطط شخصية، تحليلات متقدمة، مكتبة كاملة',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          _planCard(
            context,
            'شهري',
            '\$4.99',
            '/الشهر',
            [
              'تتبع مزاج غير محدود',
              'تمارين تنفس كاملة',
              'روتين نوم ذكي',
              'تحليل أسبوعي متقدم',
              'AI مساعد شخصي',
              'يوميات تفريغ وامتنان',
              '5+ أصوات محيطية',
              '12 جلسة تأمل',
              'خطط شخصية حسب حالتك',
            ],
            false,
          ),
          SizedBox(height: 16),
          _planCard(
            context,
            'سنوي',
            '\$29.99',
            '/السنة',
            [
              'كل مزايا الشهري',
              'توفير 50%',
              'إحصائيات متقدمة',
              'توصيات AI ذكية',
              'دعم فني優先',
            ],
            true,
          ),
          SizedBox(height: 16),
          _planCard(
            context,
            'عائلي',
            '\$8.99',
            '/الشهر',
            [
              'كل مزايا السنوي',
              'حتى 5 مستخدمين',
              'لوحة تحكم عائلية',
              'تشجيع متبادل',
            ],
            false,
          ),
          SizedBox(height: 32),
          Text(
            'يبدو أن التوتر كان مرتفعًا هذا الأسبوع. قد يساعدك روتين قصير قبل النوم. وإذا كان الأمر يؤثر بشدة على حياتك، ففكر بالتواصل مع مختص.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => context.pop(),
            child: Text('مواصلة مع النسخة المجانية'),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _planCard(
    BuildContext context,
    String name,
    String price,
    String period,
    List<String> features,
    bool recommended,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: recommended ? BorderSide(color: AppColors.alertWarm, width: 2) : BorderSide.none,
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recommended)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.alertWarm,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('الأفضل', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            SizedBox(height: 8),
            Text(name, style: Theme.of(context).textTheme.titleLarge),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(price, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.comfort)),
                Text(period, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            SizedBox(height: 16),
            ...features.map((f) => Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 18, color: AppColors.comfort),
                  SizedBox(width: 8),
                  Text(f, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            )),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  AppDependencies.subscriptionService.setPremium(true);
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: recommended ? AppColors.alertWarm : AppColors.comfort,
                ),
                child: Text(recommended ? 'ابدأ الخطة السنوية' : 'اختر $name'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
