import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cajas_chicas/Models/ModelReporteMovimientos.dart';

class ControllerReporteMovimiento {
  Future<ReporteResponse> fetchReporte({
    required String rol,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String usuario,
    required String token,
  }) async {
    final url = Uri.parse("http://200.91.92.133:5031/api/Reporte/Reporte");

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({
      'Rol': rol,
      'FechaInicio': fechaInicio.toIso8601String(),
      'FechaFin': fechaFin.toIso8601String(),
      'Usuario': usuario,
    });

    final response = await http.post(url, headers: headers, body: body);

    print(response.body);
    
    if (response.statusCode == 200) {
      return ReporteResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar reporte');
    }
  }
}
