import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = AppDependencies.hiveService.getProfile();
    final isPremium = AppDependencies.subscriptionService.isPremium;

    return Scaffold(
      appBar: AppBar(title: Text('أنا')),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.comfort,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                SizedBox(height: 8),
                Text('مستخدم ResetMe', style: Theme.of(context).textTheme.titleLarge),
                if (isPremium)
                  Chip(
                    avatar: Icon(Icons.auto_awesome, size: 14),
                    label: Text('Premium', style: TextStyle(fontSize: 12)),
                    backgroundColor: AppColors.alertWarm.withOpacity(0.2),
                  ),
              ],
            ),
          ),
          SizedBox(height: 32),
          if (!isPremium) ...[
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.auto_awesome, size: 48, color: AppColors.alertWarm),
                    SizedBox(height: 8),
                    Text('ResetMe Premium', style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: 4),
                    Text('خطط شخصية + تحليلات متقدمة + مكتبة كاملة', textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.push('/premium'),
                      child: Text('جرِّب Premium'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
          _settingTile(Icons.track_changes, 'أهدافي', subtitle: profile?.primaryGoal ?? 'غير محدد'),
          _settingTile(Icons.access_time, 'الالتزام اليومي', subtitle: '${profile?.dailyCommitmentMinutes ?? 5} دقائق'),
          _settingTile(Icons.nightlight_round, 'وقت النوم', subtitle: profile?.bedtime ?? 'غير محدد'),
          _settingTile(Icons.psychology, 'سبب التوتر', subtitle: profile?.topStressCause ?? 'غير محدد'),
          _divider(),
          _settingTile(Icons.notifications_outlined, 'الإشعارات', onTap: () {}),
          SwitchListTile(
            title: Text('الوضع الليلي'),
            secondary: Icon(Icons.dark_mode, color: AppColors.sleepDark),
            value: profile?.darkMode ?? false,
            onChanged: (v) {
              final p = profile ?? AppDependencies.hiveService.getProfile();
              if (p == null) return;
              final updated = p.copyWith(darkMode: v);
              AppDependencies.hiveService.saveProfile(updated);
            },
            activeColor: AppColors.sleepDark,
          ),
          _settingTile(Icons.language, 'اللغة', subtitle: 'العربية'),
          _divider(),
          _settingTile(Icons.info_outline, 'حول التطبيق', subtitle: 'الإصدار 1.0.0'),
          _settingTile(Icons.privacy_tip_outlined, 'سياسة الخصوصية'),
          _settingTile(Icons.description_outlined, 'شروط الاستخدام'),
          _divider(),
          Card(
            child: ListTile(
              leading: Icon(Icons.logout, color: AppColors.error),
              title: Text('تسجيل الخروج', style: TextStyle(color: AppColors.error)),
              onTap: () {
                AppDependencies.hiveService.clearAll();
                context.go('/onboarding');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingTile(IconData icon, String title, {String? subtitle, VoidCallback? onTap}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppColors.comfort),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: Icon(Icons.arrow_forward_ios, size: 14),
        onTap: onTap,
      ),
    );
  }

  Widget _divider() => Padding(
    padding: EdgeInsets.symmetric(vertical: 4),
    child: Divider(height: 1, color: AppColors.textSecondary.withOpacity(0.2)),
  );
}
