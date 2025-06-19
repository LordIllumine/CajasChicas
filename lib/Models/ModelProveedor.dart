class ProveedorModel {
  final String codigoProveedor;
  final String nombreProveedor;
  final String cedulaJuridica;

  ProveedorModel({
    required this.codigoProveedor,
    required this.nombreProveedor,
    required this.cedulaJuridica,
  });

  factory ProveedorModel.fromJson(Map<String, dynamic> json) {
    return ProveedorModel(
      codigoProveedor: json['codigoProveedor'] ?? '',
      nombreProveedor: json['nombreProveedor'] ?? '',
      cedulaJuridica: json['cedulaJuridica'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigoProveedor': codigoProveedor,
      'nombreProveedor': nombreProveedor,
      'cedulaJuridica': cedulaJuridica,
    };
  }
}

class ProveedorResponse {
  final List<ProveedorItem> proveedor;

  ProveedorResponse({required this.proveedor});

  factory ProveedorResponse.fromJson(Map<String, dynamic> json) {
    return ProveedorResponse(
      proveedor: (json['proveedores'] as List)
          .map((e) => ProveedorItem.fromJson(e))
          .toList(),
    );
  }
}

class ProveedorItem {
  final String proveedors;
  final String codigo;

  ProveedorItem({required this.proveedors,required this.codigo});

  factory ProveedorItem.fromJson(Map<String, dynamic> json) {
    return ProveedorItem(
      proveedors: "${json['cedulaJuridica']} ${json['nombreProveedor']}",
      codigo: json['codigoProveedor'],
    );
  }
}


