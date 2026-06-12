import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/widgets/loading_view.dart';
import '../core/widgets/empty_state.dart';
import '../providers/database_provider.dart';
import '../models/glossary_term.dart';
import '../core/theme/theme.dart';

class GlossaryScreen extends StatefulWidget {
  const GlossaryScreen({super.key});

  @override
  State<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends State<GlossaryScreen> {
  List<GlossaryTerm> _terms = [];
  List<GlossaryTerm> _filteredTerms = [];
  bool _loading = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTerms();
    _searchController.addListener(_filterTerms);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTerms() async {
    final dbProvider = context.read<DatabaseProvider>();
    final terms = await dbProvider.getGlossaryTerms();
    setState(() {
      _terms = terms;
      _filteredTerms = terms;
      _loading = false;
    });
  }

  void _filterTerms() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() => _filteredTerms = _terms);
    } else {
      setState(() {
        _filteredTerms = _terms.where((t) =>
          t.termAr.contains(query) || t.termFr.toLowerCase().contains(query.toLowerCase())
        ).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المصطلحات الطبية'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'ابحث عن مصطلح...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const LoadingView()
                : _filteredTerms.isEmpty
                    ? const EmptyState(
                        icon: Icons.search_off,
                        message: 'لا توجد نتائج',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredTerms.length,
                        itemBuilder: (context, index) {
                          final term = _filteredTerms[index];
                          return _buildTermCard(term);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermCard(GlossaryTerm term) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
          child: Text(
            term.termAr[0],
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          term.termAr,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          term.termFr,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    term.definition,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Chip(
                  label: Text(term.category,
                      style: const TextStyle(fontSize: 14)),
                  backgroundColor: AppTheme.secondaryColor.withValues(alpha: 0.1),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
