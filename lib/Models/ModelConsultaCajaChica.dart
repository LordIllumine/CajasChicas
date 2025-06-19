class ConsultaCajaChicaModel {
    final String cajaChica;
    final String responsable;
    final double montoCaja;
    final double saldo;
  
    ConsultaCajaChicaModel({
      required this.cajaChica,
      required this.responsable,
      required this.montoCaja,
      required this.saldo,
    });
  
    factory ConsultaCajaChicaModel.fromJson(Map<String, dynamic> json) {
      return ConsultaCajaChicaModel(
        cajaChica: json['cajaChica'] ?? '',
        responsable: json['responsable'] ?? '',
        montoCaja: (json['montoCaja'] ?? 0).toDouble(),
        saldo: (json['saldo'] ?? 0).toDouble(),
      );
    }
  
    Map<String, dynamic> toJson() {
      return {
        'cajaChica': cajaChica,
        'responsable': responsable,
        'montoCaja': montoCaja,
        'saldo': saldo,
      };
    }
  }
  