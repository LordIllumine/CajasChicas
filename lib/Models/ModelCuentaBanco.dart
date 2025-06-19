class CuentaBancariaModel {
  final String cuentaBanco;
  final String nombre;
  final String entidadFinanciera;
  final String moneda;

  CuentaBancariaModel({
    required this.cuentaBanco,
    required this.nombre,
    required this.entidadFinanciera,
    required this.moneda,
  });

  factory CuentaBancariaModel.fromJson(Map<String, dynamic> json) {
    return CuentaBancariaModel(
      cuentaBanco: json['cuentaBanco'] ?? '',
      nombre: json['nombre'] ?? '',
      entidadFinanciera: json['entidadFinanciera'] ?? '',
      moneda: json['moneda'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cuentaBanco': cuentaBanco,
      'nombre': nombre,
      'entidadFinanciera': entidadFinanciera,
      'moneda': moneda,
    };
  }
}

class CuentaBancoResponse {
  final List<CuentaBancoItem> cutBanco;

  CuentaBancoResponse({required this.cutBanco});

  factory CuentaBancoResponse.fromJson(Map<String, dynamic> json) {
    return CuentaBancoResponse(
      cutBanco: (json['cuentaBanco'] as List)
          .map((e) => CuentaBancoItem.fromJson(e))
          .toList(),
    );
  }
}

class CuentaBancoItem {
  final String cuentaBanco;
  final String codigoCuenta;

  CuentaBancoItem({required this.cuentaBanco,required this.codigoCuenta});

  factory CuentaBancoItem.fromJson(Map<String, dynamic> json) {
    return CuentaBancoItem(
      cuentaBanco: "${json['nombre']}", 
      codigoCuenta: json['cuentaBanco'],
    );
  }
}


