import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://api.aotcservis.org:8080/api/v1";

  // --- CABECERAS CENTRALIZADAS ---
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      return {"Content-Type": "application/json"};
    }
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
  }

  // --- 1. LOGIN ---
  Future<bool> iniciarSesion(String usuario, String contrasena) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"usuario": usuario, "contrasena": contrasena}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await prefs.setString('token', data['token'] ?? "");
        await prefs.setInt('userId', data['idUsuario'] ?? 0);
        return true;
      }
      return false;
    } catch (e) {
      print("Error en Login: $e");
      return false;
    }
  }

  // --- 2. OBTENER PERFIL ---
  Future<Map<String, dynamic>> obtenerPerfilUsuario(int idUsuario) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse('$baseUrl/usuarios/$idUsuario'), headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final persona = data['persona'] ?? {};
        return {"nombre": persona['nombre'] ?? "Sin nombre", "email": persona['email'] ?? "Sin email"};
      }
      return {"nombre": "No encontrado", "email": "No encontrado"};
    } catch (e) {
      return {"nombre": "Error", "email": "Error"};
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
      final response = await http.get(Uri.parse('$baseUrl/favoritos/verificar/$idLugar'), headers: headers);
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
      final response = await http.get(Uri.parse('$baseUrl/lugares/buscar?nombre=$nombre'), headers: headers);
      return (response.statusCode == 200) ? jsonDecode(utf8.decode(response.bodyBytes)) : [];
    } catch (e) {
      return [];
    }
  }

  // --- 6. COMENTARIOS ---

  // PÚBLICO: Obtener comentarios sin cabecera de autenticación
  Future<List<dynamic>> obtenerComentariosPorLugar(int idLugar) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/comentarios/lugar/$idLugar'),
        headers: {"Content-Type": "application/json"},
      );
      return (response.statusCode == 200) ? jsonDecode(utf8.decode(response.bodyBytes)) : [];
    } catch (e) {
      print("Error al cargar comentarios: $e");
      return [];
    }
  }

  // PRIVADO: Guardar comentario con el token en los headers
  Future<bool> guardarComentario(int idLugar, String texto, int calificacion) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final int idUsuario = prefs.getInt('userId') ?? 0;
      final headers = await _getHeaders();

      // Validación de seguridad antes de enviar
      if (idUsuario == 0 || !headers.containsKey("Authorization")) {
        print("Usuario no autenticado para comentar.");
        return false;
      }

      final String fechaHoy = DateTime.now().toString().substring(0, 10);

      final response = await http.post(
        Uri.parse('$baseUrl/comentarios'),
        headers: headers,
        body: jsonEncode({
          "textoComentario": texto,
          "calificacion": calificacion,
          "idLugares": idLugar,
          "idPersonas": idUsuario,
          "fechaComentario": fechaHoy,
          "comentarioPadre": null
        }),
      );

      print("DEBUG RESPUESTA: ${response.statusCode} - ${response.body}");
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error al guardar: $e");
      return false;
    }
  }
}