import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/ModelCajaChica.dart';
import '../Models/ModelProveedor.dart';
import '../Models/ModelAperturaCajaChica.dart';

Future<String> actualizarCajaChica(CajaChicaModel model, String token) async {
  final url = Uri.parse('http://200.91.92.133:5031/api/CajaChica/ActSaldoCajaChicaFactura');

  try {
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['mensaje'] ?? 'Operación exitosa.';
    } else {
      return 'Error ${response.statusCode}: ${response.reasonPhrase}';
    }
  } catch (e) {
    return 'Excepción: $e';
  }
}

//CONSULTAR LAS CAJAS CHICAS SOLO EL NOMBRE 
Future<List<String>> obtenerCajasChicas(String token, String usuario, String rol) async {
  final url = Uri.parse('http://200.91.92.133:5031/api/CajaChica/ConsultarCajaChica/Usuario/$usuario/rol/$rol');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final cajas = CajaChicaResponse.fromJson(data);
    return cajas.cajaChicas.map((e) => e.cajaChica).toList();
  } else {
    throw Exception('Error al consultar cajas chicas: ${response.statusCode}');
  }
}

//CONSULTO PROVEEDORES
Future<List<ProveedorItem>> obtenerProveedores(String token) async {
  final url = Uri.parse('http://200.91.92.133:5031/api/Proveedores/ConsultarProveedor');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final pro = ProveedorResponse.fromJson(data);
    return pro.proveedor;
  } else {
    throw Exception('Error al consultar los proveedores: ${response.statusCode}');
  }
}

//CONSULTAR LAS CAJAS CHICAS Toda la informacion
Future<List<CajaChicaItemAll>> obtenerCajasChicasAll(String token, String usuario, String rol) async {
  final url = Uri.parse('http://200.91.92.133:5031/api/CajaChica/ConsultarCajaChica/Usuario/$usuario/rol/$rol');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final cajas = CajaChicaResponseAll.fromJson(data);
    return cajas.cajaChicas;
  } else {
    throw Exception('Error al consultar cajas chicas: ${response.statusCode}');
  }
}

Future<String> aperturaCajaChica(AperturaCajaChicaModel model, String token) async {
    const String url = "http://200.91.92.133:5031/api/CajaChica/AperturaCajaChica";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(model.toJson()),
      );

      //String prueba = jsonEncode(model.toJson());
      //print("JSON APERTURA ${prueba}");

      if (response.statusCode == 200 || response.statusCode == 400) {
        final data = jsonDecode(response.body);
        return data['mensaje'] ?? 'Operación completada.';
      } else {
        return 'Error del servidor: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error al conectar: $e';
    }
  }