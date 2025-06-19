import 'package:flutter/material.dart';
import 'login.dart';
import 'package:cajas_chicas/Models/ModelCajaChica.dart';
import 'package:cajas_chicas/Controllers/ControllerCajaChica.dart';
import 'package:intl/intl.dart';

class DisponiblePage extends StatefulWidget {
  final String token;
  final String usuario;
  final String rol;

  const DisponiblePage({
    super.key,
    required this.token,
    required this.usuario,
    required this.rol,
  });

  @override
  _DisponiblePageState createState() => _DisponiblePageState();
}

class _DisponiblePageState extends State<DisponiblePage> {
  late Future<List<CajaChicaItemAll>> _futureCajas;

  @override
  void initState() {
    super.initState();
    _futureCajas = obtenerCajasChicasAll(
      widget.token,
      widget.usuario,
      widget.rol,
    );
  }

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
                  'DISPONIBLE EN CAJAS',
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
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: FutureBuilder<List<CajaChicaItemAll>>(
                  future: _futureCajas,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No hay cajas chicas disponibles'),
                      );
                    }

                    final cajas = snapshot.data!;
                    return ListView.builder(
                      itemCount: cajas.length,
                      itemBuilder: (context, index) {
                        final caja = cajas[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(caja.cajaChica),
                            subtitle: Text('Responsable: ${caja.responsable}'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Monto: ${NumberFormat('#,##0.00', 'es_ES').format(caja.montoCaja)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Saldo: ${NumberFormat('#,##0.00', 'es_ES').format(caja.saldo)}', 
                                  style: const TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                    //Tabla tipo excel
                    /*return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                      columnSpacing: 20,
                      columns: const [
                        DataColumn(label: Text('Caja')),
                        DataColumn(label: Text('Responsable')),
                        DataColumn(label: Text('Monto')),
                        DataColumn(label: Text('Saldo')),
                      ],
                      rows: cajas.map((caja) {
                      return DataRow(cells: [
                        DataCell(Text(caja.cajaChica)),
                        DataCell(Text(caja.responsable)),
                        DataCell(Text(caja.montoCaja.toString())),
                        DataCell(Text(caja.saldo.toString())),
                      ]);
                      }).toList(),
                      ),
                    ),
                    );*/
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
