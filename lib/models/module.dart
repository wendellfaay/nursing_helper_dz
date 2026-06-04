class Module {
  final int? id;
  final int semesterId;
  final String name;
  final String nameAr;
  final String? description;

  Module({this.id, required this.semesterId, required this.name, required this.nameAr, this.description});

  Map<String, dynamic> toMap() => {
        'id': id,
        'semesterId': semesterId,
        'name': name,
        'nameAr': nameAr,
        'description': description,
      };

  factory Module.fromMap(Map<String, dynamic> map) => Module(
        id: map['id'],
        semesterId: map['semesterId'],
        name: map['name'],
        nameAr: map['nameAr'],
        description: map['description'],
      );
}
