import 'package:flutter/material.dart';
import 'package:cajas_chicas/Models/ModelReporteMovimientos.dart';
import 'package:intl/intl.dart';

class DetalleReporteriaPage extends StatelessWidget {
  final String cajaChica;
  final String responsable;
  final List<Reporteria> detalles;

  const DetalleReporteriaPage({
    super.key,
    required this.cajaChica,
    required this.responsable,
    required this.detalles,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de $cajaChica'),
        backgroundColor: const Color(0xFF0066CC),
      ),
      body: detalles.isEmpty
          ? const Center(child: Text('No hay datos de reportería disponibles.'))
          : ListView.builder(
              itemCount: detalles.length,
              itemBuilder: (context, index) {
                final d = detalles[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(d.tipoMovimiento),
                    subtitle: Text(
                      'Fecha: ${d.fechaMovimiento.split(' ').first}\n'
                      'Referencia: ${d.referencia}\n'
                      'concepto: ${d.concepto}\n'
                      'Ingresado por: ${d.usuarioCreacion}\n',
                    ),
                    trailing: Text(
                      'Monto: ${NumberFormat('#,##0.00', 'es_ES').format(d.monto)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
