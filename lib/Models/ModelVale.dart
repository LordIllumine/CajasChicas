
class ConceptoVale {
  final String descripcion;

  ConceptoVale({required this.descripcion});

  factory ConceptoVale.fromJson(Map<String, dynamic> json) {
    return ConceptoVale(
      descripcion: json['descripcion_conceptoVale'] ?? '',
    );
  }
}

class ListaConceptoVale {
  final List<ConceptoVale> conceptoVale;

  ListaConceptoVale({required this.conceptoVale});

  factory ListaConceptoVale.fromJson(Map<String, dynamic> json) {
    var lista = json['concepto_Vale'] as List;
    List<ConceptoVale> conceptos =
        lista.map((i) => ConceptoVale.fromJson(i)).toList();
    return ListaConceptoVale(conceptoVale: conceptos);
  }
}


//guardar los datos en el endpoint
class ValeCajaChica {
  final String cajaChica;
  final String vale;
  final String descripcionConceptoVale;
  final String identificacionEmpleado;
  final String centroCosto;
  final DateTime fecha;
  final double monto;
  final String usuario;
  final bool UsaIVA;

  ValeCajaChica({
    required this.cajaChica,
    required this.vale,
    required this.descripcionConceptoVale,
    required this.identificacionEmpleado,
    required this.centroCosto,
    required this.fecha,
    required this.monto,
    required this.usuario,
    required this.UsaIVA,
  });

  Map<String, dynamic> toJson() {
    return {
      'cajaChica': cajaChica,
      'vale': vale,
      'descripcion_conceptoVale': descripcionConceptoVale,
      'identificacionEmpleado': identificacionEmpleado,
      'centroCosto': centroCosto,
      'fecha': fecha.toIso8601String(),
      'monto': monto,
      'usuario': usuario,
      'usaImpuesto': UsaIVA,
    };
  }
}

class RespuestaVale {
  final String mensaje;

  RespuestaVale({required this.mensaje});

  factory RespuestaVale.fromJson(Map<String, dynamic> json) {
    return RespuestaVale(mensaje: json['mensaje']);
  }
}