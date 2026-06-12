import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/theme.dart';
import '../providers/database_provider.dart';
import '../models/favorite.dart';
import 'lesson_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Favorite>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    _favoritesFuture = context.read<DatabaseProvider>().getFavorites();
  }

  Future<void> _openLessonDetail(int lessonId) async {
    final lesson = await context.read<DatabaseProvider>().getLesson(lessonId);
    if (!mounted || lesson == null) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonDetailScreen(lesson: lesson),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المفضلة'),
      ),
      body: FutureBuilder<List<Favorite>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('حدث خطأ في تحميل المفضلة'));
          }

          final favorites = snapshot.data ?? [];

          if (favorites.isEmpty) {
            return const Center(
              child: Text('لا توجد عناصر مفضلة بعد'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.favorite, color: AppTheme.errorColor),
                  title: Text(favorite.contentTitle),
                  subtitle: Text(favorite.contentType),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () async {
                      await context.read<DatabaseProvider>().removeFavorite(
                        favorite.contentId,
                        favorite.contentType,
                      );
                      setState(() => _loadFavorites());
                    },
                  ),
                  onTap: () async {
                    if (favorite.contentType == 'lesson') {
                      await _openLessonDetail(favorite.contentId);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
