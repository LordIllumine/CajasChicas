class ReporteMovimientoModel {
  final String cajaChica;
  final String responsable;
  final String tipoMovimiento;
  final String fechaMovimiento;
  final double monto;
  final String referencia;

  ReporteMovimientoModel({
    required this.cajaChica,
    required this.responsable,
    required this.tipoMovimiento,
    required this.fechaMovimiento,
    required this.monto,
    required this.referencia,
  });

  factory ReporteMovimientoModel.fromJson(Map<String, dynamic> json) {
    return ReporteMovimientoModel(
      cajaChica: json['cajaChica'] ?? '',
      responsable: json['responsable'] ?? '',
      tipoMovimiento: json['tipo_Movimiento'] ?? '',
      fechaMovimiento: json['fechaMovimiento'] ?? '',
      monto: (json['monto'] ?? 0).toDouble(),
      referencia: json['referencia'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cajaChica': cajaChica,
      'responsable': responsable,
      'tipo_Movimiento': tipoMovimiento,
      'fechaMovimiento': fechaMovimiento,
      'monto': monto,
      'referencia': referencia,
    };
  }
}

//REPORTE
class ReporteResponse {
  final List<CantidadMovimientos> cantidadMovimientos;
  final List<Reporteria> reporteria;

  ReporteResponse({
    required this.cantidadMovimientos,
    required this.reporteria,
  });

  factory ReporteResponse.fromJson(Map<String, dynamic> json) {
  final listReporte = json['listReporte'] as List?;
  if (listReporte == null || listReporte.isEmpty) {
    return ReporteResponse(cantidadMovimientos: [], reporteria: []);
  }

  final reporteData = listReporte.first;

  return ReporteResponse(
    cantidadMovimientos: (reporteData['cantidadMovimientos'] as List? ?? [])
        .map((item) => CantidadMovimientos.fromJson(item))
        .toList(),
    reporteria: (reporteData['reporteria'] as List? ?? [])
        .map((item) => Reporteria.fromJson(item))
        .toList(),
  );
}
}

class CantidadMovimientos {
  final String cajaChica;
  final String responsable;
  final String moneda;
  final String areaFuncional;
  final int cantidadIngresos;
  final int cantidadEgresos;

  CantidadMovimientos({
    required this.cajaChica,
    required this.responsable,
    required this.moneda,
    required this.areaFuncional,
    required this.cantidadIngresos,
    required this.cantidadEgresos,
  });

  factory CantidadMovimientos.fromJson(Map<String, dynamic> json) {
    return CantidadMovimientos(
      cajaChica: json['cajaChica'],
      responsable: json['responsable'],
      moneda: json['moneda'],
      areaFuncional: json['areaFuncional'],
      cantidadIngresos: json['cantidadIngresos'],
      cantidadEgresos: json['cantidadEgresos'],
    );
  }
}

class Reporteria {
  final String cajaChica;
  final String responsable;
  final String tipoMovimiento;
  final String concepto;
  final String usuarioCreacion;
  final String fechaMovimiento;
  final double monto;
  final String referencia;

  Reporteria({
    required this.cajaChica,
    required this.responsable,
    required this.tipoMovimiento,
    required this.concepto,
    required this.usuarioCreacion,
    required this.fechaMovimiento,
    required this.monto,
    required this.referencia,
  });

  factory Reporteria.fromJson(Map<String, dynamic> json) {
  return Reporteria(
    cajaChica: json['cajaChica'] ?? '',
    responsable: json['responsable'] ?? '',
    usuarioCreacion: json['usuarioCreacion'] ?? '',
    tipoMovimiento: json['tipo_Movimiento'] ?? '',
    concepto: json['concepto'] ?? '',   
    fechaMovimiento: json['fechaMovimiento'] ?? '',
    monto: (json['monto'] is int)
        ? (json['monto'] as int).toDouble()
        : (json['monto'] is double)
            ? json['monto']
            : 0.0, // Valor por defecto si viene nulo o con tipo incorrecto
    referencia: json['referencia'] ?? '',
  );
}
}