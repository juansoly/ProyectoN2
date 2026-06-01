import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Base URL de tu servidor en AWS Docker
  final String _baseUrl = 'http://api.aotcservis.org:8080/api';

  // =========================================================================
  // MÉTODO 1: REGISTRAR UN NUEVO USUARIO
  // =========================================================================
  Future<bool> registrarUsuario(String username, String email, String password) async {
    final url = Uri.parse('$_baseUrl/users');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'user': {
            'username': username,
            'email': email,
            'password': password,
          }
        }),
      );

      // Tu backend suele responder con un código de éxito 200 o 201
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("¡Usuario registrado con éxito en AWS!");
        print("Respuesta del servidor: ${response.body}");
        return true;
      } else {
        print("Error en el registro. Código de estado: ${response.statusCode}");
        print("Respuesta del servidor: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error de red al intentar registrar: $e");
      return false;
    }
  }

  // =========================================================================
  // MÉTODO 2: INICIAR SESIÓN (LOGIN REAL)
  // =========================================================================
  Future<bool> iniciarSesion(String email, String password) async {
    final url = Uri.parse('$_baseUrl/users/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'user': {
            'email': email,
            'password': password,
          }
        }),
      );

      // Tu Spring Boot basado en RealWorld devuelve 200 OK en accesos correctos
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("¡Sesión iniciada con éxito en tu Spring Boot!");
        print("Respuesta del servidor (con Token JWT): ${response.body}");
        return true;
      } else {
        print("Error en el login. Código de estado: ${response.statusCode}");
        print("Respuesta del servidor: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error de red al intentar logear: $e");
      return false;
    }
  }
}