class ReporteRequestModel {
  final String rol;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String usuario;

  ReporteRequestModel({
    required this.rol,
    required this.fechaInicio,
    required this.fechaFin,
    required this.usuario,
  });

  factory ReporteRequestModel.fromJson(Map<String, dynamic> json) {
    return ReporteRequestModel(
      rol: json['rol'] ?? '',
      fechaInicio: DateTime.tryParse(json['fechaInicio'] ?? '') ?? DateTime(2000),
      fechaFin: DateTime.tryParse(json['fechaFin'] ?? '') ?? DateTime(2000),
      usuario: json['usuario'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rol': rol,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin.toIso8601String(),
      'usuario': usuario,
    };
  }
}
