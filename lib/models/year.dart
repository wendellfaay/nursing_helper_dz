class Year {
  final int? id;
  final String nameAr;
  final String nameFr;
  final int orderIndex;

  Year({this.id, required this.nameAr, required this.nameFr, required this.orderIndex});

  Map<String, dynamic> toMap() => {
        'id': id,
        'nameAr': nameAr,
        'nameFr': nameFr,
        'orderIndex': orderIndex,
      };

  factory Year.fromMap(Map<String, dynamic> map) => Year(
        id: map['id'],
        nameAr: map['nameAr'],
        nameFr: map['nameFr'],
        orderIndex: map['orderIndex'],
      );
}
