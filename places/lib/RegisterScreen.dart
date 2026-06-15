import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  final _userCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nombresCtrl = TextEditingController();
  final _apellidoCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();

  String? _genero;
  DateTime? _fechaNac;

  Future<void> _crearCuenta() async {
    if (_formKey.currentState!.validate()) {
      // ... validaciones de género y fecha ...

      final datos = {
        "usuario": _userCtrl.text.trim(),
        "contrasena": _passCtrl.text.trim(),
        "persona": {
          "nombres": _nombresCtrl.text.trim(),
          "primerApellido": _apellidoCtrl.text.trim(),
          "email": _emailCtrl.text.trim(),
          "direccion": _direccionCtrl.text.trim(),
          "genero": _genero,
          "fechaNacimiento": DateFormat('yyyy-MM-dd').format(_fechaNac!),
        }
      };

      // Asegúrate de que registrarUsuario envíe este mapa usando jsonEncode
      bool ok = await _authService.registrarUsuario(datos);
      // ... resto de la lógica ...


      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cuenta creada"), backgroundColor: Colors.green));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al registrar"), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrar Usuario")),
      body: SingleChildScrollView(padding: EdgeInsets.all(20), child: Form(key: _formKey, child: Column(children: [
        TextFormField(controller: _userCtrl, decoration: InputDecoration(labelText: "Usuario"), validator: (v) => v!.isEmpty ? 'Requerido' : null),
        TextFormField(controller: _emailCtrl, decoration: InputDecoration(labelText: "Email"), validator: (v) => v!.isEmpty ? 'Requerido' : null),
        TextFormField(controller: _passCtrl, decoration: InputDecoration(labelText: "Contraseña"), obscureText: true),
        TextFormField(controller: _nombresCtrl, decoration: InputDecoration(labelText: "Nombres")),
        TextFormField(controller: _apellidoCtrl, decoration: InputDecoration(labelText: "Apellido")),
        TextFormField(controller: _direccionCtrl, decoration: InputDecoration(labelText: "Dirección")),
        DropdownButtonFormField<String>(decoration: InputDecoration(labelText: "Género"), items: ['M', 'F'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(), onChanged: (v) => setState(() => _genero = v)),
        ListTile(title: Text(_fechaNac == null ? "Fecha Nacimiento" : DateFormat('yyyy-MM-dd').format(_fechaNac!)), trailing: Icon(Icons.calendar_today), onTap: () async {
          DateTime? picked = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1900), lastDate: DateTime.now());
          if (picked != null) setState(() => _fechaNac = picked);
        }),
        SizedBox(height: 30),
        ElevatedButton(onPressed: _crearCuenta, child: Text("REGISTRARME"))
      ]))),
    );
  }
}