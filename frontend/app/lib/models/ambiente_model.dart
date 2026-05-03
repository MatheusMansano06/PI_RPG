class AmbienteModel {
  const AmbienteModel({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.ordem,
    required this.x,
    required this.y,
    required this.xpNecessario,
    this.latitude,
    this.longitude,
    this.raioMetros,
  });

  final int id;
  final String nome;
  final String descricao;
  final int ordem;
  final double x;
  final double y;
  final int xpNecessario;
  final double? latitude;
  final double? longitude;
  final double? raioMetros;

  factory AmbienteModel.fromJson(Map<String, dynamic> json) {
    return AmbienteModel(
      id: _asInt(json['id']),
      nome: _asString(json['nome']),
      descricao: _asString(json['descricao']),
      ordem: _asInt(json['ordem']),
      x: _asDouble(json['x']),
      y: _asDouble(json['y']),
      xpNecessario: _asInt(json['xpNecessario']),
      latitude: _asNullableDouble(json['latitude']),
      longitude: _asNullableDouble(json['longitude']),
      raioMetros: _asNullableDouble(json['raioMetros']),
    );
  }

  static String _asString(dynamic value) => value?.toString() ?? '';

  static int _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _asDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double? _asNullableDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }
}
