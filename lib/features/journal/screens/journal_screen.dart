import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../main.dart';
import '../../../data/models/journal_entry.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final _controller = TextEditingController();
  JournalType _type = JournalType.venting;
  bool _showInput = false;

  void _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final entry = JournalEntry(
      id: '',
      dateTime: DateTime.now(),
      type: _type,
      content: text,
    );
    await AppDependencies.journalRepo.saveEntry(entry);
    _controller.clear();
    setState(() => _showInput = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entries = AppDependencies.journalRepo.getEntries();
    final isPremium = AppDependencies.subscriptionService.isPremium;

    return Scaffold(
      appBar: AppBar(
        title: Text('اليوميات'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => setState(() => _showInput = !_showInput),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          if (_showInput) ...[
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ChoiceChip(
                          label: Text('تفريغ'),
                          selected: _type == JournalType.venting,
                          onSelected: (s) => setState(() => _type = JournalType.venting),
                          selectedColor: AppColors.comfort.withOpacity(0.3),
                        ),
                        SizedBox(width: 8),
                        ChoiceChip(
                          label: Text('امتنان'),
                          selected: _type == JournalType.gratitude,
                          onSelected: (s) {
                            if (isPremium || !s) {
                              setState(() => _type = JournalType.gratitude);
                            } else {
                              context.push('/premium');
                            }
                          },
                          selectedColor: AppColors.alertWarm.withOpacity(0.3),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _controller,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: _type == JournalType.venting
                          ? 'اكتب ما في بالك...'
                          : 'ما الشيء الذي أنت ممتن له اليوم؟',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: AppColors.background,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => setState(() => _showInput = false),
                          child: Text('إلغاء'),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _save,
                          child: Text('حفظ'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (entries.isEmpty && !_showInput)
            Center(
              child: Padding(
                padding: EdgeInsets.all(48),
                child: Column(
                  children: [
                    Icon(Icons.edit_note, size: 64, color: AppColors.textSecondary),
                    SizedBox(height: 16),
                    Text('لا توجد يوميات بعد', style: Theme.of(context).textTheme.bodyMedium),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => setState(() => _showInput = true),
                      child: Text('اكتب أول يومية'),
                    ),
                  ],
                ),
              ),
            ),
          ...entries.map((entry) => Card(
            child: ListTile(
              leading: Icon(
                entry.type == JournalType.venting ? Icons.psychology : Icons.favorite,
                color: entry.type == JournalType.venting ? AppColors.alertWarm : AppColors.success,
              ),
              title: Text(
                entry.content.length > 60 ? '${entry.content.substring(0, 60)}...' : entry.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(_formatDate(entry.dateTime)),
              isThreeLine: true,
            ),
          )),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}/${dt.month}/${dt.day} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
