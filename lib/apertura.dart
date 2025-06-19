import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'login.dart';
import 'package:cajas_chicas/Controllers/ControllerCajaChica.dart';
import 'package:cajas_chicas/Models/ModelAperturaCajaChica.dart';
import 'package:cajas_chicas/Controllers/ControllerCuentaBanco.dart';
import 'package:cajas_chicas/Models/ModelCuentaBanco.dart';

class AperturaCajaPage extends StatefulWidget {
  final String token;
  final String usuario;
  final String rol;

  const AperturaCajaPage({super.key, required this.token, required this.usuario, required this.rol});

  @override
  State<AperturaCajaPage> createState() => _AperturaCajaPageState();
}

class _AperturaCajaPageState extends State<AperturaCajaPage> {
  final _facturaController = TextEditingController();
  final _montoController = TextEditingController();
  DateTime _fechaSeleccionada = DateTime.now();

  String? _bancoSeleccionado;
  String? _cajaChicaSeleccionado;

  List<CuentaBancoItem> CuentaBancItem = [];
  List<String> cajaChicaList = [];
  List<String> bancos = [];

  @override
  void initState() {
    super.initState();
    cargarCajasChicas();
    cargarCuentaBanco();
  }

  void cargarCajasChicas() async {
    try {
      final cajas = await obtenerCajasChicas(widget.token, widget.usuario, widget.rol);
      setState(() {
        cajaChicaList = cajas;
      });
    } catch (e) {
      _mostrarMensaje('Error al cargar cajas chicas: $e');
    }
  }

  void cargarCuentaBanco() async {
  try {
    // Separar por el guion
    // Verificar si texto no es null ni está vacío
    String CajaChica = (_cajaChicaSeleccionado?.isNotEmpty ?? false)
    ? _cajaChicaSeleccionado!.split('-')[0]
    : "ND";
    final cb = await obtenerCuentasBancarias(widget.token, CajaChica);
    setState(() {
  CuentaBancItem = cb;
  bancos = cb.map((e) => e.cuentaBanco).toSet().toList();

  if (!bancos.contains(_bancoSeleccionado)) {
    _bancoSeleccionado = null; // Resetea para evitar error
  }
});

  } catch (e) {
    _mostrarMensaje('Error al cargar las cuentas de bancos: $e');
  }
}

  Future<void> _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null) {
      setState(() {
        _fechaSeleccionada = picked;
      });
    }
  }

  void _abrirCajaChica() async {
    final numero = int.tryParse(_facturaController.text);
    final monto = double.tryParse(_montoController.text);

    if (numero == null || monto == null || _bancoSeleccionado == null || _cajaChicaSeleccionado == null) {
      _mostrarMensaje('Por favor complete todos los campos correctamente.');
      return;
    }

    String CajaChica = (_cajaChicaSeleccionado?.isNotEmpty ?? false)
    ? _cajaChicaSeleccionado!.split('-')[0]
    : "ND";

    CuentaBancoItem? cbItem = CuentaBancItem.firstWhere(
      (p) => p.cuentaBanco == _bancoSeleccionado,
      orElse: () => CuentaBancoItem(cuentaBanco: "ND", codigoCuenta: "ND"),
    );

    String codigoCB = cbItem.codigoCuenta;

    final model = AperturaCajaChicaModel(
      cajaChica: CajaChica,
      cuentaBanco: codigoCB,
      tipoDocumento: 'T/D',
      numero: numero,
      fecha: _fechaSeleccionada.toIso8601String(),
      monto: monto,
      usuarioCreacion: widget.usuario,
    );

    final response = await aperturaCajaChica(model, widget.token);

    if (!context.mounted) return;

    _mostrarMensaje(response);
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

  @override
  Widget build(BuildContext context) {
    final String fechaFormateada = DateFormat('dd/MM/yyyy').format(_fechaSeleccionada);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0066CC),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
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
                  'APERTURA DE\nCAJA CHICA',
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _dropdownField(
                        label: 'Seleccione una caja',
                        items: cajaChicaList,
                        value: _cajaChicaSeleccionado,
                        onChanged: (val) {
                          setState(() {
                            _cajaChicaSeleccionado = val;
                            //_bancoSeleccionado = null; // LIMPIA LA CUENTA DE BANCO
                            //bancos = [];               // LIMPIA LA LISTA DE OPCIONES VISUALMENTE
                            cargarCuentaBanco();       // CARGA LAS NUEVAS CUENTAS DE BANCO
                          });
                        },
                      ),
                      _textInput(
                        label: 'Digite el número de la factura',
                        controller: _facturaController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      _textInput(
                        label: 'Monto de la transferencia',
                        controller: _montoController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d{0,8}(\.\d{0,2})?$')),
                        ],
                      ),
                      _dropdownField(
                        label: 'Seleccione la cuenta de Banco',
                        items: bancos,
                        value: bancos.contains(_bancoSeleccionado) ? _bancoSeleccionado : null, 
                        onChanged: (val) => setState(() => _bancoSeleccionado = val),
                      ),
                      _calendarField(label: fechaFormateada),

                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _abrirCajaChica,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0066CC),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'ABRIR CAJA',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textInput({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF0F2F5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _dropdownField({
    required String label,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        isExpanded:
            true, // <-- Esto evita los cuadros amarillos en pantallas pequeñas
        value: items.contains(value) ? value : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF0F2F5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _calendarField({required String label}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        onTap: _seleccionarFecha,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F2F5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 16, color: Colors.black54)),
              const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
