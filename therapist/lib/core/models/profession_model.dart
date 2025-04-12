class ProfessionModel {
  final int id;
  final String name;

  ProfessionModel({
    required this.id,
    required this.name,
  });

  factory ProfessionModel.fromMap(Map<String, dynamic> map) {
    return ProfessionModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
    );
  }
}

class RegulatoryBodyModel {
  final int id;
  final int professionId;
  final String name;

  RegulatoryBodyModel({
    required this.id,
    required this.professionId,
    required this.name,
  });

  factory RegulatoryBodyModel.fromMap(Map<String, dynamic> map) {
    return RegulatoryBodyModel(
      id: map['id'] ?? 0,
      professionId: map['profession_id'] ?? 0,
      name: map['name'] ?? '',
    );
  }
}

class SpecializationModel {
  final int id;
  final int professionId;
  final String name;

  SpecializationModel({
    required this.id,
    required this.professionId,
    required this.name,
  });

  factory SpecializationModel.fromMap(Map<String, dynamic> map) {
    return SpecializationModel(
      id: map['id'] ?? 0,
      professionId: map['profession_id'] ?? 0,
      name: map['name'] ?? '',
    );
  }
}

class TherapyModel {
  final int id;
  final int professionId;
  final String name;

  TherapyModel({
    required this.id,
    required this.professionId,
    required this.name,
  });

  factory TherapyModel.fromMap(Map<String, dynamic> map) {
    return TherapyModel(
      id: map['id'] ?? 0,
      professionId: map['profession_id'] ?? 0,
      name: map['name'] ?? '',
    );
  }
}