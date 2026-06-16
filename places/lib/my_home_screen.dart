import 'package:flutter/material.dart';
import 'package:places/auth_service.dart';
import 'package:places/card_image.dart';
import 'package:places/description_place.dart';
import 'package:places/review_list.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<dynamic> lugares = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _fetchLugares();
  }

  void _fetchLugares() async {
    final data = await AuthService().obtenerLugares();
    if (mounted) {
      setState(() {
        lugares = data;
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: PageView.builder(
              itemCount: lugares.length,
              itemBuilder: (context, index) {
                final lugar = lugares[index];

                // DEBUG: Si esto imprime 0, mira en la consola cómo se llama tu clave.
                // Podría ser 'id', 'lugarId', o 'idLugares'.
                final int idLugar = lugar['id_lugares'] ?? 0;
                print("Lugar cargado: ${lugar['nombre']} - ID: $idLugar");

                return ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Container(
                      height: 350,
                      width: double.infinity,
                      child: CardImage(lugar['url'] ?? '', idLugar),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: DescriptionPlace(
                        lugar['nombre'] ?? 'Sin nombre',
                        5,
                        lugar['descripcion'] ?? 'Sin descripción',
                        idLugar,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 10),
              child: ReviewList(),
            ),
          ),
        ],
      ),
    );
  }
}