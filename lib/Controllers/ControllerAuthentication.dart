import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/ModelToken.dart';

class Mauthentication {
  Future<UsuarioAutenticadoClass> autenticarUsuario(String usuario, String contrasena) async {
    try {
      final tokenUrl = Uri.parse("http://200.91.92.133:5031/api/Autentificar/GetToken");
//print("1----------------------------------------------------${usuario} contra ${contrasena}");
      final tokenResponse = await http.post(
        tokenUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "usuario": usuario,
          "contrasena": contrasena,
        }),
      );
      if (tokenResponse.statusCode != 200) {
        throw Exception("No se pudo autenticar");
      }

      final tokenJson = jsonDecode(tokenResponse.body);

      if (tokenJson["resUser"]["autenticado"] != true) {
        throw Exception("${tokenJson["resUser"]["message"]}");
      }

      return UsuarioAutenticadoClass.fromJson(tokenJson["resUser"]);
    } catch (e) {
      throw Exception("$e");
    }
  }
}