import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../core/database/database_helper.dart';
import '../core/theme/theme.dart';

class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;
  const LessonDetailScreen({super.key, required this.lesson});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  late Lesson _lesson;
  bool _showSummary = false;

  @override
  void initState() {
    super.initState();
    _lesson = widget.lesson;
  }

  Future<void> _markCompleted() async {
    await DatabaseHelper.markLessonCompleted(_lesson.id!);
    await DatabaseHelper.updateUserProgress(
      _lesson.category,
      await DatabaseHelper.getCompletedLessonsCount(),
      await DatabaseHelper.getTotalLessonsCount(),
    );
    setState(() => _lesson = Lesson(
      id: _lesson.id,
      moduleId: _lesson.moduleId,
      title: _lesson.title,
      category: _lesson.category,
      academicYear: _lesson.academicYear,
      content: _lesson.content,
      summary: _lesson.summary,
      keyPoints: _lesson.keyPoints,
      isCompleted: true,
    ));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إكمال الدرس ✓'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_lesson.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Chip(
                  label: Text(_lesson.category,
                      style: const TextStyle(fontSize: 12)),
                  backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(_lesson.academicYear,
                      style: const TextStyle(fontSize: 12)),
                  backgroundColor: AppTheme.secondaryColor.withValues(alpha: 0.1),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _lesson.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              _lesson.content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.warningColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.warningColor.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb_outline,
                          color: AppTheme.warningColor),
                      SizedBox(width: 8),
                      Text(
                        'نقاط مهمة',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.warningColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _lesson.keyPoints,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AnimatedCrossFade(
              firstChild: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.successColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.summarize_outlined,
                            color: AppTheme.successColor),
                        SizedBox(width: 8),
                        Text(
                          'ملخص الدرس',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.successColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _lesson.summary,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              secondChild: const SizedBox.shrink(),
              crossFadeState: _showSummary
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
            ),
            const SizedBox(height: 24),
            if (!_showSummary)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => _showSummary = true),
                  icon: const Icon(Icons.summarize_outlined),
                  label: const Text('عرض الملخص'),
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _lesson.isCompleted ? null : _markCompleted,
                icon: Icon(
                  _lesson.isCompleted ? Icons.check_circle : Icons.check,
                ),
                label: Text(
                  _lesson.isCompleted ? 'تم الإكمال ✓' : 'تحديد كمكتمل',
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
