import 'package:flutter/material.dart';
import 'apertura.dart';
import 'gasto.dart';
import 'login.dart';
import 'disponible.dart';
import 'reportes.dart';
import 'valeCaja.dart';

class MenuPage extends StatelessWidget {
  final String usuario;
  final String token;
  final String rol;

  const MenuPage({super.key, required this.usuario, required this.token, required this.rol});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0066CC),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      backgroundColor: const Color(0xFF0066CC),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'MENÚ PRINCIPAL',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    _botonOpcion(
                      context,
                      rol == 'ADM'
                          ? 'Ir a Apertura de Caja'
                          : 'Ir a Registro de Gasto',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => rol == 'ADM'
                                ? AperturaCajaPage(token: token, usuario: usuario, rol:rol) //paso al constructor el token
                                : GastoPage(token: token, usuario: usuario, rol:rol),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _botonOpcion(
                      context,
                      'Ver disponible en cajas',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DisponiblePage(token: token, usuario: usuario, rol:rol),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _botonOpcion(
                      context,
                      'Ir a Reportes',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportesPage(token: token, usuario: usuario, rol:rol),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _botonOpcion(
                      context,
                      'Insertar Vale de caja',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ValeCajaPage(token: token, usuario: usuario, rol:rol),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _botonOpcion(BuildContext context, String texto, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0066CC),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          texto,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
