class GlossaryTerm {
  final int? id;
  final String termAr;
  final String termFr;
  final String definition;
  final String category;

  GlossaryTerm({
    this.id,
    required this.termAr,
    required this.termFr,
    required this.definition,
    required this.category,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'termAr': termAr,
        'termFr': termFr,
        'definition': definition,
        'category': category,
      };

  factory GlossaryTerm.fromMap(Map<String, dynamic> map) => GlossaryTerm(
        id: map['id'],
        termAr: map['termAr'],
        termFr: map['termFr'],
        definition: map['definition'],
        category: map['category'],
      );
}
