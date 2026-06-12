class Achievement {
  final int id;
  final String title;
  final String description;
  final String icon;
  final int requiredProgress;
  final bool unlocked;
  final DateTime? unlockedDate;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.requiredProgress,
    required this.unlocked,
    this.unlockedDate,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'icon': icon,
    'requiredProgress': requiredProgress,
    'unlocked': unlocked ? 1 : 0,
    'unlockedDate': unlockedDate?.toIso8601String(),
  };

  factory Achievement.fromMap(Map<String, dynamic> map) => Achievement(
    id: map['id'] as int,
    title: map['title'] as String,
    description: map['description'] as String,
    icon: map['icon'] as String,
    requiredProgress: map['requiredProgress'] as int,
    unlocked: (map['unlocked'] as int) == 1,
    unlockedDate: map['unlockedDate'] != null
        ? DateTime.parse(map['unlockedDate'] as String)
        : null,
  );

  static List<Achievement> getDefaultAchievements() => [
    Achievement(
      id: 1,
      title: 'البداية',
      description: 'أكمل درسًا واحدًا',
      icon: '🎓',
      requiredProgress: 1,
      unlocked: false,
    ),
    Achievement(
      id: 2,
      title: 'المجتهد',
      description: 'أكمل 10 دروس',
      icon: '📚',
      requiredProgress: 10,
      unlocked: false,
    ),
    Achievement(
      id: 3,
      title: 'الخبير',
      description: 'أكمل 50 درس',
      icon: '🏆',
      requiredProgress: 50,
      unlocked: false,
    ),
    Achievement(
      id: 4,
      title: 'المعلم',
      description: 'احصل على نسبة نجاح 90% في الاختبارات',
      icon: '⭐',
      requiredProgress: 90,
      unlocked: false,
    ),
    Achievement(
      id: 5,
      title: 'الملتزم',
      description: 'استخدم التطبيق 7 أيام متتالية',
      icon: '🔥',
      requiredProgress: 7,
      unlocked: false,
    ),
  ];
}
