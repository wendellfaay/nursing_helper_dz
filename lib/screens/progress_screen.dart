import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/widgets/loading_view.dart';
import '../core/widgets/empty_state.dart';
import '../providers/database_provider.dart';
import '../models/user_progress.dart';
import '../models/quiz_result.dart';
import '../core/theme/theme.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<UserProgress> _progress = [];
  List<QuizResult> _quizResults = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final dbProvider = context.read<DatabaseProvider>();
    final progress = await dbProvider.getUserProgress();
    final results = await dbProvider.getQuizResults();
    setState(() {
      _progress = progress;
      _quizResults = results;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التقدم الدراسي'),
      ),
      body: _loading
          ? const LoadingView()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'مستواك العام',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  _buildOverallCard(),
                  const SizedBox(height: 24),
                  Text(
                    'تقدم الدروس',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  ..._progress.map((p) => _buildProgressCard(p)),
                  const SizedBox(height: 24),
                  Text(
                    'نتائج الاختبارات',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  if (_quizResults.isEmpty)
                    const EmptyState(
                      icon: Icons.quiz_outlined,
                      message: 'لم تخضع لأي اختبار بعد',
                    )
                  else
                    ..._quizResults.take(10).map((r) => _buildResultCard(r)),
                ],
              ),
            ),
    );
  }

  Widget _buildOverallCard() {
    final totalCompleted = _progress.fold<int>(0, (sum, p) => sum + p.completedLessons);
    final total = _progress.fold<int>(0, (sum, p) => sum + p.totalLessons);
    final avg = _quizResults.isEmpty
        ? 0.0
        : _quizResults.fold<double>(0.0, (sum, r) => sum + r.percentage) /
            _quizResults.length;

    final level = avg >= 80
        ? 'متقدم'
        : avg >= 50
            ? 'متوسط'
            : 'مبتدئ';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'المستوى',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    level,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Column(
              children: [
                Text('الدروس', style: TextStyle(color: Colors.grey[600])),
                Text(
                  '$totalCompleted/$total',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Column(
              children: [
                Text('الاختبارات', style: TextStyle(color: Colors.grey[600])),
                Text(
                  '${avg.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.successColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(UserProgress p) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Text(
                  '${p.completedLessons}/${p.totalLessons}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Text(
                  p.category,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: p.totalLessons > 0
                    ? p.completedLessons / p.totalLessons
                    : 0,
                minHeight: 8,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  p.percentage >= 50
                      ? AppTheme.successColor
                      : AppTheme.warningColor,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${p.percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(QuizResult r) {
    final date = r.date.substring(0, 10);
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: r.percentage >= 60
              ? AppTheme.successColor.withValues(alpha: 0.15)
              : AppTheme.errorColor.withValues(alpha: 0.15),
          child: Icon(
            r.percentage >= 60 ? Icons.check_circle : Icons.cancel,
            color: r.percentage >= 60
                ? AppTheme.successColor
                : AppTheme.errorColor,
            size: 20,
          ),
        ),
        title: Text(r.topic),
        subtitle: Text(date, style: const TextStyle(fontSize: 15)),
        trailing: Text(
          '${r.percentage.toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: r.percentage >= 60
                ? AppTheme.successColor
                : AppTheme.errorColor,
          ),
        ),
      ),
    );
  }
}
