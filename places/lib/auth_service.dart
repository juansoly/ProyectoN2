import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://api.aotcservis.org:8080/api/v1/auth";

  // LOGIN
  Future<bool> iniciarSesion(String usuario, String contrasena) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"usuario": usuario, "contrasena": contrasena}),
      );

      // --- DEBUG: ESTO TE DIRÁ POR QUÉ NO RECIBES EL TOKEN ---
      print("Respuesta del servidor: ${response.statusCode}");
      print("Cuerpo de la respuesta: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // POSIBILIDAD 1: El token está dentro de un campo llamado 'token'
        // POSIBILIDAD 2: El token es el cuerpo entero de la respuesta
        // POSIBILIDAD 3: El campo se llama 'jwt' o 'accessToken'

        // Intenta extraerlo así (ajusta 'token' si en la consola ves otro nombre)
        String token = "";
        if (data is Map && data.containsKey('token')) {
          token = data['token'];
        } else {
          token = response.body; // A veces el backend devuelve solo el string del token
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        return true;
      }
      return false;
    } catch (e) {
      print("Error en login: $e");
      return false;
    }
  }

  // REGISTRO
  Future<bool> registrarUsuario(Map<String, dynamic> datos) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(datos),
      );
      print("Registro status: ${response.statusCode}");
      print("Registro body: ${response.body}");
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error en registro: $e");
      return false;
    }
  }
}