import 'package:flutter/material.dart';
import 'package:places/rounded.dart';
// Asegúrate de importar tu pantalla de perfil donde corresponda
// import 'package:places/profile_screen.dart';

class DescriptionPlace extends StatelessWidget {
  final String textoTitulo;
  final int cantidadEstrellas;
  final String textoDescripcion;

  DescriptionPlace(this.textoTitulo, this.cantidadEstrellas, this.textoDescripcion);

  @override
  Widget build(BuildContext context) {
    final titulo = Text(
      textoTitulo,
      style: TextStyle(
          fontFamily: "Lato",
          fontSize: 30,
          fontWeight: FontWeight.bold),
      overflow: TextOverflow.ellipsis,
    );

    final filaEstrellas = Row(
      children: List.generate(5, (index) {
        return Icon(
          index < cantidadEstrellas ? Icons.star : Icons.star_border,
          color: Colors.amber,
        );
      }),
    );

    final filaTitulo = Row(
      children: <Widget>[
        Flexible(child: titulo),
        Container(margin: EdgeInsets.only(left: 10), child: filaEstrellas)
      ],
    );

    final descripcion = Container(
      margin: EdgeInsets.only(top: 10, right: 20),
      child: Text(
        textoDescripcion,
        style: TextStyle(fontFamily: "Lato", color: Colors.black54),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        filaTitulo,
        descripcion,
        // CORRECCIÓN: Pasamos el onPressed aquí
        RoundedButton(
          textoBoton: "Navigate",
          onPressed: () {
            // Lógica de navegación
            print("Navegando a detalles...");
            /* Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
            */
          },
        )
      ],
    );
  }
}