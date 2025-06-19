import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cajas_chicas/Models/ModelVale.dart';
import 'package:cajas_chicas/Models/ModelCentroCosto.dart';

  final String baseUrl = "http://200.91.92.133:5031/api/CajaChica";

  // CONSULTAR SOLO LA DESCRIPCIÓN DE LOS CONCEPTOS DE VALE
  Future<List<String>> consultarConceptosVale(String token) async {
    final url = Uri.parse('$baseUrl/ConsultarConseptoVale');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final conceptos = ListaConceptoVale.fromJson(data);
      return conceptos.conceptoVale.map((e) => e.descripcion).toList();
    } else {
      throw Exception('Error al consultar conceptos vale: ${response.statusCode}');
    }
  }

//CONSULTO Centro de costo
Future<List<CentroCostoItem>> obtenerCentroCosto(String token) async {
  final url = Uri.parse('http://200.91.92.133:5031/api/CentroCosto/ConsultarCentroCosto');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final pro = CentroCostoResponse.fromJson(data);
    return pro.proveedor;
  } else {
    throw Exception('Error al consultar los Centros de costos: ${response.statusCode}');
  }
}

//guardo los datos de la pantalla en el endpoint
Future<String> insertarValeCajaChica(String token, ValeCajaChica vale) async {
  final url = Uri.parse('http://200.91.92.133:5031/api/CajaChica/InsertaValeCajaChica');

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(vale.toJson()),
    
  );
print("1----------------------------------------------------${vale.toJson()}");
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final respuesta = RespuestaVale.fromJson(data);
    return respuesta.mensaje;
  } else {
    throw Exception('Error al insertar el vale: ${response.statusCode}');
  }
}

