import 'package:flutter/material.dart';
import 'package:cajas_chicas/Controllers/ControllerReporteMovimientos.dart';
import 'package:cajas_chicas/Models/ModelReporteMovimientos.dart';
import '/detalle_reporteria_page.dart';
import 'login.dart';

class ReportesPage extends StatefulWidget {
  final String token;
  final String usuario;
  final String rol;

  const ReportesPage({
    super.key,
    required this.token,
    required this.usuario,
    required this.rol,
  });

  @override
  State<ReportesPage> createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage> {
  DateTime? fechaInicio;
  DateTime? fechaFin;
  final TextEditingController _inicioController = TextEditingController();
  final TextEditingController _finController = TextEditingController();
  ReporteResponse? reporte;
  bool loading = false;

  Future<void> seleccionarFecha(BuildContext context, bool esInicio) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025, 12, 31),
    );

    if (picked != null) {
      setState(() {
        if (esInicio) {
          fechaInicio = DateTime(
            picked.year,
            picked.month,
            picked.day,
            0,
            0,
            0,
          );
          _inicioController.text = picked.toLocal().toString().split(' ')[0];
        } else {
          fechaFin = DateTime(
            picked.year,
            picked.month,
            picked.day,
            23,
            59,
            59,
          );
          _finController.text = picked.toLocal().toString().split(' ')[0];
        }
      });
    }
  }

  void _mostrarMensaje(String mensaje) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Mensaje'),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Future<void> obtenerReporte() async {
    if (fechaInicio == null || fechaFin == null) return;

    setState(() => loading = true);

    try {
      final controller = ControllerReporteMovimiento();
      final resultado = await controller.fetchReporte(
        rol: widget.rol,
        fechaInicio: fechaInicio!,
        fechaFin: fechaFin!,
        usuario: widget.usuario,
        token: widget.token,
      );
      setState(() {
        reporte = resultado;
      });
    } catch (e) {
      _mostrarMensaje('$e');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    _inicioController.dispose();
    _finController.dispose();
    super.dispose();
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
              child: Text(
                'REPORTES',
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        margin: const EdgeInsets.only(left: 12, bottom: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Fecha Inicio',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _inicioController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onTap: () => seleccionarFecha(context, true),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        margin: const EdgeInsets.only(left: 12, bottom: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Fecha Fin',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _finController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onTap: () => seleccionarFecha(context, false),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: obtenerReporte,
                    child: const Text('Generar Reporte'),
                  ),
                  const SizedBox(height: 10),
                ],
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
                child:
                    loading
                        ? const Center(child: CircularProgressIndicator())
                        : reporte == null
                        ? const Center(
                          child: Text(
                            'Aquí se mostrarán los reportes generados',
                          ),
                        )
                        : ListView.builder(
                          itemCount: reporte!.cantidadMovimientos.length,
                          itemBuilder: (context, index) {
                            //print(index);
                            final item = reporte!.cantidadMovimientos[index];
                            //print(item);
                            //print(item.cajaChica);
                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                //title: Text('Caja: ${item.cajaChica}'),
                                subtitle: Text(
                                  'Caja Chia: ${item.cajaChica}\n'
                                  'Responsable: ${item.responsable}\n'
                                  'Moneda: ${item.moneda}\n'
                                  'Área Funcional: ${item.areaFuncional}',
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Ingresos: ${item.cantidadIngresos}'),
                                    Text('Egresos: ${item.cantidadEgresos}'),
                                  ],
                                ),
                                onTap: () {
                                  final detalles =
                                      reporte!.reporteria
                                          .where(
                                            (r) =>
                                                r.cajaChica == item.cajaChica &&
                                                r.responsable == item.responsable,
                                          )
                                          .toList();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => DetalleReporteriaPage(
                                            cajaChica: item.cajaChica,
                                            responsable: item.responsable,
                                            detalles: detalles,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            );
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
