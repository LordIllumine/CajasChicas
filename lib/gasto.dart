import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'login.dart';
import 'package:cajas_chicas/Controllers/ControllerCajaChica.dart';
import 'package:cajas_chicas/Models/ModelCajaChica.dart';
import 'package:cajas_chicas/Models/ModelProveedor.dart';
import 'package:cajas_chicas/Controllers/ControllerCuentaBanco.dart';
import 'package:cajas_chicas/Models/ModelCuentaBanco.dart';
import 'package:dropdown_search/dropdown_search.dart';

class GastoPage extends StatefulWidget {
  final String token;
  final String usuario;
  final String rol;

  GastoPage({
    super.key,
    required this.token,
    required this.usuario,
    required this.rol,
  });
  @override
  State<GastoPage> createState() => _GastoPageState();
}

class _GastoPageState extends State<GastoPage> {
  /*final _FacturaController = TextEditingController();
  final _subTotalController = TextEditingController();
  final _ivaController = TextEditingController();
  final _totalController = TextEditingController();
  final _proveedorController = TextEditingController();*/

  final _CuentaBancoController = TextEditingController();
  final _NumeroFacturaController = TextEditingController();
  final _totalController = TextEditingController();

  DateTime _fechaSeleccionada = DateTime.now();
  String? _cajaChicaSeleccionado;
  String? _proveedorSeleccionado;
  String? _bancoSeleccionado;

  List<String> cajaChicaList = [];
  List<String> proveedorList = [];
  List<ProveedorItem> proveedores = [];
  List<CuentaBancoItem> CuentaBancItem = [];
  List<String> bancos = [];

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
    cargarProveedores();
    cargarCuentaBanco();
  }

  void cargarCajasChicas() async {
    try {
      final cajas = await obtenerCajasChicas(
        widget.token,
        widget.usuario,
        widget.rol,
      );
      setState(() {
        cajaChicaList = cajas;
      });
    } catch (e) {
      _mostrarMensaje('Error al cargar cajas chicas: $e');
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
      bancos = cb.map((e) => e.cuentaBanco).toList();
    });
  } catch (e) {
    _mostrarMensaje('Error al cargar las cuentas de bancos: $e');
  }
}

  void _mostrarMensaje(String mensaje) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
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
    final String fechaFormateada = DateFormat(
      'dd/MM/yyyy',
    ).format(_fechaSeleccionada);

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
                  'REGISTRO DE\nGASTO',
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
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
                        'Seleccione una caja',
                        cajaChicaList,
                        _cajaChicaSeleccionado,
                         (val) {
                          setState(() {
                            _cajaChicaSeleccionado = val;
                            _bancoSeleccionado = null; // LIMPIA LA CUENTA DE BANCO
                            bancos = [];               // LIMPIA LA LISTA DE OPCIONES VISUALMENTE
                            cargarCuentaBanco();       // CARGA LAS NUEVAS CUENTAS DE BANCO
                          });
                        },
                      ),
                      //_textInput('Cuenta Banco', _CuentaBancoController),
                      _dropdownField(
                        'Seleccione cuenta de Banco',
                        bancos,
                        _bancoSeleccionado,
                        (val) {
                          setState(() => _bancoSeleccionado = val);
                        },
                      ),
                      _calendarField('Fecha', fechaFormateada),
                      _textInput(
                        'Número factura',
                        _NumeroFacturaController,
                        TextInputType.number,
                      ),
                      _textInput(
                        'Total',
                        _totalController,
                        TextInputType.number,
                      ),
                      /*_dropdownField(
                        'Seleccione un proveedor',
                        proveedorList,
                        _proveedorSeleccionado,
                        (val) {
                          setState(() => _proveedorSeleccionado = val);
                        },
                      ),*/
                      _dropdownSearchField(
                        'Seleccione un proveedor',
                        proveedorList,
                        _proveedorSeleccionado,
                        (val) {
                          setState(() => _proveedorSeleccionado = val);
                        },
                      ), 
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Validación básica
                            if (_cajaChicaSeleccionado == null ||
                                _cajaChicaSeleccionado == null ||
                                _NumeroFacturaController.text.isEmpty ||
                                _totalController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Por favor, complete todos los campos obligatorios.',
                                  ),
                                ),
                              );
                              return;
                            }

                            // Convertir monto
                            double monto =
                                double.tryParse(
                                  _totalController.text.replaceAll(',', '.'),
                                ) ??
                                0;

                            //separo la cedula del texto
                            ProveedorItem? proveedorItem = proveedores
                                .firstWhere(
                                  (p) => p.proveedors == _proveedorSeleccionado,
                                  orElse:
                                      () => ProveedorItem(
                                        proveedors: "ND",
                                        codigo: "ND",
                                      ),
                                );

                            String codigoPro = proveedorItem.codigo;
                            //String cedulaJuridicaPro = proveedorItem.proveedors.split(' ').first;

                            //por el nombre saco el numero de cuenta
                            CuentaBancoItem? cbItem = CuentaBancItem.firstWhere(
                              (p) => p.cuentaBanco == _bancoSeleccionado,
                              orElse:
                                  () => CuentaBancoItem(
                                    cuentaBanco: "ND",
                                    codigoCuenta: "ND",
                                  ),
                            );

                            String codigoCB = cbItem.codigoCuenta;

                            String CajaChica = (_cajaChicaSeleccionado?.isNotEmpty ?? false)
                                    ? _cajaChicaSeleccionado!.split('-')[0]
                                    : "ND";

                            // Crear modelo
                            CajaChicaModel nuevoGasto = CajaChicaModel(
                              cajaChica: CajaChica,
                              cuentaBanco:
                                  codigoCB, //_CuentaBancoController.text,
                              tipoDocumento:
                                  "T/D", // Valor quemado como indico Enrique
                              usuarioCreacion: widget.usuario,
                              proveedor: codigoPro,
                              numero: _NumeroFacturaController.text,
                              fecha: _fechaSeleccionada,
                              monto: monto,
                            );
                            // Llamar API
                            String resultado = await actualizarCajaChica(
                              nuevoGasto,
                              widget.token,
                            );
                            _mostrarMensaje(resultado);
                            // Mostrar resultado
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(resultado)));

                            if (resultado == "Exito al guardar los datos") {
                              // Si deseas limpiar los campos luego del guardado
                              _CuentaBancoController.clear();
                              _NumeroFacturaController.clear();
                              _totalController.clear();

                              setState(() {
                                _cajaChicaSeleccionado = null;
                                _proveedorSeleccionado = null;
                                _fechaSeleccionada = DateTime.now();
                              });
                            }
                          },
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
            ),
          ],
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
  Widget _textInput(String hint,
    TextEditingController controller, [
    TextInputType? keyboard,
  ]) {
    List<TextInputFormatter> inputFormatters = [];

    if (hint.toLowerCase().contains('total')) {
      inputFormatters = [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ];
    }

    if (hint.toLowerCase().contains('número factura')) {
      inputFormatters = [FilteringTextInputFormatter.digitsOnly];
    }

    return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: TextField(
      controller: controller,
      keyboardType: keyboard,
      inputFormatters: inputFormatters,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        filled: true,
        fillColor: const Color(0xFFF0F2F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
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
              Text(
                value,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdownField(
    String hint,
    List<String> items,
    String? selectedItem,
    ValueChanged<String?> onChanged,
    
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        isExpanded:
            true, // <-- Esto evita los cuadros amarillos en pantallas pequeñas
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 18,
          ),
          filled: true,
          fillColor: const Color(0xFFF0F2F5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        value: selectedItem,
        items:
            items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
