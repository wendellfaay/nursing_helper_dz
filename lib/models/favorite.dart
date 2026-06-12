class Favorite {
  final int id;
  final int contentId;
  final String contentType;
  final String contentTitle;
  final DateTime dateAdded;

  Favorite({
    required this.id,
    required this.contentId,
    required this.contentType,
    required this.contentTitle,
    required this.dateAdded,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'contentId': contentId,
    'contentType': contentType,
    'contentTitle': contentTitle,
    'dateAdded': dateAdded.toIso8601String(),
  };

  factory Favorite.fromMap(Map<String, dynamic> map) => Favorite(
    id: map['id'] as int,
    contentId: map['contentId'] as int,
    contentType: map['contentType'] as String,
    contentTitle: map['contentTitle'] as String,
    dateAdded: DateTime.parse(map['dateAdded'] as String),
  );
}
