class UserProgress {
  final int? id;
  final String category;
  final int completedLessons;
  final int totalLessons;
  final double quizAverage;

  UserProgress({
    this.id,
    required this.category,
    required this.completedLessons,
    required this.totalLessons,
    this.quizAverage = 0.0,
  });

  double get percentage =>
      totalLessons > 0 ? (completedLessons / totalLessons) * 100 : 0.0;

  Map<String, dynamic> toMap() => {
        'id': id,
        'category': category,
        'completedLessons': completedLessons,
        'totalLessons': totalLessons,
        'quizAverage': quizAverage,
      };

  factory UserProgress.fromMap(Map<String, dynamic> map) => UserProgress(
        id: map['id'],
        category: map['category'],
        completedLessons: map['completedLessons'],
        totalLessons: map['totalLessons'],
        quizAverage: (map['quizAverage'] as num).toDouble(),
      );
}
