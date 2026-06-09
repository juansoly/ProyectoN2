class Lugar {
  final int idLugares;
  final String nombre;
  final String descripcion;
  final String url;
  // ... resto de campos

  Lugar({required this.idLugares, required this.nombre, required this.descripcion, required this.url});

  factory Lugar.fromJson(Map<String, dynamic> json) {
    return Lugar(
      idLugares: json['idLugares'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      url: json['url'],
    );
  }
}