import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/ModelCuentaBanco.dart';

//CONSULTO CUENTAS BANCARIAS
Future<List<CuentaBancoItem>> obtenerCuentasBancarias(String token, String CajaChica) async {
  final url = Uri.parse('http://200.91.92.133:5031/api/CuentaBanco/ConsultarCuentasBanco/$CajaChica');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final CB = CuentaBancoResponse.fromJson(data);
    return CB.cutBanco;
  } else {
    throw Exception('Error al consultar las cuentas de banco: ${response.statusCode}');
  }
}