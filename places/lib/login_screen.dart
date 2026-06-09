import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'places_cupertino.dart';
import 'profile_places.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _realizarLogin() async {
    if (_userController.text.trim().isEmpty || _passController.text.trim().isEmpty) {
      _mostrarMensaje(false, "Por favor, completa los campos.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      bool ok = await _authService.iniciarSesion(
          _userController.text.trim(),
          _passController.text.trim()
      );

      setState(() => _isLoading = false);

      if (ok) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PlacesCupertino())
        );
      } else {
        _mostrarMensaje(false, "Credenciales incorrectas.");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _mostrarMensaje(false, "Error de conexión con el servidor.");
    }
  }

  void _mostrarMensaje(bool ok, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje), backgroundColor: ok ? Colors.green : Colors.red)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
        child: Column(
          children: [
            SizedBox(height: 50),
            Text("Bienvenido a Places", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 50),

            // Si no tienes la imagen, esto dará error.
            // Si no tienes el logo, usa: Icon(Icons.location_on, size: 100, color: Colors.white)
            Icon(Icons.location_on, size: 120, color: Colors.white),

            SizedBox(height: 50),

            _buildTextField(_userController, "Usuario", Icons.person_outline),
            SizedBox(height: 20),
            _buildTextField(_passController, "Contraseña", Icons.lock_outline, obscure: true),

            SizedBox(height: 40),

            _isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blueAccent,
                minimumSize: Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: _realizarLogin,
              child: Text("ENTRAR", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePlaces())),
              child: Text("¿No tienes cuenta? Regístrate aquí", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      ),
    );
  }
}