import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'auth_service.dart';

class ProfilePlaces extends StatefulWidget {
  @override
  _ProfilePlacesState createState() => _ProfilePlacesState();
}

class _ProfilePlacesState extends State<ProfilePlaces> {
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
      if (_genero == null || _fechaNac == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Selecciona género y fecha de nacimiento")));
        return;
      }

      // Preparación de datos (asegúrate de que coincida con el @RequestBody de tu API)
      final datos = {
        "usuario": _userCtrl.text.trim(),
        "contrasena": _passCtrl.text.trim(),
        "email": _emailCtrl.text.trim(),
        "nombres": _nombresCtrl.text.trim(),
        "primerApellido": _apellidoCtrl.text.trim(),
        "direccion": _direccionCtrl.text.trim(),
        "genero": _genero,
        "fechaNacimiento": DateFormat('yyyy-MM-dd').format(_fechaNac!),
      };

      bool ok = await _authService.registrarUsuario(datos);

      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("¡Cuenta creada exitosamente!"), backgroundColor: Colors.green));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al registrar: verifica la conexión o datos"), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrar Usuario")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _userCtrl, decoration: InputDecoration(labelText: "Usuario"), validator: (v) => v!.isEmpty ? 'Requerido' : null),
              TextFormField(controller: _emailCtrl, decoration: InputDecoration(labelText: "Email"), validator: (v) => v!.isEmpty ? 'Requerido' : null),
              TextFormField(controller: _passCtrl, decoration: InputDecoration(labelText: "Contraseña"), obscureText: true, validator: (v) => v!.isEmpty ? 'Requerido' : null),
              TextFormField(controller: _nombresCtrl, decoration: InputDecoration(labelText: "Nombres")),
              TextFormField(controller: _apellidoCtrl, decoration: InputDecoration(labelText: "Apellido")),
              TextFormField(controller: _direccionCtrl, decoration: InputDecoration(labelText: "Dirección")),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Género"),
                items: ['M', 'F'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (val) => setState(() => _genero = val),
              ),
              ListTile(
                title: Text(_fechaNac == null ? "Fecha Nacimiento" : DateFormat('yyyy-MM-dd').format(_fechaNac!)),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1900), lastDate: DateTime.now());
                  if (picked != null) setState(() => _fechaNac = picked);
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _crearCuenta,
                child: Text("REGISTRARME"),
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
              )
            ],
          ),
        ),
      ),
    );
  }
}