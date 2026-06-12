import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/constants.dart';
import '../core/widgets/loading_view.dart';
import '../core/widgets/empty_state.dart';
import '../core/widgets/lesson_card.dart';
import '../core/theme/theme.dart';
import '../providers/database_provider.dart';
import '../models/lesson.dart';
import 'lesson_detail_screen.dart';

class LessonsListScreen extends StatefulWidget {
  const LessonsListScreen({super.key});

  @override
  State<LessonsListScreen> createState() => _LessonsListScreenState();
}

class _LessonsListScreenState extends State<LessonsListScreen> {
  String? _selectedCategory;
  List<Lesson> _lessons = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    setState(() => _loading = true);
    final dbProvider = context.read<DatabaseProvider>();
    final lessons = await dbProvider.getLessons(category: _selectedCategory);
    setState(() {
      _lessons = lessons;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الدروس'),
        actions: [
          if (_selectedCategory != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() => _selectedCategory = null);
                _loadLessons();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: AppConstants.lessonCategories.length +
                  (_selectedCategory != null ? 0 : 0),
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = AppConstants.lessonCategories[index];
                final isSelected = _selectedCategory == category;
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                  checkmarkColor: AppTheme.primaryColor,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = selected ? category : null;
                    });
                    _loadLessons();
                  },
                );
              },
            ),
          ),
          Expanded(
            child: _loading
                ? const LoadingView()
                : _lessons.isEmpty
                    ? const EmptyState(
                        icon: Icons.menu_book_outlined,
                        message: 'لا توجد دروس في هذا القسم',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _lessons.length,
                        itemBuilder: (context, index) {
                          final lesson = _lessons[index];
                          return LessonCard(
                            lesson: lesson,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LessonDetailScreen(lesson: lesson),
                              ),
                            ).then((_) => _loadLessons()),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
