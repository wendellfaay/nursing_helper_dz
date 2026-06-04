import 'package:flutter/material.dart';
import '../core/database/database_helper.dart';
import '../models/lesson.dart';
import '../models/glossary_term.dart';
import '../core/theme/theme.dart';
import 'lesson_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<Lesson> _lessonResults = [];
  List<GlossaryTerm> _termResults = [];
  bool _loading = false;
  bool _searched = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;
    setState(() => _loading = true);
    final lessons = await DatabaseHelper.searchLessons(query.trim());
    final terms = await DatabaseHelper.searchGlossary(query.trim());
    setState(() {
      _lessonResults = lessons;
      _termResults = terms;
      _loading = false;
      _searched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              textAlign: TextAlign.right,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onSubmitted: _search,
              decoration: InputDecoration(
                hintText: 'ابحث في الدروس والمصطلحات...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _lessonResults = [];
                            _termResults = [];
                            _searched = false;
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) {
                if (v.isEmpty) {
                  setState(() {
                    _lessonResults = [];
                    _termResults = [];
                    _searched = false;
                  });
                }
              },
            ),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          if (!_loading && _searched && _lessonResults.isEmpty && _termResults.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text('لا توجد نتائج للبحث', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
            ),
          if (_lessonResults.isNotEmpty)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'الدروس (${_lessonResults.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  ..._lessonResults.map((lesson) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.menu_book, color: AppTheme.primaryColor),
                          title: Text(lesson.title, style: const TextStyle(fontSize: 14)),
                          subtitle: Text(lesson.category, style: const TextStyle(fontSize: 12)),
                          trailing: const Icon(Icons.chevron_left, size: 18),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => LessonDetailScreen(lesson: lesson)),
                          ),
                        ),
                      )),
                  if (_termResults.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        'المصطلحات (${_termResults.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.successColor,
                        ),
                      ),
                    ),
                  ..._termResults.map((term) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                          title: Text(term.termAr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          subtitle: Text(term.termFr, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic)),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Text(term.definition, style: const TextStyle(fontSize: 13, height: 1.5)),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 24),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
