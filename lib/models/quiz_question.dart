class QuizQuestion {
  final int? id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String topic;
  final String explanation;

  QuizQuestion({
    this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.topic,
    required this.explanation,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'question': question,
        'options': options.join('||'),
        'correctIndex': correctIndex,
        'topic': topic,
        'explanation': explanation,
      };

  factory QuizQuestion.fromMap(Map<String, dynamic> map) => QuizQuestion(
        id: map['id'],
        question: map['question'],
        options: (map['options'] as String).split('||'),
        correctIndex: map['correctIndex'],
        topic: map['topic'],
        explanation: map['explanation'],
      );
}
