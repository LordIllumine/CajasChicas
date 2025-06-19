class CajaChicaModel {
  final String cajaChica;
  final String cuentaBanco;
  final String tipoDocumento;
  final String usuarioCreacion;
  final String proveedor;
  final String numero;
  final DateTime fecha;
  final double monto;

  CajaChicaModel({
    required this.cajaChica,
    required this.cuentaBanco,
    required this.tipoDocumento,
    required this.usuarioCreacion,
    required this.proveedor,
    required this.numero,
    required this.fecha,
    required this.monto,
  });

  factory CajaChicaModel.fromJson(Map<String, dynamic> json) {
    return CajaChicaModel(
      cajaChica: json['cajaChica'] ?? '',
      cuentaBanco: json['cuentaBanco'] ?? '',
      tipoDocumento: json['tipoDocumento'] ?? '',
      usuarioCreacion: json['usuarioCreacion'] ?? '',
      proveedor: json['proveedor'] ?? '',
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
      'proveedor': proveedor,
      'numero': numero,
      'fecha': fecha.toIso8601String(),
      'monto': monto,
    };
  }
}


//consultar las cajas chicas 

class CajaChicaResponse {
  final List<CajaChicaItem> cajaChicas;

  CajaChicaResponse({required this.cajaChicas});

  factory CajaChicaResponse.fromJson(Map<String, dynamic> json) {
    return CajaChicaResponse(
      cajaChicas: (json['cajaChicas'] as List)
          .map((e) => CajaChicaItem.fromJson(e))
          .toList(),
    );
  }
}

class CajaChicaItem {
  final String cajaChica;

  CajaChicaItem({required this.cajaChica});

  factory CajaChicaItem.fromJson(Map<String, dynamic> json) {
    return CajaChicaItem(
      cajaChica: json['cajaChica'],
    );
  }
}

//regreso todos los datos del json
class CajaChicaResponseAll {
  final List<CajaChicaItemAll> cajaChicas;

  CajaChicaResponseAll({required this.cajaChicas});

  factory CajaChicaResponseAll.fromJson(Map<String, dynamic> json) {
    return CajaChicaResponseAll(
      cajaChicas: (json['cajaChicas'] as List)
          .map((e) => CajaChicaItemAll.fromJson(e))
          .toList(),
    );
  }
}

class CajaChicaItemAll {
  final String cajaChica;
  final String responsable;
  final double montoCaja;
  final double saldo;

  CajaChicaItemAll({
    required this.cajaChica,
    required this.responsable,
    required this.montoCaja,
    required this.saldo,
  });

  factory CajaChicaItemAll.fromJson(Map<String, dynamic> json) {
    return CajaChicaItemAll(
      cajaChica: json['cajaChica'],
      responsable: json['responsable'],
      montoCaja: (json['montoCaja'] as num).toDouble(),
      saldo: (json['saldo'] as num).toDouble(),
    );
  }
}