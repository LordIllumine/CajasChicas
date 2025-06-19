import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:cajas_chicas/Controllers/ControllerCajaChica.dart';
import 'package:cajas_chicas/Controllers/ControllerVale.dart';
import 'package:cajas_chicas/Models/ModelVale.dart';
import 'package:cajas_chicas/Models/ModelProveedor.dart';
import 'package:cajas_chicas/Models/ModelCentroCosto.dart';
import 'login.dart';
import 'package:dropdown_search/dropdown_search.dart';

class ValeCajaPage extends StatefulWidget {
  final String token;
  final String usuario;
  final String rol;
  

  ValeCajaPage({super.key, required this.token, required this.usuario, required this.rol});

  @override
  State<ValeCajaPage> createState() => _ValeCajaPageState();
}

class _ValeCajaPageState extends State<ValeCajaPage> {
  final _numeroValeController = TextEditingController();
  final _identificacionController = TextEditingController();
  final _montoController = TextEditingController();

  DateTime _fechaSeleccionada = DateTime.now();
  String? _cajaSeleccionada;
  String? _conceptoSeleccionado;
  String? _proveedorSeleccionado;
  String? _centroCostoSeleccionado;
  bool _facturaExenta = true;

  List<String> cajaChicaList = [];
  List<String> conceptos = [];
  List<ProveedorItem> proveedores = [];
  List<String> proveedorList = [];
  List<CentroCostoItem> centroCosto = [];
  List<String> centroCostoList = [];

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

  @override
  void initState() {
    super.initState();
    cargarCajasChicas();
    cargarConceptoVale();
    cargarProveedores();
    cargarCentroCosto();
  }

  void cargarConceptoVale() async {
  try {
      final Concepto = await consultarConceptosVale(widget.token);
      setState(() {
        conceptos = Concepto;
      });
    } catch (e) {
      print('Error al cargar cajas chicas: $e');
    }
  }

  void cargarCajasChicas() async {
  try {
      final cajas = await obtenerCajasChicas(widget.token, widget.usuario, widget.rol);
      setState(() {
        cajaChicaList = cajas;
      });
    } catch (e) {
      print('Error al cargar cajas chicas: $e');
    }
  }

void cargarProveedores() async {
    try {
      final prov = await obtenerProveedores(widget.token);
      setState(() {
        proveedores = prov;
        proveedorList = prov.map((e) => e.proveedors).toList();
      });
    } catch (e) {
      _mostrarMensaje('Error al cargar los proveedores: $e');
    }
  }

  void cargarCentroCosto() async {
    try {
      final Centr = await obtenerCentroCosto(widget.token);
      setState(() {
        centroCosto = Centr;
        centroCostoList = Centr.map((e) => e.centroCosto).toList();
      });
    } catch (e) {
      _mostrarMensaje('Error al cargar los Centro de costos: $e');
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

  @override
  Widget build(BuildContext context) {
    final String fechaFormateada = DateFormat('dd/MM/yyyy').format(_fechaSeleccionada);

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
                  'REGISTRO DE\nVALE DE CAJA',
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
                      _dropdownField('Seleccione una caja', cajaChicaList, _cajaSeleccionada, (val) {
                        setState(() => _cajaSeleccionada = val);
                      }),
                      _textInput('Número de documento', _numeroValeController, TextInputType.text),
                      _styledCheckboxField(
                        label: 'Agregar IVA?',
                        value: _facturaExenta,
                        onChanged: (val) {
                          setState(() => _facturaExenta = val ?? false);
                        },
                      ),
                      _dropdownField('Seleccione Concepto Vale', conceptos, _conceptoSeleccionado, (val) {
                        setState(() => _conceptoSeleccionado = val);
                      }),
                      /*_dropdownField('Seleccione un proveedor', proveedorList, _proveedorSeleccionado, (val) {
                        setState(() => _proveedorSeleccionado = val);
                      }),*/
                      _dropdownSearchField(
                        'Seleccione un proveedor',
                        proveedorList,
                        _proveedorSeleccionado,
                        (val) {
                          setState(() => _proveedorSeleccionado = val);
                        },
                      ), 
                      /*_dropdownField('Seleccione un Centro de Costo', centroCostoList, _centroCostoSeleccionado, (val) {
                        setState(() => _centroCostoSeleccionado = val);
                      }),*/
                       _dropdownSearchField(
                        'Seleccione un Centro de Costo',
                        centroCostoList,
                        _centroCostoSeleccionado,
                        (val) {
                          setState(() => _centroCostoSeleccionado = val);
                        },
                      ),
                      _calendarField('Fecha del Vale', fechaFormateada),
                      _textInput('Monto del Vale', _montoController, TextInputType.numberWithOptions(decimal: true), soloNumeros: true),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _guardarFormulario,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0066CC),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'GUARDAR',
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
            )
          ],
        ),
      ),
    );
  }

    Widget _styledCheckboxField({
  required String label,
  required bool value,
  required Function(bool?) onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF0F2F5),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _dropdownSearchField(
  String hint,
  List<String> items,
  String? selectedItem,
  Function(String?) onChanged,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: DropdownSearch<String>(
      items: items,
      selectedItem: selectedItem,
      onChanged: onChanged,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          filled: true,
          fillColor: const Color(0xFFF0F2F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      popupProps: PopupProps.menu(
        showSearchBox: true,
        fit: FlexFit.loose,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: 'Buscar $hint',
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            filled: true,
            fillColor: const Color(0xFFF0F2F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    ),
  );
}

  Widget _textInput(String hint, TextEditingController controller, TextInputType? keyboard,
      {bool filtroIdentificacion = false, bool soloNumeros = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        inputFormatters: [
          if (filtroIdentificacion)
            FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Za-z]'))
          else if (soloNumeros)
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          filled: true,
          fillColor: const Color(0xFFF0F2F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _calendarField(String label, String value) {
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
              Text(value, style: const TextStyle(fontSize: 16)),
              const Icon(Icons.calendar_today, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdownField(String hint, List<String> items, String? selectedItem, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        value: selectedItem,
        hint: Text(hint),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          filled: true,
          fillColor: const Color(0xFFF0F2F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  void _guardarFormulario() async {
  final monto = double.tryParse(_montoController.text.replaceAll(',', '.')) ?? 0;

  if (_cajaSeleccionada == null ||
      _conceptoSeleccionado == null ||
      _numeroValeController.text.isEmpty ||
      _proveedorSeleccionado == null ||
      _centroCostoSeleccionado == null ||
      monto <= 0) {
    _mostrarMensaje('Por favor, complete todos los campos correctamente.');
    return;
  }


  final vale = ValeCajaChica(
    cajaChica: _cajaSeleccionada!,
    vale: _numeroValeController.text.trim(),
    descripcionConceptoVale: _conceptoSeleccionado!,
    identificacionEmpleado: _proveedorSeleccionado!,
    centroCosto: _centroCostoSeleccionado!,
    fecha: _fechaSeleccionada,
    monto: monto,
    usuario: widget.usuario,
    UsaIVA: _facturaExenta,
  );

  try {
    
    final mensaje = await insertarValeCajaChica(widget.token, vale);
    _mostrarMensaje(mensaje);

    if (mensaje == "Vale ingresado con éxito") {
      // Limpiar campos
      setState(() {
        _cajaSeleccionada = null;
        _conceptoSeleccionado = null;
        _fechaSeleccionada = DateTime.now();
        _numeroValeController.clear();
        _identificacionController.clear();
        _montoController.clear();
      });
    }
  } catch (e) {
    _mostrarMensaje('Error al guardar: $e');
  }
}
}
