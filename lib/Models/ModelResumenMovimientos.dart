class ResumenMovimientosModel {
  final String cajaChica;
  final String responsable;
  final String moneda;
  final String areaFuncional;
  final int cantidadIngresos;
  final int cantidadEgresos;

  ResumenMovimientosModel({
    required this.cajaChica,
    required this.responsable,
    required this.moneda,
    required this.areaFuncional,
    required this.cantidadIngresos,
    required this.cantidadEgresos,
  });

  factory ResumenMovimientosModel.fromJson(Map<String, dynamic> json) {
    return ResumenMovimientosModel(
      cajaChica: json['cajaChica'] ?? '',
      responsable: json['responsable'] ?? '',
      moneda: json['moneda'] ?? '',
      areaFuncional: json['areaFuncional'] ?? '',
      cantidadIngresos: json['cantidadIngresos'] ?? 0,
      cantidadEgresos: json['cantidadEgresos'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cajaChica': cajaChica,
      'responsable': responsable,
      'moneda': moneda,
      'areaFuncional': areaFuncional,
      'cantidadIngresos': cantidadIngresos,
      'cantidadEgresos': cantidadEgresos,
    };
  }
}
