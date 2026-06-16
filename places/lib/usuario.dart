// lib/usuario.dart
class Usuario {
  final String nombre;
  final String email;

  Usuario({required this.nombre, required this.email});

  // Esto ayuda a convertir datos planos a un objeto estructurado
  factory Usuario.desdePreferencias(String nombre, String email) {
    return Usuario(
      nombre: nombre.isEmpty ? "Usuario" : nombre,
      email: email.isEmpty ? "Sin email" : email,
    );
  }
}