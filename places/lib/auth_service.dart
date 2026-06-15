import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://api.aotcservis.org:8080/api/v1";

  // --- MÉTODO AUXILIAR PARA HEADERS ---
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
  }

  // --- 1. OBTENER PERFIL (EL QUE NECESITAMOS) ---
  Future<Map<String, dynamic>> obtenerPerfilUsuario(int idUsuario) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/usuarios/$idUsuario'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      return {"nombre": "No encontrado"};
    } catch (e) {
      return {"nombre": "Error de conexión"};
    }
  }

  // --- 2. LOGIN ---
  Future<bool> iniciarSesion(String usuario, String contrasena) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"usuario": usuario, "contrasena": contrasena}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();

        // Guardamos el token y el ID del usuario
        await prefs.setString('token', data['token'] ?? "");
        // Asegúrate de que el backend envíe 'idUsuario'
        await prefs.setInt('userId', data['idUsuario'] ?? 0);

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // --- 3. REGISTRO ---
  Future<bool> registrarUsuario(Map<String, dynamic> datos) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(datos),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // --- 4. FAVORITOS ---
  Future<bool> verificarLike(int idLugar) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/favoritos/verificar/$idLugar'),
        headers: headers,
      );
      return response.statusCode == 200 && response.body.toLowerCase() == 'true';
    } catch (e) {
      return false;
    }
  }

  Future<String?> toggleLike(int idLugar) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/favoritos'),
        headers: headers,
        body: jsonEncode({"idLugares": idLugar}),
      );
      return (response.statusCode == 200) ? response.body : null;
    } catch (e) {
      return null;
    }
  }

  // --- 5. LUGARES ---
  Future<List<dynamic>> obtenerLugares() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse('$baseUrl/lugares'), headers: headers);
      return (response.statusCode == 200) ? jsonDecode(utf8.decode(response.bodyBytes)) : [];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> buscarLugares(String nombre) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/lugares/buscar?nombre=$nombre'),
        headers: headers,
      );
      return (response.statusCode == 200) ? jsonDecode(utf8.decode(response.bodyBytes)) : [];
    } catch (e) {
      return [];
    }
  }
}