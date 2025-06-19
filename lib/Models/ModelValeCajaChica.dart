class ValeCajaChicaModel {
  final String cajaChica;
  final String cuentaBanco;
  final String tipoDocumento;
  final String usuarioCreacion;
  final String numero;
  final DateTime fecha;
  final double monto;

  ValeCajaChicaModel({
    required this.cajaChica,
    required this.cuentaBanco,
    required this.tipoDocumento,
    required this.usuarioCreacion,
    required this.numero,
    required this.fecha,
    required this.monto,
  });

  factory ValeCajaChicaModel.fromJson(Map<String, dynamic> json) {
    return ValeCajaChicaModel(
      cajaChica: json['cajaChica'] ?? '',
      cuentaBanco: json['cuentaBanco'] ?? '',
      tipoDocumento: json['tipoDocumento'] ?? '',
      usuarioCreacion: json['usuarioCreacion'] ?? '',
      numero: json['numero'] ?? '',
      fecha: DateTime.tryParse(json['fecha'] ?? '') ?? DateTime(2000),
      monto: (json['monto'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cajaChica': cajaChica,
      'cuentaBanco': cuentaBanco,
      'tipoDocumento': tipoDocumento,
      'usuarioCreacion': usuarioCreacion,
      'numero': numero,
      'fecha': fecha.toIso8601String(),
      'monto': monto,
    };
  }
}
