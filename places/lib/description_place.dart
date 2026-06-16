import 'package:flutter/material.dart';
import 'package:places/rounded.dart';
import 'comentarios_screen.dart';
import 'nuevo_comentario_screen.dart'; // Asegúrate de importar tu nueva pantalla

class DescriptionPlace extends StatelessWidget {
  final String textoTitulo;
  final int cantidadEstrellas;
  final String textoDescripcion;
  final int idLugar;

  DescriptionPlace(this.textoTitulo, this.cantidadEstrellas, this.textoDescripcion, this.idLugar);

  @override
  Widget build(BuildContext context) {
    final titulo = Text(
      textoTitulo,
      style: TextStyle(fontFamily: "Lato", fontSize: 30, fontWeight: FontWeight.bold),
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
        Padding(
          padding: const EdgeInsets.only(top: 20.0, right: 20.0),
          child: Row(
            children: [
              Expanded(
                child: RoundedButton(
                  textoBoton: "Ver comentarios",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ComentariosScreen(idLugar: idLugar),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: RoundedButton(
                  textoBoton: "Comentar",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NuevoComentarioScreen(idLugar: idLugar),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}