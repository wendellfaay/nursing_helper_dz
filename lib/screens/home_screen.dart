import 'package:flutter/material.dart';
import '../core/theme/theme.dart';
import '../core/database/database_helper.dart';
import 'years_screen.dart';
import 'lessons_list_screen.dart';
import 'glossary_screen.dart';
import 'quiz_screen.dart';
import 'progress_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _completedLessons = 0;
  int _totalLessons = 0;
  double _quizAverage = 0.0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final completed = await DatabaseHelper.getCompletedLessonsCount();
    final total = await DatabaseHelper.getTotalLessonsCount();
    final avg = await DatabaseHelper.getOverallQuizAverage();
    setState(() {
      _completedLessons = completed;
      _totalLessons = total;
      _quizAverage = avg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nursing Helper DZ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'مرحباً بك في',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Nursing Helper DZ',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppTheme.primaryColor,
                  ),
            ),
            Text(
              'تطبيق تعليمي شامل لطلبة التمريض في الجزائر',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context,
                    icon: Icons.school_rounded,
                    title: 'السنوات الدراسية',
                    subtitle: 'تصفح حسب السنة',
                    color: const Color(0xFF1565C0),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const YearsScreen()),
                    ),
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.menu_book_rounded,
                    title: 'جميع الدروس',
                    subtitle: 'دروس وملخصات',
                    color: const Color(0xFF2E7D32),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LessonsListScreen()),
                    ),
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.quiz_rounded,
                    title: 'الاختبارات',
                    subtitle: 'اختبر معلوماتك',
                    color: const Color(0xFFE65100),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QuizScreen()),
                    ),
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.translate_rounded,
                    title: 'المصطلحات',
                    subtitle: 'عربي - فرنسي',
                    color: const Color(0xFF6A1B9A),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GlossaryScreen()),
                    ),
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.trending_up_rounded,
                    title: 'التقدم',
                    subtitle: 'تتبع تقدمك',
                    color: const Color(0xFF00838F),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProgressScreen()),
                    ),
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.search_rounded,
                    title: 'البحث',
                    subtitle: 'ابحث في المحتوى',
                    color: const Color(0xFFAD1457),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SearchScreen()),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _statCard('الدروس المكتملة', '$_completedLessons / $_totalLessons', AppTheme.successColor),
                const SizedBox(width: 12),
                _statCard('معدل الاختبارات', '${_quizAverage.toStringAsFixed(1)}%', AppTheme.primaryColor),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Expanded(
      child: Card(
        color: color.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
