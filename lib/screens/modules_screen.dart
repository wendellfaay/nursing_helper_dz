import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/database_provider.dart';
import '../models/module.dart';
import '../models/lesson.dart';
import '../core/theme/theme.dart';
import 'lesson_detail_screen.dart';

class ModulesScreen extends StatefulWidget {
  final int semesterId;
  final String semesterName;

  const ModulesScreen({super.key, required this.semesterId, required this.semesterName});

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  List<Module> _modules = [];
  Map<int, List<Lesson>> _moduleLessons = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  Future<void> _loadModules() async {
    final dbProvider = context.read<DatabaseProvider>();
    final modules = await dbProvider.getModules(widget.semesterId);
    final Map<int, List<Lesson>> lessonsMap = {};
    for (final m in modules) {
      lessonsMap[m.id!] = await dbProvider.getLessonsByModule(m.id!);
    }
    setState(() {
      _modules = modules;
      _moduleLessons = lessonsMap;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.semesterName),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _modules.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text('لا توجد مواد في هذا السداسي', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _modules.length,
                  itemBuilder: (context, index) {
                    final module = _modules[index];
                    final lessons = _moduleLessons[module.id!] ?? [];
                    return _buildModuleCard(module, lessons);
                  },
                ),
    );
  }

  Widget _buildModuleCard(Module module, List<Lesson> lessons) {
    final completedCount = lessons.where((l) => l.isCompleted).length;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
          child: Text(
            '${lessons.length}',
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        title: Text(
          module.nameAr,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (module.description != null)
              Text(
                module.description!,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            if (lessons.isNotEmpty)
              Text(
                '$completedCount/${lessons.length} مكتمل',
                style: TextStyle(fontSize: 11, color: completedCount == lessons.length ? AppTheme.successColor : Colors.grey[500]),
              ),
          ],
        ),
        children: lessons.isEmpty
            ? [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('لا توجد دروس متاحة بعد', style: TextStyle(color: Colors.grey[500])),
                ),
              ]
            : lessons.map((lesson) {
                return ListTile(
                  leading: Icon(
                    lesson.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                    color: lesson.isCompleted ? AppTheme.successColor : Colors.grey[400],
                    size: 20,
                  ),
                  title: Text(lesson.title, style: const TextStyle(fontSize: 14)),
                  trailing: const Icon(Icons.chevron_left, size: 18),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LessonDetailScreen(lesson: lesson)),
                  ).then((_) => _loadModules()),
                );
              }).toList(),
      ),
    );
  }
}
