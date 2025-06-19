class Classtoken {
  String Token;
  String Rol;

  Classtoken({
    required this.Token,
    required this.Rol,
  });
}

class UsuarioAutenticadoClass {
  final bool autenticado;
  final String usuario;
  final String rol;
  final String token;
  final String mensaje;

  UsuarioAutenticadoClass({
    required this.autenticado,
    required this.usuario,
    required this.rol,
    required this.token,
    required this.mensaje,
  });

  factory UsuarioAutenticadoClass.fromJson(Map<String, dynamic> json) {
  return UsuarioAutenticadoClass(
    autenticado: json['autenticado'] ?? false,
    usuario: json['usuario'] ?? '',
    rol: json['rol'] ?? '',
    token: json['token'] ?? '',
    mensaje: json['message'] ?? '', // Aquí está la clave del JSON real
  );
}
}
