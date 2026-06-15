import 'package:flutter/material.dart';
import 'auth_service.dart'; // Asegúrate de importar tu servicio

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  List _listaLugares = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarLugares();
  }

  void _cargarLugares() async {
    var datos = await _authService.obtenerLugares();
    setState(() {
      _listaLugares = datos;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _cargando
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Dos columnas como en tu foto
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _listaLugares.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Expanded(child: Image.network(_listaLugares[index]['url'], fit: BoxFit.cover)),
                Text(_listaLugares[index]['nombre']),
              ],
            ),
          );
        },
      ),
    );
  }
}