import 'package:flutter/material.dart';
import 'auth_service.dart'; // Tu puente de conexión hacia AWS

class ProfilePlaces extends StatefulWidget {
  @override
  _ProfilePlacesState createState() => _ProfilePlacesState();
}

class _ProfilePlacesState extends State<ProfilePlaces> {
  // Controladores para capturar el texto de las cajas de entrada
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _estaCargando = false;

  // Controla qué vista mostrar por defecto: true = Iniciar Sesión / false = Crear Cuenta
  bool _esModoLogin = true;

  @override
  void dispose() {
    // Liberamos la memoria de los controladores al destruir el componente
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título cambiante según el estado de la pantalla
              Text(
                _esModoLogin ? "Iniciar Sesión" : "Únete a Places",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Lato',
                ),
              ),
              SizedBox(height: 8),
              Text(
                _esModoLogin
                    ? "Ingresa tus credenciales para acceder a tu perfil."
                    : "Crea tu cuenta para guardar tus destinos favoritos en la nube.",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 40),

              // El campo 'Nombre de usuario' SOLOS se dibuja si estamos registrando una cuenta nueva
              if (!_esModoLogin) ...[
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: "Nombre de usuario",
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 16),
              ],

              // Campo de entrada: Correo Electrónico (Requerido en Login y Registro)
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Correo electrónico",
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16),

              // Campo de entrada: Contraseña (Requerido en Login y Registro)
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 30),

              // Botón de acción principal
              SizedBox(
                width: double.infinity,
                height: 50,
                child: _estaCargando
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    // Validaciones iniciales para que no mande campos vacíos a AWS
                    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Por favor, llena los campos requeridos"), backgroundColor: Colors.orange),
                      );
                      return;
                    }
                    if (!_esModoLogin && _usernameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Por favor, ingresa tu nombre de usuario"), backgroundColor: Colors.orange),
                      );
                      return;
                    }

                    setState(() => _estaCargando = true);

                    if (_esModoLogin) {
                      // =========================================================
                      // ACCIÓN: INICIAR SESIÓN (LOGIN REAL CON EL NUEVO MÉTODO)
                      // =========================================================
                      bool funcionoLogin = await _authService.iniciarSesion(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );

                      if (mounted) setState(() => _estaCargando = false);

                      if (funcionoLogin) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("¡Sesión iniciada con éxito! 🎉"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Credenciales incorrectas o usuario inexistente."),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }

                    } else {
                      // =========================================================
                      // ACCIÓN: REGISTRO DE CUENTA NUEVA
                      // =========================================================
                      bool funcionoRegistro = await _authService.registrarUsuario(
                        _usernameController.text.trim(),
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );

                      if (mounted) setState(() => _estaCargando = false);

                      if (funcionoRegistro) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("¡Cuenta creada con éxito! Ahora puedes logearte."),
                              backgroundColor: Colors.green,
                            ),
                          );
                          // Tras registrarse con éxito, cambiamos la vista al Login de inmediato
                          setState(() {
                            _esModoLogin = true;
                            _usernameController.clear();
                          });
                        }
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Fallo al registrar. El usuario o correo ya existen."),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: Text(
                    _esModoLogin ? "INICIAR SESIÓN" : "CREAR CUENTA",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Texto interactivo en la parte inferior para saltar entre Login y Registro
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _esModoLogin = !_esModoLogin; // Invierte el estado de la pantalla
                    });
                  },
                  child: Text(
                    _esModoLogin
                        ? "¿No tienes una cuenta? Regístrate aquí"
                        : "¿Ya tienes una cuenta? Inicia sesión",
                    style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}