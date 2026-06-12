import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/theme.dart';
import '../core/widgets/menu_card.dart';
import '../core/widgets/stat_card.dart';
import '../providers/app_provider.dart';
import '../providers/database_provider.dart';
import 'years_screen.dart';
import 'lessons_list_screen.dart';
import 'glossary_screen.dart';
import 'quiz_screen.dart';
import 'progress_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final dbProvider = context.watch<DatabaseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الرائد للصحة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          IconButton(
            icon: Icon(appProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: appProvider.toggleTheme,
          ),
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
              'الرائد للصحة',
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
                  MenuCard(
                    icon: Icons.school_rounded,
                    title: 'السنوات الدراسية',
                    subtitle: 'تصفح حسب السنة',
                    color: const Color(0xFF1565C0),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const YearsScreen()),
                    ),
                  ),
                  MenuCard(
                    icon: Icons.menu_book_rounded,
                    title: 'جميع الدروس',
                    subtitle: 'دروس وملخصات',
                    color: const Color(0xFF2E7D32),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LessonsListScreen()),
                    ),
                  ),
                  MenuCard(
                    icon: Icons.quiz_rounded,
                    title: 'الاختبارات',
                    subtitle: 'اختبر معلوماتك',
                    color: const Color(0xFFE65100),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QuizScreen()),
                    ),
                  ),
                  MenuCard(
                    icon: Icons.translate_rounded,
                    title: 'المصطلحات',
                    subtitle: 'عربي - فرنسي',
                    color: const Color(0xFF6A1B9A),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GlossaryScreen()),
                    ),
                  ),
                  MenuCard(
                    icon: Icons.trending_up_rounded,
                    title: 'التقدم',
                    subtitle: 'تتبع تقدمك',
                    color: const Color(0xFF00838F),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProgressScreen()),
                    ),
                  ),
                  MenuCard(
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
                StatCard(
                  label: 'الدروس المكتملة',
                  value: '${dbProvider.completedLessons} / ${dbProvider.totalLessons}',
                  color: AppTheme.successColor,
                  icon: Icons.check_circle,
                ),
                const SizedBox(width: 12),
                StatCard(
                  label: 'معدل الاختبارات',
                  value: '${dbProvider.quizAverage.toStringAsFixed(1)}%',
                  color: AppTheme.primaryColor,
                  icon: Icons.quiz,
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

}
