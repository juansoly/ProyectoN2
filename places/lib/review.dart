import 'package:flutter/material.dart';
class Review extends StatelessWidget{
  //variables
  String pathFoto;
  String TextoNombreUsuario;
  String textoResumenUsuario;
  int cantidadEstrellas;
  String textoComentario;
  //metodo constructor
  Review(this.pathFoto,this.TextoNombreUsuario,this.textoResumenUsuario,this.cantidadEstrellas,this.textoComentario);
  @override
  Widget build(BuildContext context) {
    //foto
    final foto= Container(
      margin: EdgeInsets.only(
        right: 10
      ),
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(
            "assets/images/persona1.jpeg"

          ),
            fit: BoxFit.cover
        )
      ),

    );
    //nombre del usuario
    final nombreUsuario = Container(
      child: Text(
        TextoNombreUsuario,
        style: TextStyle(
          fontFamily: "Lato",
          fontSize: 22
        ),
      ),

    );
    //resumenUsuario
    final resumenUsuario = Container(
      margin: EdgeInsets.only(
        right: 10
      ),
      child: Text(
        textoResumenUsuario,
        style: TextStyle(
          fontFamily: "Lato",
          color: Colors.black54
      ),
      ),
    );
    //estrella normal
    final estrella = Container(
      margin: EdgeInsets.only(
          right: 5
      ),
      child: Icon(
        Icons.star,
        color:Colors.amber,
        size: 18,
      ),
    );
    //estrella borde
    final estrellaBorde = Container(
      margin: EdgeInsets.only(
          right: 5
      ),
      child: Icon(
        Icons.star_border,
        color: Colors.black54,
        size: 18,
      ),
    );
    //Fila estrella
    List <Container> estrellas = [];
    for(int i=0; i<5; i++){
      if(i < cantidadEstrellas) {
        estrellas.add(estrella);
      }else{
        estrellas.add(estrellaBorde);
      }
    }

    final filaEstrellas = Row(
      children:estrellas,
    );

    //fila resumen
    final filaResumen = Row(
      children:<Widget> [
        resumenUsuario,
        filaEstrellas
      ],
    );
    //comentario
    final comentario = Container(
      child: Text(
        textoComentario,
        style: TextStyle(
          fontFamily: "Lato",

        ),

      ),
    );

    //columna review
    final columnaReview = Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        nombreUsuario,
        filaResumen,
        comentario

      ],
    );
    //review
    final review = Row(
      children: < Widget>[
        foto,
        columnaReview
      ],
    );
   return review;
  }

}