class CentroCostoResponse {
  final List<CentroCostoItem> proveedor;

  CentroCostoResponse({required this.proveedor});

  factory CentroCostoResponse.fromJson(Map<String, dynamic> json) {
    return CentroCostoResponse(
      proveedor: (json['centroCosto'] as List)
          .map((e) => CentroCostoItem.fromJson(e))
          .toList(),
    );
  }
}

class CentroCostoItem {
  final String centroCosto;
  final String descripcion;

  CentroCostoItem({required this.centroCosto,required this.descripcion});

  factory CentroCostoItem.fromJson(Map<String, dynamic> json) {
    return CentroCostoItem(
      centroCosto: "${json['centro_Costo']} ${json['descripcion']}",
      descripcion: json['descripcion'],
    );
  }
}