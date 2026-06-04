class Lesson {
  final int? id;
  final int moduleId;
  final String title;
  final String category;
  final String academicYear;
  final String content;
  final String summary;
  final String keyPoints;
  final bool isCompleted;

  Lesson({
    this.id,
    required this.moduleId,
    required this.title,
    required this.category,
    required this.academicYear,
    required this.content,
    required this.summary,
    required this.keyPoints,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'moduleId': moduleId,
        'title': title,
        'category': category,
        'academicYear': academicYear,
        'content': content,
        'summary': summary,
        'keyPoints': keyPoints,
        'isCompleted': isCompleted ? 1 : 0,
      };

  factory Lesson.fromMap(Map<String, dynamic> map) => Lesson(
        id: map['id'],
        moduleId: map['moduleId'],
        title: map['title'],
        category: map['category'],
        academicYear: map['academicYear'],
        content: map['content'],
        summary: map['summary'],
        keyPoints: map['keyPoints'],
        isCompleted: map['isCompleted'] == 1,
      );
}
