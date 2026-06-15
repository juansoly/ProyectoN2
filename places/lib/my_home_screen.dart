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
      // Ya no usamos Stack, usamos directamente el PageView para cada lugar
      body: PageView.builder(
        itemCount: lugares.length,
        itemBuilder: (context, index) {
          final lugar = lugares[index];

          // Cada página es un ListView independiente que contiene su propia info
          return ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // Imagen del lugar
              Container(
                height: 350,
                width: double.infinity,
                child: CardImage(lugar['url'] ?? '', lugar['id_lugares'] ?? 0),
              ),

              // Título y descripción asociados a esta imagen
              Container(
                margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                child: DescriptionPlace(
                  lugar['nombre'] ?? 'Sin nombre',
                  5, // Rating
                  lugar['descripcion'] ?? 'Sin descripción',
                ),
              ),

              // Reviews del lugar
              Container(
                margin: EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 50),
                child: ReviewList(),
              ),
            ],
          );
        },
      ),
    );
  }
}