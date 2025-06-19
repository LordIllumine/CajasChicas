//Apertura caja chica 
// lib/models/apertura_caja_chica_model.dart

class AperturaCajaChicaModel {
  final String? cajaChica;
  final String? cuentaBanco;
  final String tipoDocumento;
  final int numero;
  final String fecha;
  final double monto;
  final String usuarioCreacion;

  AperturaCajaChicaModel({
    required this.cajaChica,
    required this.cuentaBanco,
    required this.tipoDocumento,
    required this.numero,
    required this.fecha,
    required this.monto,
    required this.usuarioCreacion,
  });

  Map<String, dynamic> toJson() {
    return {
      "cajaChica": cajaChica,
      "cuentaBanco": cuentaBanco,
      "tipoDocumento": tipoDocumento,
      "numero": numero,
      "fecha": fecha,
      "monto": monto,
      "usuarioCreacion": usuarioCreacion,
    };
  }
}

/*class AperturaCajaChicaModel {
  final String numFactura;
  final double montoTransferencia;
  final String banco;
  final String caja;
  final String moneda;

  AperturaCajaChicaModel({
    required this.numFactura,
    required this.montoTransferencia,
    required this.banco,
    required this.caja,
    required this.moneda,
  });

  factory AperturaCajaChicaModel.fromJson(Map<String, dynamic> json) {
    return AperturaCajaChicaModel(
      numFactura: json['numFactura'] ?? '',
      montoTransferencia: (json['montoTransferencia'] ?? 0).toDouble(),
      banco: json['banco'] ?? '',
      caja: json['caja'] ?? '',
      moneda: json['moneda'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numFactura': numFactura,
      'montoTransferencia': montoTransferencia,
      'banco': banco,
      'caja': caja,
      'moneda': moneda,
    };
  }
}
*/
