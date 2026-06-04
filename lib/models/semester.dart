class Semester {
  final int? id;
  final int yearId;
  final String name;
  final String nameAr;
  final int orderIndex;

  Semester({this.id, required this.yearId, required this.name, required this.nameAr, required this.orderIndex});

  Map<String, dynamic> toMap() => {
        'id': id,
        'yearId': yearId,
        'name': name,
        'nameAr': nameAr,
        'orderIndex': orderIndex,
      };

  factory Semester.fromMap(Map<String, dynamic> map) => Semester(
        id: map['id'],
        yearId: map['yearId'],
        name: map['name'],
        nameAr: map['nameAr'],
        orderIndex: map['orderIndex'],
      );
}
