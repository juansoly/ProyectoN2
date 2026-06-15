import 'package:flutter/material.dart';
import 'package:places/auth_service.dart';

class SearchPlaces extends StatefulWidget {
  @override
  _SearchPlacesState createState() => _SearchPlacesState();
}

class _SearchPlacesState extends State<SearchPlaces> {
  final AuthService _authService = AuthService();
  List _resultados = [];

  // Esta función llama a tu backend en AWS
  void _buscar(String query) async {
    final resultados = await _authService.buscarLugares(query);
    setState(() {
      _resultados = resultados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buscar Lugares")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(hintText: "Escribe el nombre del lugar..."),
              onChanged: (valor) => _buscar(valor), // ¡Aquí ocurre la magia con el backend!
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _resultados.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_resultados[index]['nombre']),
                  subtitle: Text("Resultado desde AWS"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}