import 'package:cajas_chicas/Models/ModelReporteMovimientos.dart';
import 'package:cajas_chicas/Models/ModelResumenMovimientos.dart';


class ReporteApiResponseModel {
  final List<ResumenMovimientosModel> cantidadMovimientos;
  final List<ReporteMovimientoModel> reporteria;

  ReporteApiResponseModel({
    required this.cantidadMovimientos,
    required this.reporteria,
  });

  factory ReporteApiResponseModel.fromJson(Map<String, dynamic> json) {
    return ReporteApiResponseModel(
      cantidadMovimientos: (json['cantidadMovimientos'] as List<dynamic>?)
              ?.map((e) => ResumenMovimientosModel.fromJson(e))
              .toList() ??
          [],
      reporteria: (json['reporteria'] as List<dynamic>?)
              ?.map((e) => ReporteMovimientoModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cantidadMovimientos':
          cantidadMovimientos.map((e) => e.toJson()).toList(),
      'reporteria': reporteria.map((e) => e.toJson()).toList(),
    };
  }
}
