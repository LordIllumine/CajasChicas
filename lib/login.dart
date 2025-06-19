import 'package:flutter/material.dart';
import 'menu.dart';
import 'package:cajas_chicas/Controllers/ControllerAuthentication.dart';
import 'package:cajas_chicas/Models/ModelToken.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _claveController = TextEditingController();
  bool _mostrarContrasena = false;
  bool _cargando = false;

  final authService = Mauthentication();

  Future<void> _iniciarSesion() async {
    final String usuario = _usuarioController.text.trim();
    final String contrasena = _claveController.text.trim();

    if (usuario.isEmpty || contrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    setState(() => _cargando = true);

    try {
      final UsuarioAutenticadoClass datos = await authService.autenticarUsuario(usuario, contrasena);

      //if (datos.autenticado != true) {
      //  throw Exception("Autenticación fallida");
      //}

      final String token = datos.token;
      final String rol = datos.rol;
//print("1----------------------------------------------------${rol} contra ${token}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MenuPage(usuario: usuario.toLowerCase(), token: token, rol: rol),
        ),
      );
    } catch (e) {
      setState(() => _cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', height: 100),
                const SizedBox(height: 20),
                const Text(
                  'INICIAR SESIÓN',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(221, 37, 34, 34),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _usuarioController,
                  decoration: InputDecoration(
                    hintText: 'Usuario',
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _claveController,
                  obscureText: !_mostrarContrasena,
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _mostrarContrasena ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _mostrarContrasena = !_mostrarContrasena;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                //Align(
                  //alignment: Alignment.centerRight,
                  //child: TextButton(
                  //  onPressed: () {},
                  //  child: const Text(
                  //    '¿Olvidó su contraseña?',
                  //    style: TextStyle(color: Colors.blueAccent),
                  //  ),
                  //),
                //),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _cargando ? null : _iniciarSesion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _cargando
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'INGRESAR',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
