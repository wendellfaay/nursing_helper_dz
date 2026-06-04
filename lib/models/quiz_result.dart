class QuizResult {
  final int? id;
  final String topic;
  final int totalQuestions;
  final int correctAnswers;
  final double percentage;
  final String date;

  QuizResult({
    this.id,
    required this.topic,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.percentage,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'topic': topic,
        'totalQuestions': totalQuestions,
        'correctAnswers': correctAnswers,
        'percentage': percentage,
        'date': date,
      };

  factory QuizResult.fromMap(Map<String, dynamic> map) => QuizResult(
        id: map['id'],
        topic: map['topic'],
        totalQuestions: map['totalQuestions'],
        correctAnswers: map['correctAnswers'],
        percentage: (map['percentage'] as num).toDouble(),
        date: map['date'],
      );
}
